import 'dart:convert';

import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'anthropic_chat_request.freezed.dart';
part 'anthropic_chat_request.g.dart';

/// Anthropic Messages API 请求模型
@Freezed(toJson: true)
abstract class AnthropicChatRequest with _$AnthropicChatRequest {
  const factory AnthropicChatRequest({
    required String model,
    required List<AnthropicMessage> messages,
    @Default(4096) @JsonKey(name: 'max_tokens') int maxTokens,
    @Default(1.0) double temperature,
    @Default(false) bool stream,
    @JsonKey(includeIfNull: false) String? system,
    @JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools,
  }) = _AnthropicChatRequest;

  factory AnthropicChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AnthropicChatRequestFromJson(json);
}

/// Anthropic 消息格式
@freezed
abstract class AnthropicMessage with _$AnthropicMessage {
  const factory AnthropicMessage({
    required String role,
    required dynamic content, // String 或 List<ContentBlock>
  }) = _AnthropicMessage;

  factory AnthropicMessage.fromJson(Map<String, dynamic> json) =>
      _$AnthropicMessageFromJson(json);

  /// 从 AiMessageDto 转换
  factory AnthropicMessage.fromDto(AiMessageDto dto) {
    // Anthropic 支持 user, assistant, tool 角色
    String role = dto.role;
    if (role == 'system') {
      role = 'user'; // 系统消息转为用户消息
    }

    // 处理 tool_calls 和 tool_result
    dynamic content = dto.content;

    // 如果有 toolCalls，转换为 Anthropic 的 tool_use 格式
    if (dto.toolCalls != null && dto.toolCalls!.isNotEmpty) {
      final contentBlocks = <Map<String, dynamic>>[];
      for (final tc in dto.toolCalls!) {
        contentBlocks.add({
          'type': 'tool_use',
          'id': tc['id'],
          'name': tc['function']['name'],
          'input': tc['function']['arguments'] is String
              ? jsonDecode(tc['function']['arguments'])
              : tc['function']['arguments'],
        });
      }
      content = contentBlocks;
    }

    // 如果是 tool 角色，转换为 tool_result 格式
    if (dto.role == 'tool' && dto.toolCallId != null) {
      content = [
        {
          'type': 'tool_result',
          'tool_use_id': dto.toolCallId,
          'content': dto.content,
        }
      ];
      role = 'user'; // Anthropic 要求 tool_result 在 user 消息中
    }

    return AnthropicMessage(
      role: role,
      content: content,
    );
  }
}
