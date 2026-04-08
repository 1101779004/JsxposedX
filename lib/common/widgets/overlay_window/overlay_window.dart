import 'dart:math' as math;

import 'package:JsxposedX/common/widgets/overlay_window/overlay_window_controller.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_window_scope.dart';
import 'package:flutter/material.dart';

class OverlayWindow extends StatelessWidget {
  const OverlayWindow({
    super.key,
    required this.child,
    this.header,
    this.title,
    this.subtitle,
    this.onClose,
    this.onMinimize,
    this.onBackdropTap,
    this.footer,
    this.margin = const EdgeInsets.all(20),
    this.maxWidth = 560,
    this.maxHeight,
  });

  final Widget child;
  final Widget? header;
  final String? title;
  final String? subtitle;
  final VoidCallback? onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onBackdropTap;
  final Widget? footer;
  final EdgeInsetsGeometry margin;
  final double maxWidth;
  final double? maxHeight;

  static Future<OverlayWindowStatus> show(
    BuildContext context, {
    required int scene,
    OverlayWindowPresentation presentation = const OverlayWindowPresentation(),
  }) {
    return OverlayWindowScope.of(
      context,
    ).show(context, scene: scene, presentation: presentation);
  }

  static Future<OverlayWindowStatus> dismiss(BuildContext context) {
    return OverlayWindowScope.of(context).hide();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeader = header ?? _buildHeader(context);
    final hasHeader = resolvedHeader != null;
    final colorScheme = Theme.of(context).colorScheme;
    final backdropTapHandler = onBackdropTap ?? onMinimize ?? onClose;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final resolvedMaxHeight = maxHeight == null
              ? constraints.maxHeight
              : math.min(maxHeight!, constraints.maxHeight);

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: backdropTapHandler,
                child: const _OverlayBackdrop(),
              ),
              SafeArea(
                child: Padding(
                  padding: margin,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                        maxHeight: resolvedMaxHeight,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.97),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.42,
                            ),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.24),
                              blurRadius: 20,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (hasHeader) resolvedHeader,
                                if (hasHeader) const SizedBox(height: 16),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.58),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: child,
                                  ),
                                ),
                                if (footer != null) ...<Widget>[
                                  const SizedBox(height: 12),
                                  footer!,
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget? _buildHeader(BuildContext context) {
    if (title == null &&
        subtitle == null &&
        onClose == null &&
        onMinimize == null) {
      return null;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.memory_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (title != null)
                    Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (subtitle != null) ...<Widget>[
                    if (title != null) const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onMinimize != null) ...<Widget>[
              _OverlayHeaderButton(
                icon: Icons.remove_rounded,
                onPressed: onMinimize!,
              ),
              const SizedBox(width: 8),
            ],
            if (onClose != null)
              _OverlayHeaderButton(
                icon: Icons.close_rounded,
                onPressed: onClose!,
              ),
          ],
        ),
      ),
    );
  }
}

class _OverlayBackdrop extends StatelessWidget {
  const _OverlayBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0x990B1020)),
      child: const SizedBox.expand(),
    );
  }
}

class _OverlayHeaderButton extends StatelessWidget {
  const _OverlayHeaderButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
