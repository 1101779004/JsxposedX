import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_config_dto.dart';
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
        // 如果配置没有 id，生成一个默认的
        if (config.id.isEmpty) {
          return config.copyWith(
            id: const Uuid().v4(),
            name: config.name.isEmpty ? '默认配置' : config.name,
          );
        }
        return config;
      } catch (e) {
        return AiConfigDto(
          id: const Uuid().v4(),
          name: '默认配置',
        );
      }
    }
    return AiConfigDto(
      id: const Uuid().v4(),
      name: '默认配置',
    );
  }
}

