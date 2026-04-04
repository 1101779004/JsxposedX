import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:JsxposedX/core/network/http_service.dart';
import 'package:JsxposedX/features/home/data/datasources/repository_query_datasource.dart';
import 'package:JsxposedX/features/home/data/repositories/repository_query_repository_impl.dart';
import 'package:JsxposedX/features/home/domain/repositories/repository_query_repository.dart';

part 'repository_query_provider.g.dart';

@riverpod
RepositoryQueryRepository repositoryQueryRepository(Ref ref) {
  final httpService = ref.watch(httpServiceProvider);
  final dataSource = RepositoryQueryDatasource(httpService: httpService);
  return RepositoryQueryRepositoryImpl(dataSource: dataSource);
}
