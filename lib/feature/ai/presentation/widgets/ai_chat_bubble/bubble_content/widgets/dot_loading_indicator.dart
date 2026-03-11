import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotLoadingIndicator extends HookWidget {
  const DotLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final delay = index * 0.2;
            var value = (animationController.value - delay) % 1.0;
            if (value < 0) {
              value = 0;
            }

            final opacity = value < 0.5 ? value * 2 : 1.0 - (value - 0.5) * 2;
            final translation =
                (value < 0.5 ? value * 2 : 1.0 - (value - 0.5) * 2) * -4;

            return Opacity(
              opacity: opacity.clamp(0.4, 1.0),
              child: Transform.translate(
                offset: Offset(0, translation),
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: context.isDark ? Colors.white70 : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
