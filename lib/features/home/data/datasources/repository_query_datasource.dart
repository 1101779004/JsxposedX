import 'package:JsxposedX/core/network/http_service.dart';

class RepositoryQueryDatasource {
  final HttpService _httpService;

  RepositoryQueryDatasource({required HttpService httpService})
      : _httpService = httpService;
}
