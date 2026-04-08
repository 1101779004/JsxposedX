class OverlaySceneEnum {
  static const int memoryTool = 0;
}

class OverlayWindowDisplayMode {
  static const String bubble = 'bubble';
  static const String panel = 'panel';
}

class OverlayWindowPayload {
  const OverlayWindowPayload({
    required this.scene,
    this.displayMode = OverlayWindowDisplayMode.bubble,
  });

  final int scene;
  final String displayMode;

  bool get isBubble => displayMode == OverlayWindowDisplayMode.bubble;
  bool get isPanel => displayMode == OverlayWindowDisplayMode.panel;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'scene': scene, 'displayMode': displayMode};
  }

  OverlayWindowPayload copyWith({int? scene, String? displayMode}) {
    return OverlayWindowPayload(
      scene: scene ?? this.scene,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  factory OverlayWindowPayload.fromRaw(dynamic raw) {
    if (raw is OverlayWindowPayload) {
      return raw;
    }

    if (raw is int) {
      return OverlayWindowPayload(
        scene: raw,
        displayMode: OverlayWindowDisplayMode.bubble,
      );
    }

    if (raw is String) {
      final parsedScene = int.tryParse(raw);
      if (parsedScene != null) {
        return OverlayWindowPayload(
          scene: parsedScene,
          displayMode: OverlayWindowDisplayMode.bubble,
        );
      }
    }

    if (raw is Map) {
      final normalized = raw.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final sceneValue = normalized['scene'];
      final parsedScene = switch (sceneValue) {
        int value => value,
        String value => int.tryParse(value),
        _ => null,
      };
      if (parsedScene != null) {
        final rawDisplayMode = normalized['displayMode']?.toString();
        return OverlayWindowPayload(
          scene: parsedScene,
          displayMode: rawDisplayMode == OverlayWindowDisplayMode.panel
              ? OverlayWindowDisplayMode.panel
              : OverlayWindowDisplayMode.bubble,
        );
      }
    }

    return const OverlayWindowPayload(
      scene: OverlaySceneEnum.memoryTool,
      displayMode: OverlayWindowDisplayMode.bubble,
    );
  }
}
