import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_query_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/data/repositories/memory_query_repository_impl.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_query_repository.dart';

part 'memory_query_provider.g.dart';

@riverpod
MemoryQueryRepository memoryQueryRepository(Ref ref) {
  final httpService = ref.watch(httpServiceProvider);
  final dataSource = MemoryQueryDatasource(httpService: httpService);
  return MemoryQueryRepositoryImpl(dataSource: dataSource);
}
