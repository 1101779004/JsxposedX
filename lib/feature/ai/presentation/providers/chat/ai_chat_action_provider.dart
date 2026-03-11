import 'dart:async';
import 'dart:convert';

import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/models/ai_session.dart';
import 'package:JsxposedX/core/network/http_service.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/datasources/chat/ai_chat_action_datasource.dart';
import 'package:JsxposedX/feature/ai/data/prompts/system_prompts.dart';
import 'package:JsxposedX/feature/ai/data/repositories/chat/ai_chat_action_repository_impl.dart';
import 'package:JsxposedX/feature/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/feature/ai/domain/repositories/chat/ai_chat_action_repository.dart';
import 'package:JsxposedX/feature/ai/domain/services/prompt_builder.dart';
import 'package:JsxposedX/feature/ai/domain/services/tool_executor.dart';
import 'package:JsxposedX/feature/ai/presentation/providers/chat/ai_chat_query_provider.dart';
import 'package:JsxposedX/feature/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/feature/ai/presentation/states/ai_chat_action_state.dart';
import 'package:JsxposedX/feature/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/feature/so_analysis/presentation/providers/so_analysis_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ai_chat_action_provider.g.dart';

/// AI 在线状态 Provider
@Riverpod(keepAlive: true)
Future<bool> aiStatus(Ref ref) async {
  final configAsync = ref.watch(aiConfigProvider);
  final config = configAsync.value;

  if (config == null || config.apiUrl.isEmpty) {
    return false;
  }

  try {
    await ref
        .read(aiChatActionProvider(packageName: 'test').notifier)
        .testConnection(config);
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
AiChatActionDatasource aiChatActionDatasource(Ref ref) {
  final httpService = ref.watch(httpServiceProvider);
  final PiniaStorage storage = ref.watch(piniaStorageLocalProvider);
  return AiChatActionDatasource(httpService: httpService, storage: storage);
}

@riverpod
AiChatActionRepository aiChatActionRepository(Ref ref) {
  final dataSource = ref.watch(aiChatActionDatasourceProvider);
  return AiChatActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
class AiChatAction extends _$AiChatAction {
  bool _isDisposed = false;

  final _streamingContentController = StreamController<String>.broadcast();
  Stream<String> get streamingContentStream => _streamingContentController.stream;

  @override
  AiChatActionState build({required String packageName}) {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _streamingContentController.close();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isDisposed) {
        _initSessions();
      }
    });
    return const AiChatActionState(isStreaming: false);
  }

  /// 设置 system prompt（由页面在 APK 上下文加载完后调用）
  void setSystemPrompt(String prompt) {
    state = state.copyWith(systemPrompt: prompt);
  }

  /// 设置 APK 分析会话（由页面调用）
  void setApkSession(String sessionId, List<String> dexPaths) {
    state = state.copyWith(apkSessionId: sessionId, dexPaths: dexPaths);
  }

  /// 初始化并加载最近会话
  Future<void> _initSessions() async {
    final sessions = await getSessionsAsync();
    if (sessions.isEmpty) return;

    final lastActiveSessionId = await ref
        .read(aiChatQueryRepositoryProvider)
        .getLastActiveSessionId(packageName);
    if (_isDisposed) return;

    final initialSessionId =
        lastActiveSessionId != null &&
            sessions.any((session) => session.id == lastActiveSessionId)
        ? lastActiveSessionId
        : sessions.first.id;

    await switchSession(initialSessionId);
  }

  /// 异步获取会话列表并同步到状态
  Future<List<AiSession>> getSessionsAsync() async {
    final sessions = await ref
        .read(aiChatQueryRepositoryProvider)
        .getSessions(packageName);
    if (_isDisposed) return sessions;
    sessions.sort((a, b) => b.lastUpdateTime.compareTo(a.lastUpdateTime));
    state = state.copyWith(sessions: List.unmodifiable(sessions));
    return sessions;
  }

  /// 同步获取会话列表 (UI 兼容)
  List<AiSession> getSessions() {
    return state.sessions;
  }

  /// 切换会话
  Future<void> switchSession(String sessionId) async {
    // 清空流式内容，防止旧数据干扰
    if (!_streamingContentController.isClosed) {
      _streamingContentController.add('');
    }

    final messages = await ref
        .read(aiChatQueryRepositoryProvider)
        .getChatHistory(packageName, sessionId);
    if (_isDisposed) return;

    // 重建 isToolResultBubble 标记（从持久化恢复时需要）
    final rebuiltMessages = messages.map((m) {
      final isLegacyToolBubble =
          m.role == 'assistant' &&
          !m.hasToolCalls &&
          !m.isToolResultBubble &&
          (m.content.startsWith('🔧 调用') ||
              m.content.startsWith('✅ `') ||
              m.content.startsWith('❌ `'));

      if (isLegacyToolBubble) {
        return m.copyWith(isToolResultBubble: true);
      }
      return m;
    }).toList(growable: false);

    // 过滤出 UI 应该显示的消息（排除 tool 和 assistant tool_calls）
    final uiMessages = rebuiltMessages
        .where((message) => message.shouldDisplayInChatList)
        .toList(growable: false);

    state = state.copyWith(
      currentSessionId: sessionId,
      allMessages: rebuiltMessages,
      messages: uiMessages.length > 10
          ? List.unmodifiable(uiMessages.sublist(uiMessages.length - 10))
          : List.unmodifiable(uiMessages),
      error: null,
      isStreaming: false,
    );

    await ref
        .read(aiChatActionRepositoryProvider)
        .saveLastActiveSessionId(packageName, sessionId);
  }

  /// 加载更多历史记录
  void loadMore() {
    final visibleMessages = state.visibleMessages;
    if (state.messages.length >= visibleMessages.length) return;

    final currentCount = state.messages.length;
    final totalCount = visibleMessages.length;
    final nextCount = (currentCount + 10).clamp(0, totalCount);

    state = state.copyWith(
      messages: List.unmodifiable(
        visibleMessages.sublist(totalCount - nextCount),
      ),
    );
  }

  /// 创建新会话
  Future<void> createSession(String name) async {
    final sessionId = const Uuid().v4();
    final newSession = AiSession(
      id: sessionId,
      name: name,
      packageName: packageName,
      lastUpdateTime: DateTime.now(),
      lastMessage: '',
    );

    final updatedSessions = [newSession, ...state.sessions];
    await ref
        .read(aiChatActionRepositoryProvider)
        .saveSessions(packageName, updatedSessions);

    state = state.copyWith(
      currentSessionId: sessionId,
      sessions: List.unmodifiable(updatedSessions),
      allMessages: [],
      messages: [],
      error: null,
      isStreaming: false,
    );

    await ref
        .read(aiChatActionRepositoryProvider)
        .saveLastActiveSessionId(packageName, sessionId);
    await _saveChatHistory();
  }

  /// 保存对话记录
  Future<void> _saveChatHistory() async {
    final sessionId = state.currentSessionId;
    if (sessionId == null) return;

    final visibleMessages = state.visibleMessages;
    final lastVisibleMessage = visibleMessages.isNotEmpty
        ? visibleMessages.last.content
        : "";

    try {
      await ref
          .read(aiChatActionRepositoryProvider)
          .saveChatHistory(packageName, sessionId, state.allMessages);

      final index = state.sessions.indexWhere((s) => s.id == sessionId);
      if (index != -1) {
        final updatedSessions = List<AiSession>.from(state.sessions);
        updatedSessions[index] = updatedSessions[index].copyWith(
          lastUpdateTime: DateTime.now(),
          lastMessage: lastVisibleMessage,
        );
        state = state.copyWith(sessions: List.unmodifiable(updatedSessions));
        await ref
            .read(aiChatActionRepositoryProvider)
            .saveSessions(packageName, updatedSessions);
      }
    } catch (e) {
      // ignore
    }
  }

  /// 发送消息
  Future<void> send(String text) async {
    if (state.currentSessionId == null) {
      await createSession(
        "新对话 ${DateTime.now().hour}:${DateTime.now().minute}",
      );
    }

    if (text.trim().isEmpty || state.isStreaming) return;

    final config = ref.read(aiConfigProvider).value;
    if (config == null) {
      state = state.copyWith(error: "AI 配置未加载", isStreaming: false);
      return;
    }

    final userMessage = AiMessage(
      id: const Uuid().v4(),
      role: 'user',
      content: text,
    );
    final assistantPlaceholder = AiMessage(
      id: const Uuid().v4(),
      role: 'assistant',
      content: "",
    );

    state = state.copyWith(
      allMessages: [...state.allMessages, userMessage, assistantPlaceholder],
      messages: [...state.messages, userMessage, assistantPlaceholder],
      isStreaming: true,
      error: null,
    );

    try {
      // 构建 tools 定义（有 APK 会话时启用，无论是否有 systemPrompt）
      final bool useTools = state.apkSessionId != null && state.apkSessionId!.isNotEmpty;
      final toolsJson = useTools
          ? ApkAnalysisTools.all.map((t) => t.toFunctionJson()).toList()
          : null;

      await _sendWithToolLoop(
        config: config,
        userMessage: userMessage,
        assistantPlaceholder: assistantPlaceholder,
        toolsJson: toolsJson,
      );
    } catch (e) {
      final updatedAllMessages = List<AiMessage>.from(state.allMessages);
      if (updatedAllMessages.isNotEmpty) {
        updatedAllMessages[updatedAllMessages.length - 1] = updatedAllMessages
            .last
            .copyWith(isError: true);
      }
      final updatedMessages = List<AiMessage>.from(state.messages);
      if (updatedMessages.isNotEmpty) {
        updatedMessages[updatedMessages.length - 1] = updatedMessages.last
            .copyWith(isError: true);
      }
      state = state.copyWith(
        error: "发送失败: $e",
        allMessages: updatedAllMessages,
        messages: updatedMessages,
        isStreaming: false,
      );
      // 保存失败状态的聊天记录
      await _saveChatHistory();
    }
  }

  /// 带工具调用循环的发送逻辑
  Future<void> _sendWithToolLoop({
    required AiConfig config,
    required AiMessage userMessage,
    required AiMessage assistantPlaceholder,
    List<Map<String, dynamic>>? toolsJson,
    int round = 0,
  }) async {
    final historyCount = (config.memoryRounds.toInt() * 2);
    final historyMessages = state.allMessages.length > historyCount
        ? state.allMessages.sublist(
            (state.allMessages.length - historyCount - 2).toInt(),
            (state.allMessages.length - 2).toInt(),
          )
        : state.allMessages.sublist(
            0,
            (state.allMessages.length - 2).toInt(),
          );

    // 构建消息列表（保留完整的对话历史，包括 tool_calls 和 tool results，但排除给用户看的工具气泡）
    // userMessage 追加隐藏提示词（只发给 API，不存入 state）
    final isZh = state.systemPrompt?.contains('你是 JsxposedX') ?? true;
    final hiddenReminder = isZh ? SystemPrompts.hiddenReminderZh : SystemPrompts.hiddenReminderEn;
    final userMessageWithReminder = userMessage.copyWith(
      content: userMessage.content + hiddenReminder,
    );

    final requestMessages = <AiMessage>[
      if (state.systemPrompt != null && state.systemPrompt!.isNotEmpty)
        AiMessage(id: const Uuid().v4(), role: 'system', content: state.systemPrompt!),
      ...historyMessages.where((m) =>
        m.role == 'user' ||
        m.role == 'tool' ||
        (m.role == 'assistant' && !m.isToolResultBubble)
      ),
      userMessageWithReminder,
    ];

    //print('TESTAI: Provider - systemPrompt 是否存在: ${state.systemPrompt != null}');
    if (state.systemPrompt != null) {
      //print('TESTAI: Provider - systemPrompt 长度: ${state.systemPrompt!.length}');
      //print('TESTAI: Provider - systemPrompt 包含格式规范: ${state.systemPrompt!.contains('工具调用格式规范')}');
    }
    //print('TESTAI: Provider - 开始获取流, toolsJson=${toolsJson?.length}');
    //print('TESTAI: Provider - requestMessages.length=${requestMessages.length}');
    for (int i = 0; i < requestMessages.length; i++) {
      final m = requestMessages[i];
      //print('TESTAI: Provider - requestMessages[$i]: role=${m.role}, content=${m.content.substring(0, m.content.length > 50 ? 50 : m.content.length)}..., hasToolCalls=${m.hasToolCalls}');
    }

    final stream = ref
        .read(aiChatActionRepositoryProvider)
        .getChatStream(
          config: config,
          messages: requestMessages,
          tools: toolsJson,
        );

    String fullContent = "";
    List<Map<String, dynamic>>? receivedToolCalls;
    bool streamHasData = false;

    try {
      //print('TESTAI: Provider - 开始监听流');
      await for (final chunk in stream) {
        if (_isDisposed) break;
        streamHasData = true;
        //print('TESTAI: Provider - 收到 chunk, hasToolCalls=${chunk.hasToolCalls}, content.length=${chunk.content.length}');

        if (chunk.hasToolCalls) {
          receivedToolCalls = chunk.toolCalls;
          //print('TESTAI: Provider - 收到工具调用: ${receivedToolCalls?.length}');
        } else {
          fullContent += chunk.content;
          if (!_streamingContentController.isClosed) {
            _streamingContentController.add(fullContent);
          }
        }
      }
      //print('TESTAI: Provider - 流结束, streamHasData=$streamHasData, fullContent.length=${fullContent.length}, receivedToolCalls=${receivedToolCalls?.length}');
    } catch (e) {
      //print('TESTAI: Provider - 捕获异常: $e');
      if (_isDisposed) return;
      if (fullContent.isNotEmpty) {
        _finishAssistantMessage(assistantPlaceholder, fullContent);
        return;
      }
      rethrow;
    }

    if (_isDisposed) return;

    // 检查流是否返回了任何数据
    // 如果没有数据但也没有工具调用，可能是空响应，使用空内容完成
    if (!streamHasData && receivedToolCalls == null) {
      //print('TESTAI: Provider - 无数据且无工具调用，显示(无响应)');
      _finishAssistantMessage(assistantPlaceholder, fullContent.isEmpty ? '(无响应)' : fullContent);
      return;
    }

    // 判断是否需要执行工具调用
    if (receivedToolCalls != null && receivedToolCalls.isNotEmpty) {
      // 如果 AI 先返回了文本内容，保存到 placeholder
      if (fullContent.isNotEmpty) {
        final updatedAllMessages = List<AiMessage>.from(state.allMessages);
        updatedAllMessages[updatedAllMessages.length - 1] =
            assistantPlaceholder.copyWith(content: fullContent);
        final updatedMessages = List<AiMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] =
            assistantPlaceholder.copyWith(content: fullContent);
        state = state.copyWith(
          allMessages: updatedAllMessages,
          messages: updatedMessages,
        );
      }

      await _handleToolCalls(
        config: config,
        userMessage: userMessage,
        assistantPlaceholder: assistantPlaceholder,
        toolCalls: receivedToolCalls,
        toolsJson: toolsJson,
        round: round,
        firstRoundRequestMessages: requestMessages,
      );
    } else {
      // 普通文本回复，更新消息
      _finishAssistantMessage(assistantPlaceholder, fullContent);
    }
  }

  /// 处理工具调用
  Future<void> _handleToolCalls({
    required AiConfig config,
    required AiMessage userMessage,
    required AiMessage assistantPlaceholder,
    required List<Map<String, dynamic>> toolCalls,
    List<Map<String, dynamic>>? toolsJson,
    required int round,
    List<AiMessage>? firstRoundRequestMessages,
  }) async {
    // 解析工具调用
    final calls = toolCalls.map((tc) => AiToolCall.fromJson(tc)).toList();

    // 获取 ToolExecutor（需要 sessionId 和 dexPaths）
    final toolExecutor = _getToolExecutor();
    if (toolExecutor == null) {
      _finishAssistantMessage(
        assistantPlaceholder,
        '工具调用失败：APK 分析会话未初始化',
      );
      return;
    }

    // 工具调用：如果 placeholder 有内容就保留，否则移除
    // 然后添加 assistant tool_calls 消息（用于 API），最后逐个工具插入独立气泡（用于 UI）
    final lastMessage = state.allMessages.last;
    final allWithoutPlaceholder = List<AiMessage>.from(state.allMessages);
    final msgWithoutPlaceholder = List<AiMessage>.from(state.messages);

    // 如果 placeholder 是空的，移除它；如果有内容，保留
    if (lastMessage.content.isEmpty) {
      allWithoutPlaceholder.removeLast();
      msgWithoutPlaceholder.removeLast();
    }

    // 添加 assistant tool_calls 消息（这是真正发送给 API 的消息），只加到 allMessages
    final assistantToolCallsMessage = AiMessage.assistantToolCalls(
      calls.map((call) => {
        'id': call.id,
        'type': 'function',
        'function': {
          'name': call.name,
          'arguments': jsonEncode(call.arguments),
        },
      }).toList(),
    );

    state = state.copyWith(
      allMessages: [...allWithoutPlaceholder, assistantToolCallsMessage],
      messages: msgWithoutPlaceholder,  // UI 不显示 tool_calls 消息
    );

    // 逐个执行工具，每个工具独立一个气泡
    final results = <AiToolResult>[];
    for (final call in calls) {
      final toolBubbleId = const Uuid().v4();
      final toolBubble = AiMessage(
        id: toolBubbleId,
        role: 'assistant',
        content: '🔧 调用 `${call.name}`${call.arguments.isNotEmpty ? '(${call.arguments.entries.map((e) => '${e.key}: ${e.value}').join(', ')})' : ''}...',
        isToolResultBubble: true,
      );

      // 添加工具调用气泡
      final updatedAllMessages = [...state.allMessages, toolBubble];
      final updatedMessages = [...state.messages, toolBubble];
      state = state.copyWith(
        allMessages: updatedAllMessages,
        messages: updatedMessages,
      );

      final result = await toolExecutor.execute(call);
      results.add(result);

      // 添加真正的 tool result 消息（用于 API），只加到 allMessages，不加到 messages（UI）
      final toolResultMessage = AiMessage.toolResult(
        toolCallId: result.toolCallId,
        content: result.content,
      );

      state = state.copyWith(
        allMessages: [...state.allMessages, toolResultMessage],
        // messages 不变，只显示工具气泡
      );

      // 检查是否是关键工具且失败
      if (!result.success && _isCriticalTool(call.name)) {
        // 关键工具失败，更新气泡并中止
        final finishedBubble = toolBubble.copyWith(
          content: '❌ `${call.name}` 执行失败（关键工具）:\n\n${result.content}',
          isToolResultBubble: true,
        );

        final allMsgsCopy = List<AiMessage>.from(state.allMessages);
        final msgsCopy = List<AiMessage>.from(state.messages);

        final allIndex = allMsgsCopy.indexWhere((m) => m.id == toolBubbleId);
        final msgIndex = msgsCopy.indexWhere((m) => m.id == toolBubbleId);

        if (allIndex != -1) allMsgsCopy[allIndex] = finishedBubble;
        if (msgIndex != -1) msgsCopy[msgIndex] = finishedBubble;

        state = state.copyWith(allMessages: allMsgsCopy, messages: msgsCopy);

        // 添加错误消息并中止
        final errorMessage = AiMessage(
          id: const Uuid().v4(),
          role: 'assistant',
          content: '关键工具 `${call.name}` 执行失败，无法继续分析。请检查APK分析会话是否正常。',
          isError: true,
        );
        state = state.copyWith(
          allMessages: [...state.allMessages, errorMessage],
          messages: [...state.messages, errorMessage],
          isStreaming: false,
        );
        // 保存失败状态的聊天记录
        await _saveChatHistory();
        return;
      }

      // 更新工具调用结果 - 显示完整内容给用户
      final fullResult = result.content;

      final finishedBubble = toolBubble.copyWith(
        content: '${result.success ? '✅' : '❌'} `${call.name}`:\n\n$fullResult',
        isToolResultBubble: true,
      );

      // 找到并替换对应的消息，而不是直接替换最后一条
      final allMsgsCopy = List<AiMessage>.from(state.allMessages);
      final msgsCopy = List<AiMessage>.from(state.messages);

      final allIndex = allMsgsCopy.indexWhere((m) => m.id == toolBubbleId);
      final msgIndex = msgsCopy.indexWhere((m) => m.id == toolBubbleId);

      if (allIndex != -1) allMsgsCopy[allIndex] = finishedBubble;
      if (msgIndex != -1) msgsCopy[msgIndex] = finishedBubble;

      state = state.copyWith(allMessages: allMsgsCopy, messages: msgsCopy);
    }

    // 所有工具执行完成后保存聊天记录
    await _saveChatHistory();

    // 插入新 placeholder 给 AI 最终回复
    final newPlaceholder = AiMessage(
      id: const Uuid().v4(),
      role: 'assistant',
      content: '',
    );
    state = state.copyWith(
      allMessages: [...state.allMessages, newPlaceholder],
      messages: [...state.messages, newPlaceholder],
    );
    // 构建第二轮请求：使用第一轮的 requestMessages（如果是第一轮）或重新计算历史窗口
    final List<AiMessage> requestMessages;
    if (round == 0 && firstRoundRequestMessages != null) {
      // 第一轮：使用传入的 requestMessages + 当前轮的 assistant tool_calls + tool results
      final toolResultMessages = results.map((r) {
        return AiMessage.toolResult(
          toolCallId: r.toolCallId,
          content: r.content,
        );
      }).toList();

      requestMessages = <AiMessage>[
        ...firstRoundRequestMessages,
        // assistant 的 tool_calls 消息
        AiMessage.assistantToolCalls(
          calls.map((call) => {
            'id': call.id,
            'type': 'function',
            'function': {
              'name': call.name,
              'arguments': jsonEncode(call.arguments),
            },
          }).toList(),
        ),
        // 每个工具的执行结果
        ...toolResultMessages,
      ];
    } else {
      // 后续轮次：从 state.allMessages 重新计算历史窗口（已包含所有 tool_calls 和 tool results）
      final historyCount = (config.memoryRounds.toInt() * 2);
      final historyMessages = state.allMessages.length > historyCount
          ? state.allMessages.sublist(
              (state.allMessages.length - historyCount - 1).toInt(),
              (state.allMessages.length - 1).toInt(),
            )
          : state.allMessages.sublist(
              0,
              (state.allMessages.length - 1).toInt(),
            );

      requestMessages = <AiMessage>[
        if (state.systemPrompt != null && state.systemPrompt!.isNotEmpty)
          AiMessage(id: const Uuid().v4(), role: 'system', content: state.systemPrompt!),
        // 保留完整的对话历史，包括 tool_calls 和 tool results，但排除给用户看的工具气泡
        ...historyMessages.where((m) =>
          m.role == 'user' ||
          m.role == 'tool' ||
          (m.role == 'assistant' && !m.isToolResultBubble)
        ),
      ];
    }

    // 发送第二轮请求
    //print('TESTAI: _handleToolCalls - 准备发送第二轮请求, requestMessages.length=${requestMessages.length}');
    //print('TESTAI: _handleToolCalls - 请求消息角色: ${requestMessages.map((m) => m.role).join(", ")}');

    final stream = ref
        .read(aiChatActionRepositoryProvider)
        .getChatStream(
          config: config,
          messages: requestMessages,
          tools: toolsJson,
        );

    //print('TESTAI: _handleToolCalls - 已获取第二轮流对象');

    String fullContent = "";
    List<Map<String, dynamic>>? nextToolCalls;
    bool streamHasData = false;

    try {
      //print('TESTAI: _handleToolCalls - 开始监听第二轮流');
      await for (final chunk in stream) {
        //print('TESTAI: _handleToolCalls - 第二轮收到 chunk, hasToolCalls=${chunk.hasToolCalls}, content.length=${chunk.content.length}');
        if (_isDisposed) {
          //print('TESTAI: _handleToolCalls - _isDisposed=true, 退出第二轮流');
          break;
        }
        streamHasData = true;
        if (chunk.hasToolCalls) {
          nextToolCalls = chunk.toolCalls;
          //print('TESTAI: _handleToolCalls - 第二轮收到工具调用: ${nextToolCalls?.length}');
        } else {
          fullContent += chunk.content;
          if (!_streamingContentController.isClosed) {
            _streamingContentController.add(fullContent);
          }
        }
      }
      //print('TESTAI: _handleToolCalls - 第二轮流结束, streamHasData=$streamHasData, fullContent.length=${fullContent.length}, nextToolCalls=${nextToolCalls?.length}');
    } catch (e) {
      //print('TESTAI: _handleToolCalls - 第二轮捕获异常: $e');
      if (_isDisposed) {
        //print('TESTAI: _handleToolCalls - _isDisposed=true, 直接返回');
        return;
      }
      if (fullContent.isNotEmpty) {
        //print('TESTAI: _handleToolCalls - 有部分内容, 完成消息');
        _finishAssistantMessage(newPlaceholder, fullContent);
        return;
      }
      //print('TESTAI: _handleToolCalls - 重新抛出异常');
      rethrow;
    }

    if (_isDisposed) return;

    // 检查流是否返回了任何数据
    // 如果没有数据但也没有工具调用，可能是空响应，使用空内容完成
    if (!streamHasData && nextToolCalls == null) {
      _finishAssistantMessage(newPlaceholder, fullContent.isEmpty ? '(无响应)' : fullContent);
      return;
    }

    // 递归处理（如果 AI 又返回了工具调用）
    if (nextToolCalls != null && nextToolCalls.isNotEmpty) {
      //print('TESTAI: _handleToolCalls - 递归进入第 ${round + 1} 轮');
      await _handleToolCalls(
        config: config,
        userMessage: userMessage,
        assistantPlaceholder: newPlaceholder,
        toolCalls: nextToolCalls,
        toolsJson: toolsJson,
        round: round + 1,
        firstRoundRequestMessages: null,
      );
    } else {
      // AI 返回了文本
      //print('TESTAI: _handleToolCalls - AI 返回文本，完成消息');
      _finishAssistantMessage(newPlaceholder, fullContent);
    }
  }

  /// 估算文本的token数量（粗略估计：1 token ≈ 4 字符）
  int _estimateTokens(String text) {
    return (text.length / 4).ceil();
  }

  /// 判断是否是关键工具（失败时应中止）
  bool _isCriticalTool(String toolName) {
    const criticalTools = [
      'get_manifest',  // Manifest是基础信息
    ];
    return criticalTools.contains(toolName);
  }

  /// 完成 assistant 消息并保存
  void _finishAssistantMessage(AiMessage placeholder, String content) {
    final updatedAllMessages = List<AiMessage>.from(state.allMessages);
    updatedAllMessages[updatedAllMessages.length - 1] =
        placeholder.copyWith(content: content);

    final updatedMessages = List<AiMessage>.from(state.messages);
    updatedMessages[updatedMessages.length - 1] =
        placeholder.copyWith(content: content);

    state = state.copyWith(
      allMessages: updatedAllMessages,
      messages: updatedMessages,
      isStreaming: false,
    );

    _saveChatHistory();
  }

  /// 获取 ToolExecutor（需要外部设置 sessionId 和 dexPaths）
  ToolExecutor? _getToolExecutor() {
    final sessionId = state.apkSessionId;
    if (sessionId == null || sessionId.isEmpty) return null;
    return ToolExecutor(
      repo: ref.read(apkAnalysisQueryRepositoryProvider),
      soDataSource: ref.read(soAnalysisDatasourceProvider),
      sessionId: sessionId,
      dexPaths: state.dexPaths,
    );
  }

  /// 重载消息
  Future<void> retry(int index) async {
    if (index < 0 || index >= state.messages.length || state.isStreaming) {
      return;
    }

    final messageToRetry = state.messages[index];

    // 如果是失败的 assistant 消息，发送"继续"关键词
    String retryText;
    if (messageToRetry.role == 'assistant' && messageToRetry.isError) {
      // 工具调用失败或其他错误，发送"继续"
      retryText = '继续';
    } else if (messageToRetry.role == 'assistant') {
      // 普通 assistant 消息失败，重新发送上一条用户消息
      if (index > 0) {
        retryText = state.messages[index - 1].content;
      } else {
        return;
      }
    } else {
      // 用户消息失败，重新发送该消息
      retryText = messageToRetry.content;
    }

    // Update both lists
    final updatedAllMessages = List<AiMessage>.from(state.allMessages);
    final updatedMessages = List<AiMessage>.from(state.messages);

    // Find correctly in allMessages if possible, but simpler is removing from both by identity or assuming sync
    // For now assume they are synced by reference or index is same for tail
    if (messageToRetry.role == 'assistant') {
      updatedAllMessages.remove(messageToRetry);
      updatedMessages.removeAt(index);
    } else {
      updatedAllMessages.remove(messageToRetry);
      updatedMessages.removeAt(index);
    }

    state = state.copyWith(
      allMessages: updatedAllMessages,
      messages: updatedMessages,
    );
    await send(retryText);
  }

  /// 删除会话
  Future<void> deleteSession(String sessionId) async {
    await ref
        .read(aiChatActionRepositoryProvider)
        .deleteSession(packageName, sessionId);

    final updatedSessions = List<AiSession>.from(state.sessions);
    updatedSessions.removeWhere((s) => s.id == sessionId);
    await ref
        .read(aiChatActionRepositoryProvider)
        .saveSessions(packageName, updatedSessions);

    if (state.currentSessionId == sessionId) {
      if (updatedSessions.isNotEmpty) {
        state = state.copyWith(sessions: List.unmodifiable(updatedSessions));
        await switchSession(updatedSessions.first.id);
      } else {
        state = state.copyWith(
          isStreaming: false,
          messages: [],
          allMessages: [],
          sessions: [],
          currentSessionId: null,
        );
        await ref
            .read(aiChatActionRepositoryProvider)
            .clearLastActiveSessionId(packageName);
      }
    } else {
      state = state.copyWith(sessions: List.unmodifiable(updatedSessions));
    }
  }

  /// 重置流式状态
  void resetStreaming() {
    state = state.copyWith(isStreaming: false);
  }

  /// 测试连接
  Future<String> testConnection(AiConfig config) async {
    return await ref.read(aiChatActionRepositoryProvider).testConnection(config);
  }

  /// 兼容旧代码
  Future<void> deleteHistory() async {
    if (state.currentSessionId != null) {
      await deleteSession(state.currentSessionId!);
    }
  }

  Future<void> clear() async {
    await createSession("新对话 ${DateTime.now().hour}:${DateTime.now().minute}");
  }
}
