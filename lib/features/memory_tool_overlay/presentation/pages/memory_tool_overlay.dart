import 'package:JsxposedX/common/pages/toast.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolOverlay extends HookConsumerWidget {
  const MemoryToolOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Quick Workspace',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the floating bubble to open this panel. Use the top-right buttons to minimize or close it.',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const <Widget>[
            _OverlayInfoCard(
              icon: Icons.circle_rounded,
              title: 'Floating Bubble',
              description: 'Single tap opens the panel.',
            ),
            _OverlayInfoCard(
              icon: Icons.crop_square_rounded,
              title: 'Stable Panel',
              description: 'Uses plain Material rendering to avoid artifacts.',
            ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {
            ToastMessage.show('Overlay connected');
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Test Toast'),
        ),
      ],
    );
  }
}

class _OverlayInfoCard extends StatelessWidget {
  const _OverlayInfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: colorScheme.primary, size: 22),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
