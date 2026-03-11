import 'dart:convert';

import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/network/http_service.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_session_dto.dart';
import 'package:JsxposedX/feature/ai/data/services/anthropic_api_service.dart';
import 'package:JsxposedX/feature/ai/data/services/openai_api_service.dart';
import 'package:JsxposedX/feature/ai/domain/services/ai_api_service.dart';

/// AI 对话操作数据源（仅允许操作 DTO）
class AiChatActionDatasource {
  final HttpService _httpService;
  final PiniaStorage _storage;
  late final AiApiService _openAiService;
  late final AiApiService _anthropicService;

  AiChatActionDatasource({
    required HttpService httpService,
    required PiniaStorage storage,
  })  : _httpService = httpService,
        _storage = storage {
    _openAiService = OpenAiApiService(httpService: httpService);
    _anthropicService = AnthropicApiService(httpService: httpService);
  }

  /// 根据配置获取对应的 API 服务
  AiApiService _getApiService(AiConfig config) {
    switch (config.apiType) {
      case AiApiType.openai:
        return _openAiService;
      case AiApiType.anthropic:
        return _anthropicService;
    }
  }

  String _getSessionIndexKey(String packageName) => 'ai_sessions_$packageName';

  /// 构建独立会话的存储空间 (XML 文件名)
  String _getChatSpace(String sessionId, String packageName) =>
      'chat_${sessionId}_$packageName';

  String _getChatConfigSpace(String packageName) =>
      'chat_config_$packageName';

  /// 会话内容在独立空间中的固定 Key
  static const String _chatContentKey = 'messages';
  static const String _chatConfigKey = 'config';

  /// 发送流式对话请求
  Stream<AiMessageDto> postChatStream({
    required AiConfig config,
    required List<AiMessageDto> messages,
    List<Map<String, dynamic>>? tools,
  }) async* {
    print(
      'TESTAI: Datasource - postChatStream 被调用, messages.length=${messages.length}, tools=${tools?.length}',
    );
    print('TESTAI: Datasource - API类型: ${config.apiType}');

    final apiService = _getApiService(config);
    print('TESTAI: Datasource - 获取到 API 服务: ${apiService.runtimeType}');
    print('TESTAI: Datasource - 调用 apiService.sendChatStream');

    await for (final dto
        in apiService.sendChatStream(
          config: config,
          messages: messages,
          tools: tools,
        )) {
      print('TESTAI: Datasource - 收到 DTO, role=${dto.role}, content.length=${dto.content.length}');
      yield dto;
    }
    print('TESTAI: Datasource - sendChatStream 流结束');
  }

  /// 测试连接
  Future<String> testConnection(AiConfig config) async {
    final apiService = _getApiService(config);
    return await apiService.testConnection(config);
  }

  /// 持久化会话索引 (接收 DTO 列表) - 仍存储在全局索引中
  Future<void> saveSessionsIndex(
    String packageName,
    List<AiSessionDto> sessionsDtos,
  ) async {
    final json = jsonEncode(sessionsDtos.map((e) => e.toJson()).toList());
    await _storage.setString(_getSessionIndexKey(packageName), json);
  }

  /// 持久化最后活跃会话
  Future<void> saveLastActiveSessionId(
    String packageName,
    String sessionId,
  ) async {
    await _storage.setString(
      _chatConfigKey,
      sessionId,
      space: _getChatConfigSpace(packageName),
    );
  }

  /// 清除最后活跃会话
  Future<void> clearLastActiveSessionId(String packageName) async {
    await _storage.remove(
      _chatConfigKey,
      space: _getChatConfigSpace(packageName),
    );
  }

  /// 持久化对话内容 (进入独立存储空间)
  Future<void> saveChatHistory(
    String packageName,
    String sessionId,
    List<AiMessageDto> messagesDtos,
  ) async {
    final json = jsonEncode(messagesDtos.map((e) => e.toStorageJson()).toList());
    final space = _getChatSpace(sessionId, packageName);
    await _storage.setString(_chatContentKey, json, space: space);
  }

  /// 物理删除存储空间 (删除对应的 XML)
  Future<void> removeChatHistory(String packageName, String sessionId) async {
    final space = _getChatSpace(sessionId, packageName);
    await _storage.clear(space: space);
  }
}