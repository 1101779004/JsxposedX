import 'dart:async';

import 'package:JsxposedX/common/widgets/overlay_window/overlay_scene.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_window.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_window_controller.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_window_scope.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/memory_tool_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWindowRenderer extends StatefulWidget {
  const OverlayWindowRenderer({super.key});

  @override
  State<OverlayWindowRenderer> createState() => _OverlayWindowRendererState();
}

class _OverlayWindowRendererState extends State<OverlayWindowRenderer> {
  static const double _bubbleEdgePadding = 16;
  static const double _bubbleHostPadding = 16;
  static const double _panelMaxWidth = 560;
  static const double _panelMaxHeight = 720;

  StreamSubscription<dynamic>? _subscription;
  OverlayWindowPayload _payload = const OverlayWindowPayload(
    scene: OverlaySceneEnum.memoryTool,
  );
  _OverlayViewport? _fullViewport;
  Offset? _bubbleVisualOffset;
  Offset? _dragStartGlobal;
  Offset? _dragOrigin;
  bool _dragging = false;
  bool _needsBubbleHostSync = true;

  @override
  void initState() {
    super.initState();
    _subscription = FlutterOverlayWindow.overlayListener.listen(_handlePayload);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final safePadding = MediaQuery.of(context).viewPadding;
          final bubbleSize = _bubbleSizeForScene(_payload.scene);
          final hostSize = Size(constraints.maxWidth, constraints.maxHeight);
          _captureViewport(
            hostSize: hostSize,
            safePadding: safePadding,
            bubbleSize: bubbleSize,
          );

          final viewport = _resolvedViewport(
            hostSize: hostSize,
            safePadding: safePadding,
          );
          final resolvedBubbleVisualOffset = _resolvedBubbleVisualOffset(
            viewport: viewport,
            bubbleSize: bubbleSize,
          );

          if (_payload.isBubble &&
              _needsBubbleHostSync &&
              _fullViewport != null &&
              !_dragging) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || !_payload.isBubble || !_needsBubbleHostSync) {
                return;
              }
              unawaited(_syncOverlayHost());
            });
          }

          if (_payload.isPanel) {
            return OverlayWindow(
              title: _resolveTitle(_payload.scene),
              subtitle: 'Floating tool window',
              onBackdropTap: () =>
                  _setDisplayMode(OverlayWindowDisplayMode.bubble),
              onMinimize: () =>
                  _setDisplayMode(OverlayWindowDisplayMode.bubble),
              onClose: () {
                unawaited(OverlayWindowScope.of(context).hide());
              },
              maxWidth: _panelMaxWidth,
              maxHeight: _panelMaxHeight,
              child: _buildScene(_payload.scene),
            );
          }

          return SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(_bubbleHostPadding),
              child: _OverlayBubble(
                size: bubbleSize,
                dragging: _dragging,
                onTap: () => _setDisplayMode(OverlayWindowDisplayMode.panel),
                onPanStart: (details) =>
                    _handlePanStart(details, resolvedBubbleVisualOffset),
                onPanUpdate: (details) => _handlePanUpdate(
                  details,
                  viewport: viewport,
                  bubbleSize: bubbleSize,
                ),
                onPanEnd: (_) =>
                    _handlePanEnd(viewport: viewport, bubbleSize: bubbleSize),
                onPanCancel: () =>
                    _handlePanEnd(viewport: viewport, bubbleSize: bubbleSize),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePayload(dynamic rawPayload) {
    final nextPayload = OverlayWindowPayload.fromRaw(rawPayload);
    if (!mounted) {
      return;
    }

    setState(() {
      _payload = nextPayload;
      if (nextPayload.isPanel) {
        _dragging = false;
        _dragStartGlobal = null;
        _dragOrigin = null;
      } else {
        _needsBubbleHostSync = true;
      }
    });

    unawaited(_syncOverlayHost());
  }

  Future<void> _setDisplayMode(String displayMode) async {
    if (_payload.displayMode == displayMode) {
      return;
    }

    final nextPayload = _payload.copyWith(displayMode: displayMode);
    setState(() {
      _payload = nextPayload;
      if (nextPayload.isPanel) {
        _dragging = false;
        _dragStartGlobal = null;
        _dragOrigin = null;
      } else {
        _needsBubbleHostSync = true;
      }
    });

    await _syncOverlayHost();
  }

  Future<void> _syncOverlayHost() async {
    final overlayFlag = _payload.isPanel
        ? OverlayFlag.defaultFlag
        : OverlayFlag.focusPointer;

    if (_payload.isPanel) {
      await FlutterOverlayWindow.resizeOverlay(
        WindowSize.matchParent,
        WindowSize.fullCover,
        false,
      );
      await FlutterOverlayWindow.moveOverlay(const OverlayPosition(0, 0));
      await FlutterOverlayWindow.updateFlag(overlayFlag);
      return;
    }

    final viewport = _fullViewport;
    if (viewport == null) {
      _needsBubbleHostSync = true;
      await FlutterOverlayWindow.updateFlag(overlayFlag);
      return;
    }

    final bubbleSize = _bubbleSizeForScene(_payload.scene);
    final bubbleVisualOffset = _resolvedBubbleVisualOffset(
      viewport: viewport,
      bubbleSize: bubbleSize,
    );
    final hostExtent = _bubbleHostExtent(bubbleSize);
    _bubbleVisualOffset = bubbleVisualOffset;
    _needsBubbleHostSync = false;

    await FlutterOverlayWindow.resizeOverlay(
      hostExtent.round(),
      hostExtent.round(),
      false,
    );
    await _moveBubbleHostToVisualOffset(bubbleVisualOffset);
    await FlutterOverlayWindow.updateFlag(overlayFlag);
  }

  void _handlePanStart(
    DragStartDetails details,
    Offset resolvedBubbleVisualOffset,
  ) {
    setState(() {
      _dragging = true;
      _dragStartGlobal = details.globalPosition;
      _dragOrigin = resolvedBubbleVisualOffset;
    });
  }

  void _handlePanUpdate(
    DragUpdateDetails details, {
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final dragStartGlobal = _dragStartGlobal;
    final dragOrigin = _dragOrigin;
    if (dragStartGlobal == null || dragOrigin == null) {
      return;
    }

    final delta = details.globalPosition - dragStartGlobal;
    final nextVisualOffset = _clampBubbleVisualOffset(
      dragOrigin + delta,
      viewport: viewport,
      bubbleSize: bubbleSize,
    );
    setState(() {
      _bubbleVisualOffset = nextVisualOffset;
    });
    unawaited(_moveBubbleHostToVisualOffset(nextVisualOffset));
  }

  void _handlePanEnd({
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final currentVisualOffset = _resolvedBubbleVisualOffset(
      viewport: viewport,
      bubbleSize: bubbleSize,
    );
    final snappedVisualOffset = _snapBubbleVisualOffset(
      currentVisualOffset,
      viewport: viewport,
      bubbleSize: bubbleSize,
    );

    setState(() {
      _bubbleVisualOffset = snappedVisualOffset;
      _dragging = false;
      _dragStartGlobal = null;
      _dragOrigin = null;
    });
    unawaited(_moveBubbleHostToVisualOffset(snappedVisualOffset));
  }

  _OverlayViewport _resolvedViewport({
    required Size hostSize,
    required EdgeInsets safePadding,
  }) {
    return _fullViewport ??
        _OverlayViewport(size: hostSize, safePadding: safePadding);
  }

  void _captureViewport({
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final bubbleExtent = _bubbleHostExtent(bubbleSize);
    final isFullscreenHost =
        hostSize.width > bubbleExtent + 1 || hostSize.height > bubbleExtent + 1;
    if (!isFullscreenHost) {
      return;
    }

    final nextViewport = _OverlayViewport(
      size: hostSize,
      safePadding: safePadding,
    );
    if (_fullViewport == nextViewport) {
      return;
    }

    _fullViewport = nextViewport;
    if (_payload.isBubble) {
      _needsBubbleHostSync = true;
    }
  }

  double _bubbleHostExtent(double bubbleSize) {
    return bubbleSize + (_bubbleHostPadding * 2);
  }

  Future<void> _moveBubbleHostToVisualOffset(Offset bubbleVisualOffset) async {
    await FlutterOverlayWindow.moveOverlay(
      OverlayPosition(
        bubbleVisualOffset.dx - _bubbleHostPadding,
        bubbleVisualOffset.dy - _bubbleHostPadding,
      ),
    );
  }

  Offset _resolvedBubbleVisualOffset({
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final currentOffset =
        _bubbleVisualOffset ??
        _defaultBubbleVisualOffset(viewport: viewport, bubbleSize: bubbleSize);
    return _clampBubbleVisualOffset(
      currentOffset,
      viewport: viewport,
      bubbleSize: bubbleSize,
    );
  }

  Offset _defaultBubbleVisualOffset({
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(viewport: viewport, bubbleSize: bubbleSize);
    final centerY = bounds.top + (bounds.height / 2);
    return Offset(bounds.right, centerY);
  }

  Offset _clampBubbleVisualOffset(
    Offset offset, {
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(viewport: viewport, bubbleSize: bubbleSize);
    return Offset(
      offset.dx.clamp(bounds.left, bounds.right).toDouble(),
      offset.dy.clamp(bounds.top, bounds.bottom).toDouble(),
    );
  }

  Offset _snapBubbleVisualOffset(
    Offset offset, {
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(viewport: viewport, bubbleSize: bubbleSize);
    final bubbleCenterX = offset.dx + (bubbleSize / 2);
    final targetX = bubbleCenterX < (viewport.size.width / 2)
        ? bounds.left
        : bounds.right;
    return Offset(
      targetX,
      offset.dy.clamp(bounds.top, bounds.bottom).toDouble(),
    );
  }

  _BubbleBounds _bubbleBounds({
    required _OverlayViewport viewport,
    required double bubbleSize,
  }) {
    final left = viewport.safePadding.left + _bubbleEdgePadding;
    final top = viewport.safePadding.top + _bubbleEdgePadding;
    final right =
        (viewport.size.width -
                bubbleSize -
                viewport.safePadding.right -
                _bubbleEdgePadding)
            .clamp(left, double.infinity)
            .toDouble();
    final bottom =
        (viewport.size.height -
                bubbleSize -
                viewport.safePadding.bottom -
                _bubbleEdgePadding)
            .clamp(top, double.infinity)
            .toDouble();
    return _BubbleBounds(left: left, top: top, right: right, bottom: bottom);
  }

  Widget _buildScene(int scene) {
    switch (scene) {
      case OverlaySceneEnum.memoryTool:
        return const MemoryToolOverlay();
      default:
        return const SizedBox.shrink();
    }
  }

  double _bubbleSizeForScene(int scene) {
    switch (scene) {
      case OverlaySceneEnum.memoryTool:
        return OverlayWindowController.defaultBubbleSize;
      default:
        return OverlayWindowController.defaultBubbleSize;
    }
  }

  String _resolveTitle(int scene) {
    switch (scene) {
      case OverlaySceneEnum.memoryTool:
        return 'Memory Tool';
      default:
        return 'Overlay Window';
    }
  }
}

class _OverlayBubble extends StatelessWidget {
  const _OverlayBubble({
    required this.size,
    required this.dragging,
    required this.onTap,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPanCancel,
  });

  final double size;
  final bool dragging;
  final VoidCallback onTap;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final VoidCallback onPanCancel;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: dragging ? null : onTap,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        child: AnimatedScale(
          scale: dragging ? 1.04 : 1,
          duration: const Duration(milliseconds: 160),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF6AA9FF),
                  Color(0xFF8B7BFF),
                  Color(0xFFFFA87A),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.72),
                width: 2.2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF111A2E).withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(
              Icons.memory_rounded,
              color: Colors.white.withValues(alpha: 0.96),
              size: 58,
            ),
          ),
        ),
      ),
    );
  }
}

class _BubbleBounds {
  const _BubbleBounds({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get height => bottom - top;
}

class _OverlayViewport {
  const _OverlayViewport({required this.size, required this.safePadding});

  final Size size;
  final EdgeInsets safePadding;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _OverlayViewport &&
        other.size == size &&
        other.safePadding == safePadding;
  }

  @override
  int get hashCode => Object.hash(size, safePadding);
}
