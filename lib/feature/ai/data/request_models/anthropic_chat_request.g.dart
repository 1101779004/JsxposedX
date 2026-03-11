// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anthropic_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnthropicChatRequest _$AnthropicChatRequestFromJson(
  Map<String, dynamic> json,
) => _AnthropicChatRequest(
  model: json['model'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => AnthropicMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  maxTokens: (json['max_tokens'] as num?)?.toInt() ?? 4096,
  temperature: (json['temperature'] as num?)?.toDouble() ?? 1.0,
  stream: json['stream'] as bool? ?? false,
  system: json['system'] as String?,
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$AnthropicChatRequestToJson(
  _AnthropicChatRequest instance,
) => <String, dynamic>{
  'model': instance.model,
  'messages': instance.messages,
  'max_tokens': instance.maxTokens,
  'temperature': instance.temperature,
  'stream': instance.stream,
  'system': ?instance.system,
  'tools': ?instance.tools,
};

_AnthropicMessage _$AnthropicMessageFromJson(Map<String, dynamic> json) =>
    _AnthropicMessage(role: json['role'] as String, content: json['content']);

Map<String, dynamic> _$AnthropicMessageToJson(_AnthropicMessage instance) =>
    <String, dynamic>{'role': instance.role, 'content': instance.content};
