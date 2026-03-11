import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/models/ai_session.dart';
import 'package:JsxposedX/feature/ai/data/datasources/chat/ai_chat_action_datasource.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_session_dto.dart';
import 'package:JsxposedX/feature/ai/domain/repositories/chat/ai_chat_action_repository.dart';

/// AI 对话操作仓储实现（负责 Entity <-> DTO 显式映射）
class AiChatActionRepositoryImpl implements AiChatActionRepository {
  final AiChatActionDatasource dataSource;

  AiChatActionRepositoryImpl({required this.dataSource});

  @override
  Stream<AiMessage> getChatStream({
    required AiConfig config,
    required List<AiMessage> messages,
    List<Map<String, dynamic>>? tools,
  }) {
    print(
      'TESTAI: Repository - getChatStream 被调用, messages.length=${messages.length}, tools=${tools?.length}',
    );
    print('TESTAI: Repository - 消息角色: ${messages.map((m) => m.role).join(", ")}');

    final messageDtos = messages
        .map(
          (m) => AiMessageDto(
            role: m.role,
            content: m.content,
            toolCalls: m.toolCalls,
            toolCallId: m.toolCallId,
          ),
        )
        .toList();

    for (int i = 0; i < messages.length; i++) {
      final m = messages[i];
      print(
        'TESTAI: Repository - Message[$i]: role=${m.role}, content.length=${m.content.length}, hasToolCalls=${m.toolCalls != null}, toolCallId=${m.toolCallId}',
      );
      if (m.toolCalls != null) {
        print('TESTAI: Repository - Message[$i] toolCalls: ${m.toolCalls}');
      }
    }

    print('TESTAI: Repository - 调用 dataSource.postChatStream');
    return dataSource
        .postChatStream(config: config, messages: messageDtos, tools: tools)
        .map((dto) {
          print(
            'TESTAI: Repository - 收到 DTO, role=${dto.role}, content.length=${dto.content.length}, hasToolCalls=${dto.hasToolCalls}',
          );
          return dto.toEntity();
        });
  }

  @override
  Future<String> testConnection(AiConfig config) async {
    return await dataSource.testConnection(config);
  }

  @override
  Future<void> saveSessions(String packageName, List<AiSession> sessions) async {
    final dtos = sessions
        .map(
          (e) => AiSessionDto(
            id: e.id,
            name: e.name,
            packageName: e.packageName,
            lastUpdateTime: e.lastUpdateTime.toIso8601String(),
            lastMessage: e.lastMessage,
          ),
        )
        .toList();

    await dataSource.saveSessionsIndex(packageName, dtos);
  }

  @override
  Future<void> saveChatHistory(
    String packageName,
    String sessionId,
    List<AiMessage> messages,
  ) async {
    final dtos = messages
        .map(
          (m) => AiMessageDto(
            id: m.id,
            role: m.role,
            content: m.content,
            isError: m.isError,
            toolCalls: m.toolCalls,
            toolCallId: m.toolCallId,
            isToolResultBubble: m.isToolResultBubble,
          ),
        )
        .toList();

    await dataSource.saveChatHistory(packageName, sessionId, dtos);
  }

  @override
  Future<void> saveLastActiveSessionId(
    String packageName,
    String sessionId,
  ) async {
    await dataSource.saveLastActiveSessionId(packageName, sessionId);
  }

  @override
  Future<void> clearLastActiveSessionId(String packageName) async {
    await dataSource.clearLastActiveSessionId(packageName);
  }

  @override
  Future<void> deleteSession(String packageName, String sessionId) async {
    await dataSource.removeChatHistory(packageName, sessionId);
  }
}