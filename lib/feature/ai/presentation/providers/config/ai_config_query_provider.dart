import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/feature/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/feature/ai/data/datasources/config/ai_config_query_datasource.dart';
import 'package:JsxposedX/feature/ai/data/repositories/config/ai_config_query_repository_impl.dart' as impl;
import 'package:JsxposedX/feature/ai/domain/repositories/config/ai_config_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_config_query_provider.g.dart';

@riverpod
AiConfigQueryRepository aiConfigQueryRepository(Ref ref) {
  final storage = ref.watch(piniaStorageLocalProvider);
  final dataSource = AiConfigQueryDatasource(storage: storage);
  return impl.AiConfigQueryRepositoryImpl(dataSource: dataSource);
}

/// 获取 AI 配置
@riverpod
Future<AiConfig> aiConfig(Ref ref) async {
  return await ref.watch(aiConfigQueryRepositoryProvider).getConfig();
}

/// 获取 AI 配置列表
@riverpod
Future<List<AiConfig>> aiConfigList(Ref ref) async {
  final storage = ref.watch(piniaStorageLocalProvider);
  final dataSource = AiConfigActionDatasource(storage: storage);
  final dtos = await dataSource.getConfigList();
  return dtos.map((dto) => dto.toEntity()).toList();
}


