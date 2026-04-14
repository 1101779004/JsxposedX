import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchResultCard extends StatelessWidget {
  const MemoryToolSearchResultCard({
    super.key,
    required this.hasMatchingSession,
    required this.resultsAsync,
    required this.onRetry,
  });

  final bool hasMatchingSession;
  final AsyncValue<List<SearchResult>> resultsAsync;
  final VoidCallback onRetry;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.l10n.memoryToolResultTitle,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.r),
            Expanded(
              child: !hasMatchingSession
                  ? Center(
                      child: Text(
                        context.l10n.memoryToolResultInactiveHint,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.66,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : resultsAsync.when(
                      data: (results) {
                        if (results.isEmpty) {
                          return Center(
                            child: Text(
                              context.l10n.memoryToolResultEmpty,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.66,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: results.length,
                          separatorBuilder: (_, _) => SizedBox(height: 8.r),
                          itemBuilder: (BuildContext context, int index) {
                            return _MemoryToolSearchResultTile(
                              result: results[index],
                            );
                          },
                        );
                      },
                      error: (error, _) =>
                          RefError(onRetry: onRetry, error: error),
                      loading: () => const Loading(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryToolSearchResultTile extends StatelessWidget {
  const _MemoryToolSearchResultTile({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _MemoryToolResultRow(
              label: context.l10n.memoryToolResultAddress,
              value: _formatHex(result.address),
            ),
            SizedBox(height: 6.r),
            _MemoryToolResultRow(
              label: context.l10n.memoryToolResultRegion,
              value: _formatHex(result.regionStart),
            ),
            SizedBox(height: 6.r),
            _MemoryToolResultRow(
              label: context.l10n.memoryToolResultType,
              value: _typeLabel(result.type),
            ),
            SizedBox(height: 6.r),
            _MemoryToolResultRow(
              label: context.l10n.memoryToolResultValue,
              value: result.displayValue,
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }

  String _formatHex(int value) {
    return '0x${value.toRadixString(16).toUpperCase()}';
  }

  String _typeLabel(SearchValueType type) {
    return switch (type) {
      SearchValueType.i8 => 'I8',
      SearchValueType.i16 => 'I16',
      SearchValueType.i32 => 'I32',
      SearchValueType.i64 => 'I64',
      SearchValueType.f32 => 'F32',
      SearchValueType.f64 => 'F64',
      SearchValueType.bytes => 'AOB',
    };
  }
}

class _MemoryToolResultRow extends StatelessWidget {
  const _MemoryToolResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 62.r,
          child: Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ),
        SizedBox(width: 10.r),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlight ? context.colorScheme.primary : null,
            ),
          ),
        ),
      ],
    );
  }
}
