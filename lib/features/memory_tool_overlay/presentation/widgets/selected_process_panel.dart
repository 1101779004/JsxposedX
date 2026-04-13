import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/process_info_tile.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedProcessPanel extends StatelessWidget {
  const SelectedProcessPanel({super.key, required this.selectedProcess});

  final ProcessInfo? selectedProcess;

  @override
  Widget build(BuildContext context) {
    if (selectedProcess == null) {
      return Center(
        child: Text(
          context.l10n.selectApp,
          style: TextStyle(
            color: context.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(12.r),
      child: ProcessInfoTile(process: selectedProcess!),
    );
  }
}
