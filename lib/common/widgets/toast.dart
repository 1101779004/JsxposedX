import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Toast {
  static void showToast(
    BuildContext context,
    String message, {
    String? buttonLabel,
    VoidCallback? onClick,
    Duration? duration,
  }) {
    SmartDialog.showToast(
      message,
      builder: (_) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        // decoration: BoxDecoration(
        //   color: primaryColor,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
