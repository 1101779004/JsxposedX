import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessInfoTile extends StatelessWidget {
  const ProcessInfoTile({super.key, required this.process, this.onTap});

  final ProcessInfo process;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = process.icon;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        onTap: onTap,
        leading: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: context.colorScheme.surfaceContainer,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: icon != null && icon.isNotEmpty
                ? Image.memory(icon, fit: BoxFit.cover)
                : Icon(
                    Icons.memory_rounded,
                    color: context.colorScheme.primary,
                  ),
          ),
        ),
        title: Text(
          process.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              process.packageName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            Text(
              'pid: ${process.pid}',
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
