import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchSessionCard extends StatelessWidget {
  const MemoryToolSearchSessionCard({
    super.key,
    required this.sessionStateAsync,
    required this.selectedPid,
  });

  final AsyncValue<SearchSessionState> sessionStateAsync;
  final int? selectedPid;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.42,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: sessionStateAsync.when(
          data: (state) {
            if (!state.hasActiveSession) {
              return _MemoryToolSessionBody(
                title: context.l10n.memoryToolSessionTitle,
                message: context.l10n.memoryToolSessionEmpty,
              );
            }

            final isBoundToCurrent =
                selectedPid != null && state.pid == selectedPid;
            return _MemoryToolSessionBody(
              title: context.l10n.memoryToolSessionTitle,
              message: isBoundToCurrent
                  ? context.l10n.memoryToolSessionBoundToCurrent
                  : context.l10n.memoryToolSessionMismatch,
              pills: <Widget>[
                _MemoryToolSessionPill(
                  label: context.l10n.memoryToolSessionPid,
                  value: state.pid.toString(),
                ),
                _MemoryToolSessionPill(
                  label: context.l10n.memoryToolSessionRegionCount,
                  value: state.regionCount.toString(),
                ),
                _MemoryToolSessionPill(
                  label: context.l10n.memoryToolSessionResultCount,
                  value: state.resultCount.toString(),
                ),
              ],
            );
          },
          error: (error, _) => _MemoryToolSessionBody(
            title: context.l10n.memoryToolSessionTitle,
            message: error.toString(),
            isError: true,
          ),
          loading: () => SizedBox(height: 74.r, child: const Loading()),
        ),
      ),
    );
  }
}

class _MemoryToolSessionBody extends StatelessWidget {
  const _MemoryToolSessionBody({
    required this.title,
    required this.message,
    this.pills = const <Widget>[],
    this.isError = false,
  });

  final String title;
  final String message;
  final List<Widget> pills;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.r),
        Text(
          message,
          style: context.textTheme.bodySmall?.copyWith(
            color: isError
                ? context.colorScheme.error
                : context.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (pills.isNotEmpty) ...<Widget>[
          SizedBox(height: 12.r),
          Wrap(spacing: 8.r, runSpacing: 8.r, children: pills),
        ],
      ],
    );
  }
}

class _MemoryToolSessionPill extends StatelessWidget {
  const _MemoryToolSessionPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$label ',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
            Text(
              value,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
