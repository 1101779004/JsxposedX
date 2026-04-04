import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillCustomPublishScript extends quill.EmbedBuilder {
  @override
  String get key => 'publish_script';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final Map<String, dynamic> data = jsonDecode(embedContext.node.value.data);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _PublishScriptCard(data: data),
    );
  }
}

class _PublishScriptCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const _PublishScriptCard({required this.data});

  @override
  State<_PublishScriptCard> createState() => _PublishScriptCardState();
}

class _PublishScriptCardState extends State<_PublishScriptCard> {
  bool _copied = false;

  String get _title => widget.data['title']?.toString() ?? '发布脚本';

  String get _targetName => widget.data['targetName']?.toString() ?? '';

  String get _packageName => widget.data['packageName']?.toString() ?? '';

  String get _description => widget.data['description']?.toString() ?? '';

  String get _scriptType =>
      widget.data['scriptType']?.toString() ?? 'xposed_js';

  String get _script => widget.data['script']?.toString() ?? '';

  Future<void> _copyScript() async {
    await Clipboard.setData(ClipboardData(text: _script));
    if (!mounted) {
      return;
    }
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  Color _scriptTypeColor(ColorScheme colorScheme) {
    switch (_scriptType) {
      case 'frida_js':
        return Colors.green;
      case 'xposed_js':
      default:
        return colorScheme.primary;
    }
  }

  String _scriptTypeLabel() {
    switch (_scriptType) {
      case 'frida_js':
        return 'Frida JS';
      case 'xposed_js':
      default:
        return 'Xposed JS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _scriptTypeColor(colorScheme);
    final isDark = theme.brightness == Brightness.dark;
    final cardBackground = Color.alphaBlend(
      accentColor.withOpacity(isDark ? 0.10 : 0.06),
      colorScheme.surface,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.22)),
        color: cardBackground,
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(isDark ? 0.10 : 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.95),
                        accentColor.withOpacity(0.72),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.code, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'jsxposedx脚本',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            label: _scriptTypeLabel(),
                            color: accentColor,
                          ),
                          _InfoChip(
                            label: _targetName,
                            color: colorScheme.secondary,
                            icon: Icons.apps_rounded,
                          ),
                          _InfoChip(
                            label: _packageName,
                            color: Colors.teal,
                            icon: Icons.inventory_2_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: colorScheme.onSurface.withOpacity(0.78),
                ),
              ),
            ],
            const SizedBox(height: 14),
            _CodePanel(
              title: 'JS 脚本',
              actionLabel: _copied ? '已复制' : '复制脚本',
              actionIcon: _copied ? Icons.check : Icons.copy_all_rounded,
              actionColor: _copied ? Colors.green : accentColor,
              onActionTap: _copyScript,
              child: SelectableText(
                _script,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.55,
                  color: Color(0xFFD7DBE0),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _InfoChip(
              color: Colors.red,
              label: "在JsxposedX中你可以直接获取到此脚本,你无需手动复制粘贴,你可以通过收藏该帖子让它被更方便的找到",
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _InfoChip({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopDots extends StatelessWidget {
  final Color accentColor;

  const _TopDots({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(accentColor.withOpacity(0.95)),
        const SizedBox(width: 6),
        _dot(accentColor.withOpacity(0.55)),
        const SizedBox(width: 6),
        _dot(accentColor.withOpacity(0.3)),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.82),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CodePanel extends StatelessWidget {
  final String title;
  final Widget child;
  final String? actionLabel;
  final IconData? actionIcon;
  final Color? actionColor;
  final VoidCallback? onActionTap;

  const _CodePanel({
    required this.title,
    required this.child,
    this.actionLabel,
    this.actionIcon,
    this.actionColor,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final panelColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF11161E)
        : const Color(0xFF18202A);

    return Container(
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
            child: Row(
              children: [
                _TopDots(accentColor: actionColor ?? colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (onActionTap != null &&
                    actionLabel != null &&
                    actionIcon != null)
                  InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (actionColor ?? colorScheme.primary).withOpacity(
                          0.12,
                        ),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: (actionColor ?? colorScheme.primary)
                              .withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            actionIcon,
                            size: 14,
                            color: actionColor ?? colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            actionLabel!,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: actionColor ?? colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1AFFFFFF)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
