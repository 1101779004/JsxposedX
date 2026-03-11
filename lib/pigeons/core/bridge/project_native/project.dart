import 'package:pigeon/pigeon.dart';

class AppInfo {
  final String name;
  final String packageName;
  final String versionName;
  final int versionCode;
  final bool isSystemApp;
  final Uint8List? icon;

  AppInfo({
    required this.name,
    required this.packageName,
    required this.versionName,
    required this.versionCode,
    required this.isSystemApp,
    this.icon,
  });
}

class AuditLog {
  final String algorithm;
  final int operation;
  final String key;
  final String keyBase64;
  final String keyPlaintext;
  final String? iv;
  final String? ivBase64;
  final String? ivPlaintext;
  final String input;
  final String inputBase64;
  final String output;
  final String outputBase64;
  final String inputHex;
  final String outputHex;
  final List<String?> stackTrace;
  final String fingerprint;
  final int timestamp;

  AuditLog({
    required this.algorithm,
    required this.operation,
    required this.key,
    required this.keyBase64,
    required this.keyPlaintext,
    this.iv,
    this.ivBase64,
    this.ivPlaintext,
    required this.input,
    required this.inputBase64,
    required this.output,
    required this.outputBase64,
    required this.inputHex,
    required this.outputHex,
    required this.stackTrace,
    required this.fingerprint,
    required this.timestamp,
  });
}

@HostApi()
abstract class ProjectNative {
  void initProject();

  bool projectExists(String packageName);

  void createProject(String packageName);

  void deleteProject(String packageName);

  List<AppInfo> getProjects();

  List<String> getFridaScripts(String packageName);

  void createFridaScript(
    String packageName,
    String content,
    String localPath,
    bool append,
  );

  String readFridaScript(String packageName, String localPath);

  void deleteFridaScript(String packageName, String scriptName);
  @async
  void importFridaScripts(String packageName, List<String> localPaths);

  @async
  void bundleFridaHookJs(String packageName);

  List<String> getJsScripts(String packageName);

  void createJsScript(
    String packageName,
    String content,
    String localPath,
    bool append,
  );

  String readJsScript(String packageName, String localPath);

  void deleteJsScript(String packageName, String localPath);

  @async
  void importJsScripts(String packageName, List<String> localPaths);

  @async
  List<AuditLog?> getAuditLogs(
    String packageName,
    int limit,
    int offset,
    String? keyword,
  );

  @async
  void deleteAuditLog(String packageName, int timestamp);

  @async
  void updateAuditLog(String packageName, AuditLog updatedLog);

  @async
  void clearAuditLogs(String packageName);
}
