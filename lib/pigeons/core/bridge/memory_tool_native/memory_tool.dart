import 'package:pigeon/pigeon.dart';

class ProcessInfo {
  final int pid;
  final String name;
  final String packageName;
  final Uint8List? icon;

  const ProcessInfo({
    required this.pid,
    required this.packageName,
    required this.name,
    this.icon,
  });
}

@HostApi()
abstract class MemoryToolNative {
  @async
  int getPid({required String packageName});

  @async
  List<ProcessInfo> getProcessInfo(int offset, int limit);
}
