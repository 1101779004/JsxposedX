import 'dart:convert';

import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/network/http_service.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/feature/ai/data/request_models/anthropic_chat_request.dart';
import 'package:JsxposedX/feature/ai/domain/services/ai_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// Anthropic Claude API 服务实现
class AnthropicApiService implements AiApiService {
  final HttpService _httpService;

  AnthropicApiService({required HttpService httpService})
      : _httpService = httpService;

  @override
  Stream<AiMessageDto> sendChatStream({
    required AiConfig config,
    required List<AiMessageDto> messages,
    List<Map<String, dynamic>>? tools,
  }) async* {
    // 提取系统消息
    String? systemMessage;
    final userMessages = <AnthropicMessage>[];

    for (final msg in messages) {
      if (msg.role == 'system') {
        systemMessage = msg.content;
      } else {
        userMessages.add(AnthropicMessage.fromDto(msg));
      }
    }

    final request = AnthropicChatRequest(
      model: config.moduleName,
      messages: userMessages,
      maxTokens: config.maxToken,
      temperature: config.temperature,
      stream: true,
      system: systemMessage,
      tools: tools,
    );

    try {
      final response = await _httpService.dio.post(
        config.fullApiUrl,
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "x-api-key": config.apiKey,
            "anthropic-version": "2023-06-01",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw PlatformException(
          code: 'HTTP_ERROR',
          message:
              'HTTP ${response.statusCode}: ${response.statusMessage ?? "Unknown error"}',
          details: response.data,
        );
      }

      final stream = response.data.stream as Stream<List<int>>;
      String buffered = "";
      final toolCallsAccum = <Map<String, dynamic>>[];

      await for (final chunk in stream) {
        final text = utf8.decode(chunk);
        buffered += text;

        final lines = buffered.split('\n');
        buffered = lines.removeLast();

        for (final line in lines) {
          final trimmedLine = line.trim();
          if (trimmedLine.isEmpty) continue;

          if (trimmedLine.startsWith('data: ')) {
            final data = trimmedLine.substring(6).trim();

            try {
              final json = jsonDecode(data);
              final type = json['type'] as String?;

              if (type == 'content_block_delta') {
                final delta = json['delta'];
                if (delta != null && delta['type'] == 'text_delta') {
                  final text = delta['text']?.toString();
                  if (text != null && text.isNotEmpty) {
                    yield AiMessageDto(role: 'assistant', content: text);
                  }
                }
              } else if (type == 'content_block_start') {
                // 处理 tool_use 开始
                final contentBlock = json['content_block'];
                if (contentBlock != null && contentBlock['type'] == 'tool_use') {
                  toolCallsAccum.add({
                    'id': contentBlock['id'],
                    'type': 'function',
                    'function': {
                      'name': contentBlock['name'],
                      'arguments': '',
                    },
                  });
                }
              } else if (type == 'content_block_delta' && json['delta']?['type'] == 'input_json_delta') {
                // 累积 tool_use 的 input
                if (toolCallsAccum.isNotEmpty) {
                  final partialJson = json['delta']['partial_json']?.toString() ?? '';
                  toolCallsAccum.last['function']['arguments'] += partialJson;
                }
              } else if (type == 'message_stop') {
                // 流结束，如果有工具调用，返回它们
                if (toolCallsAccum.isNotEmpty) {
                  yield AiMessageDto(
                    role: 'assistant',
                    content: '',
                    toolCalls: toolCallsAccum,
                  );
                }
                return;
              }
            } catch (e) {
              print('Anthropic API: 解析 JSON 错误: $e, data: ${data.length > 200 ? data.substring(0, 200) + "..." : data}');
              // JSON解析错误，记录但继续处理下一个chunk
            }
          }
        }
      }
    } on DioException catch (e) {
      throw PlatformException(
        code: e.type.toString(),
        message: e.message,
        details: e.response?.data,
      );
    } catch (e) {
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        message: e.toString(),
      );
    }
  }

  @override
  Future<String> testConnection(AiConfig config) async {
    final request = AnthropicChatRequest(
      model: config.moduleName,
      messages: [
        const AnthropicMessage(role: 'user', content: 'Hi'),
      ],
      maxTokens: 1,  // 只需要 1 个 token，快速测试
      temperature: 0.0,  // 使用 0 温度，更快
      stream: true,  // 使用流式，收到第一个 chunk 就成功
    );

    final stopwatch = Stopwatch()..start();

    try {
      final response = await _httpService.dio.post(
        config.fullApiUrl,
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "x-api-key": config.apiKey,
            "anthropic-version": "2023-06-01",
            "Content-Type": "application/json",
            "Accept": "text/event-stream",
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw PlatformException(
          code: 'HTTP_ERROR',
          message: 'HTTP ${response.statusCode}: ${response.statusMessage ?? "Unknown error"}',
          details: response.data,
        );
      }

      // 流式读取：只需要第一个 chunk 就判定成功
      final stream = response.data.stream as Stream<List<int>>;
      await for (final chunk in stream) {
        stopwatch.stop();
        final responseTime = stopwatch.elapsedMilliseconds;

        // 收到第一个 chunk，测试成功
        if (responseTime < 6000) {
          return 'Connection successful (${responseTime}ms)';
        } else {
          return 'Connection degraded (${responseTime}ms)';
        }
      }

      throw PlatformException(
        code: 'NO_DATA',
        message: 'No response data received',
      );
    } on DioException catch (e) {
      stopwatch.stop();
      throw PlatformException(
        code: e.type.toString(),
        message: e.message ?? 'Connection failed',
        details: e.response?.data,
      );
    } catch (e) {
      stopwatch.stop();
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        message: e.toString(),
      );
    }
  }
}
