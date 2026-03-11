import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  const UrlHelper._();

  static Future<void> openUrlInBrowser({required String url}) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('无法打开 URL: $url');
      }
    } catch (e) {
      debugPrint('打开 URL 失败: $e');
    }
  }
}
