import 'package:JsxposedX/core/networks/http_service.dart';

class MemoryQueryDatasource {
  final HttpService _httpService;

  MemoryQueryDatasource({required HttpService httpService})
      : _httpService = httpService;
}
