import 'package:JsxposedX/core/network/http_service.dart';

class RepositoryActionDatasource {
  final HttpService _httpService;

  RepositoryActionDatasource({required HttpService httpService})
      : _httpService = httpService;
}
