import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivationCard extends StatelessWidget {
  final bool isActivated;
  final String title;
  final bool isAI;
  final String? subTitle;

  const ActivationCard({
    super.key,
    required this.isActivated,
    required this.title,
    this.subTitle,
  }) : isAI = false;

  const ActivationCard.ai({
    super.key,
    required this.isActivated,
    required this.title,
    this.subTitle,
  }) : isAI = true;

  @override
  Widget build(BuildContext context) {
    final bgColor = isActivated ? context.colorScheme.primary : Colors.grey;

    final aiGradient = const LinearGradient(
      colors: [Color(0xFF70D7F9), Color(0xFFAD98FF), Color(0xFFFFB385)],
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      height: 100.h,
      decoration: isAI
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isActivated
                  ? [
                      BoxShadow(
                        color: const Color(0xFF70D7F9).withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFFAD98FF).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(5, 5),
                      ),
                    ]
                  : null,
              gradient: isActivated ? aiGradient : null,
              color: isActivated ? null : Colors.grey.withValues(alpha: 0.2),
            )
          : null,
      padding: (isAI && isActivated)
          ? const EdgeInsets.all(2)
          : EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isAI
              ? (isActivated
                    ? (context.isDark ? const Color(0xFF1E1E1E) : Colors.white)
                    : Colors.transparent)
              : bgColor,
          borderRadius: BorderRadius.circular(isAI ? 14.r : 12.r),
          boxShadow: !isAI
              ? [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isAI && isActivated)
              ShaderMask(
                shaderCallback: (bounds) => aiGradient.createShader(bounds),
                child: Icon(Icons.check, size: 50.sp, color: Colors.white),
              )
            else
              Icon(
                isActivated ? Icons.check : Icons.error_outline,
                size: 50.sp,
                color: isAI
                    ? (isActivated ? const Color(0xFFAD98FF) : Colors.grey)
                    : Colors.white,
              ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAI && isActivated)
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          aiGradient.createShader(bounds),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isAI
                            ? (context.isDark
                                  ? Colors.white
                                  : AppColors.textPrimary)
                            : Colors.white,
                      ),
                    ),
                  if (isAI && isActivated)
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          aiGradient.createShader(bounds),
                      child: Text(
                        context.l10n.activated,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    )
                  else
                    Text(
                      "${isActivated ? context.l10n.activated : context.l10n.notActivated}${subTitle != null ? "($subTitle)" : ""}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isAI
                            ? (context.isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary)
                            : Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
