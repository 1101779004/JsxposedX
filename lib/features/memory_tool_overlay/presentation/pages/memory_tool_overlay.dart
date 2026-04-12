import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_window.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_presentation.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolOverlay extends HookConsumerWidget {
  const MemoryToolOverlay({super.key});

  OverlayWindowConfig get overlayConfig => OverlayWindowConfig(
    sceneId: 0,
    bubbleSize: OverlayWindowPresentation.defaultBubbleSize,
    notificationTitle: (context) => context.l10n.overlayMemoryToolTitle,
    notificationContent: (context) =>
        context.l10n.overlayWindowNotificationContent,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final processListAsync = ref.watch(
      getProcessInfoProvider(offset: 0, limit: 20),
    );
    return OverlayWindowScaffold(
      overlayConfig: overlayConfig,
      borderRadius: BorderRadius.circular(8.r),
      overlayBar: OverlayWindowBar(
        backgroundColor: context.colorScheme.surface.withValues(alpha: 0.3),
        title: Text(
          context.l10n.overlayMemoryToolTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CacheImage(imageUrl: AssetsConstants.logo, size: 40.sp),
        ),
        showMinimizeAction: true,
        showCloseAction: false,
      ),
      backgroundColor: context.colorScheme.surface.withValues(alpha: 0.6),
      margin: EdgeInsets.all(8.r),
      body: processListAsync.when(
        data: (processes) {
          if (processes.isEmpty) {
            return Center(
              child: Text(
                '暂无可用进程',
                style: TextStyle(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(12.r),
            itemCount: processes.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return _ProcessInfoTile(process: processes[index]);
            },
          );
        },
        error: (error, stack) => RefError(
          onRetry: () {
            ref.invalidate(getProcessInfoProvider(offset: 0, limit: 20));
          },
        ),
        loading: () => const Loading(),
      ),
      bottomBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _ProcessInfoTile extends StatelessWidget {
  const _ProcessInfoTile({required this.process});

  final ProcessInfo process;

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
