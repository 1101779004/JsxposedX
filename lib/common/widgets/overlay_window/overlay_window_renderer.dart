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
  static const double _panelMaxWidth = 560;
  static const double _panelMaxHeight = 720;

  StreamSubscription<dynamic>? _subscription;
  OverlayWindowPayload _payload = const OverlayWindowPayload(
    scene: OverlaySceneEnum.memoryTool,
  );
  Offset? _bubbleOffset;
  Offset? _dragStartGlobal;
  Offset? _dragOrigin;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _subscription = FlutterOverlayWindow.overlayListener.listen(_handlePayload);
    unawaited(_syncOverlayFlag(_payload.displayMode));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).viewPadding;
    final bubbleSize = _bubbleSizeForScene(_payload.scene);

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hostSize = Size(constraints.maxWidth, constraints.maxHeight);
          final resolvedBubbleOffset = _resolvedBubbleOffset(
            hostSize: hostSize,
            safePadding: safePadding,
            bubbleSize: bubbleSize,
          );

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (_payload.isPanel)
                OverlayWindow(
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
                )
              else
                Positioned(
                  left: resolvedBubbleOffset.dx,
                  top: resolvedBubbleOffset.dy,
                  child: _OverlayBubble(
                    size: bubbleSize,
                    dragging: _dragging,
                    onTap: () =>
                        _setDisplayMode(OverlayWindowDisplayMode.panel),
                    onPanStart: (details) =>
                        _handlePanStart(details, resolvedBubbleOffset),
                    onPanUpdate: (details) => _handlePanUpdate(
                      details,
                      hostSize: hostSize,
                      safePadding: safePadding,
                      bubbleSize: bubbleSize,
                    ),
                    onPanEnd: (_) => _handlePanEnd(
                      hostSize: hostSize,
                      safePadding: safePadding,
                      bubbleSize: bubbleSize,
                    ),
                    onPanCancel: () => _handlePanEnd(
                      hostSize: hostSize,
                      safePadding: safePadding,
                      bubbleSize: bubbleSize,
                    ),
                  ),
                ),
            ],
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
      }
    });

    unawaited(_syncOverlayFlag(nextPayload.displayMode));
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
      }
    });

    await _syncOverlayFlag(displayMode);
  }

  Future<void> _syncOverlayFlag(String displayMode) async {
    final overlayFlag = displayMode == OverlayWindowDisplayMode.panel
        ? OverlayFlag.defaultFlag
        : OverlayFlag.focusPointer;
    await FlutterOverlayWindow.updateFlag(overlayFlag);
  }

  void _handlePanStart(DragStartDetails details, Offset resolvedBubbleOffset) {
    setState(() {
      _dragging = true;
      _dragStartGlobal = details.globalPosition;
      _dragOrigin = resolvedBubbleOffset;
    });
  }

  void _handlePanUpdate(
    DragUpdateDetails details, {
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final dragStartGlobal = _dragStartGlobal;
    final dragOrigin = _dragOrigin;
    if (dragStartGlobal == null || dragOrigin == null) {
      return;
    }

    final delta = details.globalPosition - dragStartGlobal;
    setState(() {
      _bubbleOffset = _clampBubbleOffset(
        dragOrigin + delta,
        hostSize: hostSize,
        safePadding: safePadding,
        bubbleSize: bubbleSize,
      );
    });
  }

  void _handlePanEnd({
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final currentOffset = _resolvedBubbleOffset(
      hostSize: hostSize,
      safePadding: safePadding,
      bubbleSize: bubbleSize,
    );

    setState(() {
      _bubbleOffset = _snapBubbleOffset(
        currentOffset,
        hostSize: hostSize,
        safePadding: safePadding,
        bubbleSize: bubbleSize,
      );
      _dragging = false;
      _dragStartGlobal = null;
      _dragOrigin = null;
    });
  }

  Offset _resolvedBubbleOffset({
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final currentOffset =
        _bubbleOffset ??
        _defaultBubbleOffset(
          hostSize: hostSize,
          safePadding: safePadding,
          bubbleSize: bubbleSize,
        );
    return _clampBubbleOffset(
      currentOffset,
      hostSize: hostSize,
      safePadding: safePadding,
      bubbleSize: bubbleSize,
    );
  }

  Offset _defaultBubbleOffset({
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(
      hostSize: hostSize,
      safePadding: safePadding,
      bubbleSize: bubbleSize,
    );
    final centerY = bounds.top + (bounds.height / 2);
    return Offset(bounds.right, centerY);
  }

  Offset _clampBubbleOffset(
    Offset offset, {
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(
      hostSize: hostSize,
      safePadding: safePadding,
      bubbleSize: bubbleSize,
    );
    return Offset(
      offset.dx.clamp(bounds.left, bounds.right).toDouble(),
      offset.dy.clamp(bounds.top, bounds.bottom).toDouble(),
    );
  }

  Offset _snapBubbleOffset(
    Offset offset, {
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final bounds = _bubbleBounds(
      hostSize: hostSize,
      safePadding: safePadding,
      bubbleSize: bubbleSize,
    );
    final bubbleCenterX = offset.dx + (bubbleSize / 2);
    final targetX = bubbleCenterX < (hostSize.width / 2)
        ? bounds.left
        : bounds.right;
    return Offset(
      targetX,
      offset.dy.clamp(bounds.top, bounds.bottom).toDouble(),
    );
  }

  _BubbleBounds _bubbleBounds({
    required Size hostSize,
    required EdgeInsets safePadding,
    required double bubbleSize,
  }) {
    final left = safePadding.left + _bubbleEdgePadding;
    final top = safePadding.top + _bubbleEdgePadding;
    final right =
        (hostSize.width - bubbleSize - safePadding.right - _bubbleEdgePadding)
            .clamp(left, double.infinity)
            .toDouble();
    final bottom =
        (hostSize.height - bubbleSize - safePadding.bottom - _bubbleEdgePadding)
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
