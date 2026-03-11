import 'dart:convert';

import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/network/http_service.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/feature/ai/data/request_models/ai_chat_request.dart';
import 'package:JsxposedX/feature/ai/domain/services/ai_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// OpenAI 兼容 API 服务实现
class OpenAiApiService implements AiApiService {
  final HttpService _httpService;

  OpenAiApiService({required HttpService httpService})
      : _httpService = httpService;

  @override
  Stream<AiMessageDto> sendChatStream({
    required AiConfig config,
    required List<AiMessageDto> messages,
    List<Map<String, dynamic>>? tools,
  }) async* {
    print('TESTAI: 开始发送请求');
    print('TESTAI: tools = ${tools != null ? tools.length : 0}');

    final request = AiChatRequest(
      model: config.moduleName,
      messages: messages,
      stream: true,
      temperature: config.temperature,
      maxTokens: config.maxToken,
      tools: tools,
    );

    try {
      final response = await _httpService.dio.post(
        config.fullApiUrl,
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            if (config.apiKey.isNotEmpty) "Authorization": "Bearer ${config.apiKey}",
            "Content-Type": "application/json",
          },
        ),
      );

      print('TESTAI: 收到响应 statusCode=${response.statusCode}');

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
      final toolCallsAccum = <int, Map<String, dynamic>>{};
      bool isDone = false;
      int yieldCount = 0;

      print('TESTAI: 开始读取流');
      int chunkCount = 0;
      int lineCount = 0;

      await for (final chunk in stream) {
        chunkCount++;
        if (isDone) {
          print('TESTAI: isDone=true, 跳出循环');
          break;
        }

        final text = utf8.decode(chunk);
        print('TESTAI: 收到 chunk #$chunkCount, 长度=${text.length}');
        buffered += text;

        final lines = buffered.split('\n');
        buffered = lines.removeLast();

        for (final line in lines) {
          lineCount++;
          final trimmedLine = line.trim();
          print('TESTAI: 处理行 #$lineCount: ${trimmedLine.length > 50 ? trimmedLine.substring(0, 50) + "..." : trimmedLine}');

          if (trimmedLine.isEmpty) {
            print('TESTAI: 跳过空行');
            continue;
          }

          if (trimmedLine.startsWith('data: ')) {
            final data = trimmedLine.substring(6).trim();
            print('TESTAI: 解析 data: ${data.length > 100 ? data.substring(0, 100) + "..." : data}');

            if (data == '[DONE]') {
              print('TESTAI: 收到 [DONE] 标记, toolCallsAccum.length=${toolCallsAccum.length}');
              // 流结束，如果有累积的工具调用，验证并返回它们
              if (toolCallsAccum.isNotEmpty) {
                final validatedCalls = <Map<String, dynamic>>[];
                for (final call in toolCallsAccum.values) {
                  try {
                    final args = call['function']['arguments'];

                    // 处理暂存的字符串片段
                    if (call.containsKey('_argBuffer')) {
                      final buffer = call['_argBuffer'] as String;
                      if (buffer.isNotEmpty) {
                        try {
                          final parsedBuffer = jsonDecode(buffer);
                          if (parsedBuffer is Map) {
                            (args as Map<String, dynamic>).addAll(parsedBuffer.cast<String, dynamic>());
                          }
                        } catch (e) {
                          print('TESTAI: 无法解析argBuffer: $buffer, error: $e');
                        }
                      }
                      call.remove('_argBuffer');
                    }

                    // 转换为JSON字符串
                    if (args is Map) {
                      call['function']['arguments'] = jsonEncode(args);
                    } else if (args is String && args.isEmpty) {
                      call['function']['arguments'] = '{}';
                    }

                    validatedCalls.add(call);
                  } catch (e) {
                    print('TESTAI: 工具调用参数处理失败: ${call['function']['name']}, error: $e');
                  }
                }

                if (validatedCalls.isNotEmpty) {
                  print('TESTAI: yield ${validatedCalls.length} 个有效工具调用');
                  yield AiMessageDto(
                    role: 'assistant',
                    content: '',
                    toolCalls: validatedCalls,
                  );
                  yieldCount++;
                }
              }
              isDone = true;
              break;
            }

            try {
              final json = jsonDecode(data);
              final choices = json['choices'] as List?;
              if (choices != null && choices.isNotEmpty) {
                final delta = choices[0]['delta'] as Map<String, dynamic>?;
                if (delta == null) continue;

                final content = delta['content']?.toString();
                if (content != null && content.isNotEmpty) {
                  print('TESTAI: yield 内容片段: ${content.substring(0, content.length > 20 ? 20 : content.length)}...');
                  yield AiMessageDto(role: 'assistant', content: content);
                  yieldCount++;
                }

                final toolCalls = delta['tool_calls'] as List?;
                if (toolCalls != null) {
                  print('TESTAI: 收到工具调用片段');
                  for (final tc in toolCalls) {
                    final idx = tc['index'] as int? ?? 0;
                    if (!toolCallsAccum.containsKey(idx)) {
                      toolCallsAccum[idx] = {
                        'id': tc['id'] ?? '',
                        'type': 'function',
                        'function': {
                          'name': tc['function']?['name'] ?? '',
                          'arguments': <String, dynamic>{}, // 改为Map存储
                        },
                      };
                    }

                    // 处理arguments片段
                    final argChunk = tc['function']?['arguments']?.toString() ?? '';
                    if (argChunk.isNotEmpty) {
                      try {
                        // 尝试解析为JSON对象
                        final parsedChunk = jsonDecode(argChunk);
                        if (parsedChunk is Map) {
                          // 合并到累积的参数中
                          final currentArgs = toolCallsAccum[idx]!['function']['arguments'] as Map<String, dynamic>;
                          currentArgs.addAll(parsedChunk.cast<String, dynamic>());
                        }
                      } catch (e) {
                        // 如果不是完整JSON，可能是字符串片段，暂存
                        if (!toolCallsAccum[idx]!.containsKey('_argBuffer')) {
                          toolCallsAccum[idx]!['_argBuffer'] = '';
                        }
                        toolCallsAccum[idx]!['_argBuffer'] += argChunk;
                      }
                    }

                    final nameChunk = tc['function']?['name']?.toString() ?? '';
                    if (nameChunk.isNotEmpty &&
                        (toolCallsAccum[idx]!['function']['name'] as String)
                            .isEmpty) {
                      toolCallsAccum[idx]!['function']['name'] = nameChunk;
                    }
                    final idChunk = tc['id']?.toString() ?? '';
                    if (idChunk.isNotEmpty &&
                        (toolCallsAccum[idx]!['id'] as String).isEmpty) {
                      toolCallsAccum[idx]!['id'] = idChunk;
                    }
                  }
                }
              }
            } catch (e) {
              print('TESTAI: 解析 JSON 错误: $e, data: ${data.length > 200 ? data.substring(0, 200) + "..." : data}');
              // JSON解析错误，记录但继续处理下一个chunk
            }
          }
        }
      }

      print('TESTAI: 流结束, 总共 yield 了 $yieldCount 次');
    } on DioException catch (e) {
      print('TESTAI: DioException: ${e.type} - ${e.message}');
      throw PlatformException(
        code: e.type.toString(),
        message: e.message,
        details: e.response?.data,
      );
    } catch (e) {
      print('TESTAI: 未知错误: $e');
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        message: e.toString(),
      );
    }
  }

  @override
  Future<String> testConnection(AiConfig config) async {
    final request = AiChatRequest(
      model: config.moduleName,
      messages: [
        AiMessageDto(role: 'user', content: 'Hi'),
      ],
      stream: true,  // 使用流式，收到第一个 chunk 就成功
      temperature: 0.0,  // 使用 0 温度，更快
      maxTokens: 1,  // 只需要 1 个 token，快速测试
    );

    final stopwatch = Stopwatch()..start();

    try {
      final response = await _httpService.dio.post(
        config.fullApiUrl,
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            if (config.apiKey.isNotEmpty) "Authorization": "Bearer ${config.apiKey}",
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
