// lib/core/utils/file_picker_util.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';


class FilePickerUtil {
  FilePickerUtil._();

  /// 选择图片并返回字节数据
  static Future<PickedFileData?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      Uint8List? bytes;

      // 跨平台读取文件
      if (file.bytes != null) {
        // Web 平台
        bytes = file.bytes;
      } else if (file.path != null) {
        // 移动端/桌面端
        final fileData = File(file.path!);
        bytes = await fileData.readAsBytes();
      }

      if (bytes == null) return null;

      return PickedFileData(
        bytes: bytes,
        fileName: file.name,
        path: file.path,
        size: file.size,
        extension: file.extension,
      );
    } catch (e) {
      throw Exception('选择文件失败: $e');
    }
  }

  /// 选择任意类型文件
  static Future<PickedFileData?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      Uint8List? bytes;

      if (file.bytes != null) {
        bytes = file.bytes;
      } else if (file.path != null) {
        final fileData = File(file.path!);
        bytes = await fileData.readAsBytes();
      }

      if (bytes == null) return null;

      return PickedFileData(
        bytes: bytes,
        fileName: file.name,
        path: file.path,
        size: file.size,
        extension: file.extension,
      );
    } catch (e) {
      throw Exception('选择文件失败: $e');
    }
  }

  /// 选择多个文件
  static Future<List<PickedFileData>> pickMultipleFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return [];

      final List<PickedFileData> pickedFiles = [];

      for (final file in result.files) {
        Uint8List? bytes;

        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          final fileData = File(file.path!);
          bytes = await fileData.readAsBytes();
        }

        if (bytes != null) {
          pickedFiles.add(
            PickedFileData(
              bytes: bytes,
              fileName: file.name,
              path: file.path,
              size: file.size,
              extension: file.extension,
            ),
          );
        }
      }

      return pickedFiles;
    } catch (e) {
      throw Exception('选择文件失败: $e');
    }
  }

  static Future<PickedFileData?> pickApk() async {
    return pickFile(type: FileType.custom, allowedExtensions: ['apk']);
  }
}

/// 选中的文件数据
class PickedFileData {
  final Uint8List bytes;
  final String fileName;
  final String? path;
  final int size;
  final String? extension;

  PickedFileData({
    required this.bytes,
    required this.fileName,
    this.path,
    required this.size,
    this.extension,
  });

  /// 文件大小（格式化）
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  String toString() {
    return 'PickedFileData{fileName: $fileName, size: $size, extension: $extension}';
  }
}
