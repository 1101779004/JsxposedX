import 'package:JsxposedX/features/home/data/datasources/repository_query_datasource.dart';
import 'package:JsxposedX/features/home/domain/repositories/repository_query_repository.dart';

class RepositoryQueryRepositoryImpl implements RepositoryQueryRepository {
  final RepositoryQueryDatasource dataSource;

  RepositoryQueryRepositoryImpl({required this.dataSource});
}
