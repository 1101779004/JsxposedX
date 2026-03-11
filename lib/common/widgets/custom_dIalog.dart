import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;

  final List<Widget>? action;

  final List<Widget>? actionButtons;

  final bool hasClose;

  final Widget? child;

  final double? height;

  final double? width;

  const CustomDialog({
    super.key,
    required this.title,
    this.child,
    this.hasClose = false,
    this.actionButtons,
    this.action,
    this.height,
    this.width,
  });

  static Future<T?> show<T>({
    required Widget title,
    Widget? child,
    List<Widget>? action,
    double? height,
    double? width,
    List<Widget>? actionButtons,
    bool hasClose = false,
  }) {
    return SmartDialog.show(
      builder: (context) => CustomDialog(
        title: title,
        action: action,
        width: width,
        height: height,
        actionButtons: actionButtons,
        hasClose: hasClose,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // 1. 设置背景颜色（通常使用主题色，保证暗色模式适配）
      color: context.colorScheme.surface,
      // 2. 在 Material 这一层统一设置圆角形状
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // 3. 开启裁剪，这样内层的 Container 或 child 如果超出圆角会被自动裁掉
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.9.sh, maxWidth: 0.9.sw),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        width: width ?? 0.9.sw,
        height: height,
        // 注意：建议这里也包一层 SingleChildScrollView 或使用 MainAxisSize.min，防止内容溢出
        child: Column(
          mainAxisSize: MainAxisSize.min, // 让对话框高度自适应内容
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppFonts.primary,
                  color: context.textTheme.titleMedium!.color, // 局部定义的标题颜色
                ),
                child: Row(
                  children: [
                    title,
                    Spacer(),
                    if (action != null) ...action!,
                    if (hasClose)
                      InkWell(
                        onTap: () => SmartDialog.dismiss(),
                        child: Icon(Icons.close, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            if (child != null) const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              child: Column(
                children: [
                  if (child != null) child!,
                  if (actionButtons != null) ...[
                    if (child != null) SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 5.w,
                      children: [...actionButtons!],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
