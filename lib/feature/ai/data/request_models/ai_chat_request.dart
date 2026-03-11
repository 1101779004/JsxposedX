import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_request.freezed.dart';
part 'ai_chat_request.g.dart';

@freezed
abstract class AiChatRequest with _$AiChatRequest {
  const factory AiChatRequest({
    required String model,
    required List<AiMessageDto> messages,
    @Default(true) bool stream,
    @Default(0.7) double temperature,
    @Default(300) int maxTokens,
    @JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools,
  }) = _AiChatRequest;

  factory AiChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AiChatRequestFromJson(json);
}
