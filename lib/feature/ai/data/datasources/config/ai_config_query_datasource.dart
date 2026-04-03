import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_config_dto.dart';
import 'package:JsxposedX/feature/ai/domain/constants/builtin_ai_config.dart';
import 'package:uuid/uuid.dart';

/// AI 配置查询数据源
class AiConfigQueryDatasource {
  final PiniaStorage _storage;

  AiConfigQueryDatasource({required PiniaStorage storage}) : _storage = storage;

  /// 获取 AI 配置
  Future<AiConfigDto> getConfig() async {
    final configStr = await _storage.getString("ai_config");
    if (configStr.isNotEmpty) {
      try {
        final config = AiConfigDto.fromJson(jsonDecode(configStr));
        if (config.id == builtinAiConfigId) {
          return AiConfigDto(
            id: builtinAiConfigId,
            name: builtinAiConfigName,
            apiUrl: builtinAiConfigBaseUrl,
            moduleName: 'gpt-5.4',
            maxToken: 4096,
            temperature: 1.0,
            memoryRounds: 6,
            apiType: 'openaiResponses',
          );
        }
        // 如果配置没有 id，生成一个默认的
        if (config.id.isEmpty) {
          final hasCustomContent =
              config.apiUrl.isNotEmpty ||
              config.apiKey.isNotEmpty ||
              config.moduleName.isNotEmpty ||
              config.name.isNotEmpty;
          if (hasCustomContent) {
            return config.copyWith(
              id: const Uuid().v4(),
              name: config.name.isEmpty ? '迁移配置' : config.name,
            );
          }
          return _builtinConfigDto();
        }
        return config;
      } catch (e) {
        return _builtinConfigDto();
      }
    }
    return _builtinConfigDto();
  }

  AiConfigDto _builtinConfigDto() {
    return const AiConfigDto(
      id: builtinAiConfigId,
      name: builtinAiConfigName,
      apiUrl: builtinAiConfigBaseUrl,
      moduleName: 'gpt-5.4',
      maxToken: 4096,
      temperature: 1.0,
      memoryRounds: 6,
      apiType: 'openaiResponses',
    );
  }
}
