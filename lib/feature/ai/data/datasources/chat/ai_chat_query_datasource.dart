import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_session_dto.dart';

/// AI 对话查询数据源（仅允许返回 DTO）
class AiChatQueryDatasource {
  final PiniaStorage _storage;

  AiChatQueryDatasource({required PiniaStorage storage}) : _storage = storage;

  String _getSessionIndexKey(String packageName) => 'ai_sessions_$packageName';

  /// 构建独立会话的存储空间 (XML 文件名)
  String _getChatSpace(String sessionId, String packageName) =>
      'chat_${sessionId}_$packageName';

  String _getChatConfigSpace(String packageName) =>
      'chat_config_$packageName';

  /// 会话内容在独立空间中的固定 Key
  static const String _chatContentKey = 'messages';
  static const String _chatConfigKey = 'config';

  /// 获取会话列表 (返回 DTO)
  Future<List<AiSessionDto>> getSessions(String packageName) async {
    final json = await _storage.getString(_getSessionIndexKey(packageName));
    if (json.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(json);
      return list
          .map((e) => AiSessionDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 获取最后活跃会话
  Future<String?> getLastActiveSessionId(String packageName) async {
    final sessionId = await _storage.getString(
      _chatConfigKey,
      space: _getChatConfigSpace(packageName),
    );
    if (sessionId.isEmpty) return null;
    return sessionId;
  }

  /// 获取消息历史 (返回 DTO)
  Future<List<AiMessageDto>> getChatHistory(
    String packageName,
    String sessionId,
  ) async {
    final space = _getChatSpace(sessionId, packageName);
    final json = await _storage.getString(_chatContentKey, space: space);
    if (json.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(json);
      return list
          .map((e) => AiMessageDto.fromStorageJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}