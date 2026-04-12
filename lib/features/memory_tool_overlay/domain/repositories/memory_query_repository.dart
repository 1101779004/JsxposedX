import 'package:JsxposedX/generated/memory_tool.g.dart';

abstract class MemoryQueryRepository {
  Future<int> getPid({required String packageName});

  Future<List<ProcessInfo>> getProcessInfo({
    required int offset,
    required int limit,
  });
}
