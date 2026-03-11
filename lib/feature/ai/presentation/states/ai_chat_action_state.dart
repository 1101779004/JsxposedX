import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/models/ai_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_action_state.freezed.dart';

@freezed
abstract class AiChatActionState with _$AiChatActionState {
  const AiChatActionState._();

  const factory AiChatActionState({
    @Default([]) List<AiMessage> messages, // 当前显示的（分页后）
    @Default([]) List<AiMessage> allMessages, // 完整的历史记录
    @Default([]) List<AiSession> sessions,
    @Default(false) bool isStreaming,
    @Default(null) String? error,
    @Default(null) String? currentSessionId,
    // APK分析上下文
    @Default(null) String? systemPrompt,
    @Default(null) String? apkSessionId,
    @Default([]) List<String> dexPaths,
  }) = _AiChatActionState;

  List<AiMessage> get visibleMessages => allMessages
      .where((message) => message.shouldDisplayInChatList)
      .toList(growable: false);

  int get visibleMessagesCount => visibleMessages.length;
}
