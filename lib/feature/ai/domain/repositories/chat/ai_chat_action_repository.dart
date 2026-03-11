import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/models/ai_session.dart';

/// AI 对话操作仓储接口
abstract class AiChatActionRepository {
  /// 获取流式对话
  Stream<AiMessage> getChatStream({
    required AiConfig config,
    required List<AiMessage> messages,
    List<Map<String, dynamic>>? tools,
  });

  /// 测试连接
  Future<String> testConnection(AiConfig config);

  /// 保存会话索引
  Future<void> saveSessions(String packageName, List<AiSession> sessions);

  /// 保存对话历史
  Future<void> saveChatHistory(
    String packageName,
    String sessionId,
    List<AiMessage> messages,
  );

  /// 记录最后活跃会话
  Future<void> saveLastActiveSessionId(String packageName, String sessionId);

  /// 清除最后活跃会话
  Future<void> clearLastActiveSessionId(String packageName);

  /// 删除会话
  Future<void> deleteSession(String packageName, String sessionId);
}