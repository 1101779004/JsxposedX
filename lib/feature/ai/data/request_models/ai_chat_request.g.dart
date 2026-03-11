// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatRequest _$AiChatRequestFromJson(Map<String, dynamic> json) =>
    _AiChatRequest(
      model: json['model'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => AiMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      stream: json['stream'] as bool? ?? true,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 300,
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$AiChatRequestToJson(_AiChatRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'messages': instance.messages,
      'stream': instance.stream,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'tools': ?instance.tools,
    };
