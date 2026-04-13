import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/process_info_tile.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolProcessPickerDialog extends HookConsumerWidget {
  const MemoryToolProcessPickerDialog({
    super.key,
    required this.onClose,
    required this.onSelected,
    required this.onRetry,
  });

  final VoidCallback onClose;
  final ValueChanged<ProcessInfo> onSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processListAsync = ref.watch(
      getProcessInfoProvider(offset: 0, limit: 20),
    );

    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      child: Center(
        child: CustomDialog(
          title: Text(context.l10n.selectApp),
          hasClose: false,
          width: 0.88.sw,
          height: 0.72.sh,
          action: [
            TextButton(onPressed: onClose, child: Text(context.l10n.close)),
          ],
          child: SizedBox(
            height: 0.56.sh,
            child: processListAsync.when(
              data: (processes) {
                if (processes.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.noData,
                      style: TextStyle(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: processes.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return ProcessInfoTile(
                      process: processes[index],
                      onTap: () => onSelected(processes[index]),
                    );
                  },
                );
              },
              error: (error, stack) => RefError(onRetry: onRetry),
              loading: () => const Loading(),
            ),
          ),
        ),
      ),
    );
  }
}
