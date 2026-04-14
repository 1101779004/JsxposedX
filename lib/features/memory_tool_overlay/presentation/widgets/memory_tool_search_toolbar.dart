import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolSearchToolbar extends StatelessWidget {
  const MemoryToolSearchToolbar({
    super.key,
    required this.canRunFirstScan,
    required this.canRunNextScan,
    required this.canReset,
    required this.onFirstScan,
    required this.onNextScan,
    required this.onReset,
  });

  final bool canRunFirstScan;
  final bool canRunNextScan;
  final bool canReset;
  final VoidCallback onFirstScan;
  final VoidCallback onNextScan;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.42),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
        child: Row(
          children: <Widget>[
            _MemoryToolSearchToolbarButton(
              icon: Icons.search_rounded,
              label: context.l10n.memoryToolActionFirstScan,
              onPressed: canRunFirstScan ? onFirstScan : null,
              isPrimary: true,
            ),
            SizedBox(width: 8.r),
            _MemoryToolSearchToolbarButton(
              icon: Icons.filter_alt_rounded,
              label: context.l10n.memoryToolActionNextScan,
              onPressed: canRunNextScan ? onNextScan : null,
            ),
            SizedBox(width: 8.r),
            _MemoryToolSearchToolbarButton(
              icon: Icons.restart_alt_rounded,
              label: context.l10n.memoryToolActionReset,
              onPressed: canReset ? onReset : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryToolSearchToolbarButton extends StatelessWidget {
  const _MemoryToolSearchToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = onPressed == null
        ? context.colorScheme.onSurface.withValues(alpha: 0.36)
        : isPrimary
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurface;
    final Color backgroundColor = onPressed == null
        ? context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : isPrimary
        ? context.colorScheme.primary
        : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isPrimary
                  ? backgroundColor
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18.r, color: foregroundColor),
              SizedBox(width: 6.r),
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
