import 'package:flutter/material.dart';

class OverlayPanelViewport {
  const OverlayPanelViewport(this.constraints);

  final BoxConstraints constraints;

  bool get isLandscape =>
      constraints.maxWidth > constraints.maxHeight * 1.1;

  double get availableWidth =>
      (constraints.maxWidth - 20.0).clamp(0.0, double.infinity).toDouble();

  double get availableHeight =>
      constraints.maxHeight.clamp(0.0, double.infinity).toDouble();

  OverlayPanelLayout? resolveLayout({
    required double maxWidthPortrait,
    required double maxWidthLandscape,
    required double maxHeightPortrait,
    required double maxHeightLandscape,
    double landscapeHeightFactor = 0.9,
  }) {
    final dialogWidthCap = isLandscape ? maxWidthLandscape : maxWidthPortrait;
    final dialogHeightCap = isLandscape
        ? maxHeightLandscape
        : maxHeightPortrait;
    final width = availableWidth < dialogWidthCap
        ? availableWidth
        : dialogWidthCap;
    final maxHeight = isLandscape
        ? availableHeight * landscapeHeightFactor
        : (availableHeight < dialogHeightCap
              ? availableHeight
              : dialogHeightCap);

    if (width <= 0 || maxHeight <= 0) {
      return null;
    }

    return OverlayPanelLayout(
      width: width,
      maxHeight: maxHeight,
    );
  }

  OverlayPanelScaledLayout? resolveScaledLayout({
    required double maxWidthPortrait,
    required double maxWidthLandscape,
    required double maxHeightPortrait,
    required double maxHeightLandscape,
    required Size portraitBaseSize,
    required Size landscapeBaseSize,
    double landscapeHeightFactor = 0.9,
    double minScalePortrait = 0.5,
    double minScaleLandscape = 0.66,
    double maxScale = 1.0,
  }) {
    final layout = resolveLayout(
      maxWidthPortrait: maxWidthPortrait,
      maxWidthLandscape: maxWidthLandscape,
      maxHeightPortrait: maxHeightPortrait,
      maxHeightLandscape: maxHeightLandscape,
      landscapeHeightFactor: landscapeHeightFactor,
    );

    if (layout == null) {
      return null;
    }

    final baseSize = isLandscape ? landscapeBaseSize : portraitBaseSize;
    final scale = (layout.width / baseSize.width < layout.maxHeight / baseSize.height
            ? layout.width / baseSize.width
            : layout.maxHeight / baseSize.height)
        .clamp(isLandscape ? minScaleLandscape : minScalePortrait, maxScale)
        .toDouble();

    return OverlayPanelScaledLayout(
      layout: layout,
      scale: scale,
    );
  }
}

typedef OverlayPanelDialogBuilder = Widget Function(
  BuildContext context,
  OverlayPanelViewport viewport,
);

class OverlayPanelLayout {
  const OverlayPanelLayout({
    required this.width,
    required this.maxHeight,
  });

  final double width;
  final double maxHeight;
}

class OverlayPanelScaledLayout {
  const OverlayPanelScaledLayout({
    required this.layout,
    required this.scale,
  });

  final OverlayPanelLayout layout;
  final double scale;
}

class OverlayPanelCard extends StatelessWidget {
  const OverlayPanelCard({
    super.key,
    required this.layout,
    required this.child,
    this.color,
    this.borderRadius = 18.0,
    this.clipBehavior = Clip.antiAlias,
    this.height,
    this.minWidth,
    this.maxWidth,
  });

  final OverlayPanelLayout layout;
  final Widget child;
  final Color? color;
  final double borderRadius;
  final Clip clipBehavior;
  final double? height;
  final double? minWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = maxWidth == null
        ? layout.width
        : layout.width < maxWidth!
        ? layout.width
        : maxWidth!;
    final resolvedMinWidth = minWidth == null
        ? 0.0
        : minWidth! < resolvedWidth
        ? minWidth!
        : resolvedWidth;

    return Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: clipBehavior,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: resolvedMinWidth,
          maxWidth: resolvedWidth,
          maxHeight: layout.maxHeight,
        ),
        child: SizedBox(
          width: resolvedWidth,
          height: height,
          child: child,
        ),
      ),
    );
  }
}

class OverlayPanelDialog extends StatelessWidget {
  const OverlayPanelDialog({
    super.key,
    required this.childBuilder,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierOpacity = 0.35,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.alignment = Alignment.center,
  });

  final OverlayPanelDialogBuilder childBuilder;
  final VoidCallback? onClose;
  final bool barrierDismissible;
  final double barrierOpacity;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: barrierOpacity),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible ? onClose : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = OverlayPanelViewport(constraints);

            return Align(
              alignment: alignment,
              child: Padding(
                padding: padding,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: childBuilder(context, viewport),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
