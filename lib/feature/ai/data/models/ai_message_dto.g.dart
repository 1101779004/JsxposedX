// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiMessageDto _$AiMessageDtoFromJson(Map<String, dynamic> json) =>
    _AiMessageDto(
      role: json['role'] as String? ?? "user",
      content: json['content'] as String? ?? "",
      toolCalls: (json['tool_calls'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      toolCallId: json['tool_call_id'] as String?,
    );

Map<String, dynamic> _$AiMessageDtoToJson(_AiMessageDto instance) {
  final val = <String, dynamic>{
    'role': instance.role,
    'content': instance.content,
  };

  if (instance.toolCalls != null) {
    val['tool_calls'] = instance.toolCalls;
  }
  if (instance.toolCallId != null) {
    val['tool_call_id'] = instance.toolCallId;
  }

  return val;
}
