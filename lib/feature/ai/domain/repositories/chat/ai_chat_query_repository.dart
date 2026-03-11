import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/models/ai_session.dart';

/// AI 对话查询仓储接口
abstract class AiChatQueryRepository {
  Future<List<AiSession>> getSessions(String packageName);

  Future<List<AiMessage>> getChatHistory(String packageName, String sessionId);

  Future<String?> getLastActiveSessionId(String packageName);
}