import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/models/ai_config_dto.dart';

/// AI 配置操作数据源
class AiConfigActionDatasource {
  final PiniaStorage _storage;

  AiConfigActionDatasource({required PiniaStorage storage}) : _storage = storage;

  /// 保存当前 AI 配置
  Future<void> saveConfig(AiConfigDto config) async {
    await _storage.setString(
      "ai_config",
      jsonEncode(config.toJson()),
    );
  }

  /// 获取配置列表
  Future<List<AiConfigDto>> getConfigList() async {
    final configListStr = await _storage.getString("ai_config_list");
    if (configListStr.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(configListStr);
      return jsonList.map((json) => AiConfigDto.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存配置列表
  Future<void> saveConfigList(List<AiConfigDto> configs) async {
    await _storage.setString(
      "ai_config_list",
      jsonEncode(configs.map((c) => c.toJson()).toList()),
    );
  }

  /// 添加新配置到列表
  Future<void> addConfig(AiConfigDto config) async {
    final list = await getConfigList();
    list.add(config);
    await saveConfigList(list);
  }

  /// 更新配置列表中的某个配置
  Future<void> updateConfig(AiConfigDto config) async {
    final list = await getConfigList();
    final index = list.indexWhere((c) => c.id == config.id);
    if (index != -1) {
      list[index] = config;
      await saveConfigList(list);
    }
  }

  /// 删除配置
  Future<void> deleteConfig(String id) async {
    final list = await getConfigList();
    list.removeWhere((c) => c.id == id);
    await saveConfigList(list);
  }

  /// 切换配置（将指定配置设为当前配置）
  Future<void> switchConfig(String id) async {
    final list = await getConfigList();
    final config = list.firstWhere((c) => c.id == id);
    await saveConfig(config);
  }
}

