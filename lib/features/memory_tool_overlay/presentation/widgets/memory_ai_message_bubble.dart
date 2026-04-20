import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/ai_chat_bubble.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_container.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/bubble_content.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MemoryAiChatBubble extends BaseAiChatBubble {
  const MemoryAiChatBubble({
    super.key,
    required super.content,
    required super.role,
    super.isError,
    super.onRetry,
    super.isToolCalling,
    super.packageName,
    super.retryLabel,
    super.loadingHint,
    this.isToolResultBubble = false,
  });

  final bool isToolResultBubble;

  @override
  BubbleState createBubbleState() {
    return _MemoryBubbleState(
      content: content,
      role: role,
      isError: isError,
      onRetry: onRetry,
      isToolCalling: isToolCalling,
      packageName: packageName,
      retryLabel: retryLabel,
      loadingHint: loadingHint,
      isToolResultBubble: isToolResultBubble,
    );
  }

  @override
  BaseBubbleContainerPart createContainerPart() {
    return const _MemoryBubbleContainerPart();
  }

  @override
  BaseBubbleContentPart createContentPart() {
    return const _MemoryBubbleContentPart();
  }
}

class MemoryAiStreamingChatBubble extends HookWidget {
  const MemoryAiStreamingChatBubble({
    super.key,
    required this.role,
    required this.isError,
    required this.isToolCalling,
    required this.isToolResultBubble,
    required this.retryLabel,
    required this.streamingContentStream,
    required this.streamingThinkingStream,
    this.onRetry,
    this.packageName,
  });

  final String role;
  final bool isError;
  final bool isToolCalling;
  final bool isToolResultBubble;
  final String retryLabel;
  final Stream<String> streamingContentStream;
  final Stream<bool> streamingThinkingStream;
  final VoidCallback? onRetry;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    final content = useState('');
    final lastUpdateTime = useState<DateTime?>(null);
    final isThinking = useState(false);

    useEffect(() {
      final subscription = streamingContentStream.listen((data) {
        if (!context.mounted) {
          return;
        }
        final now = DateTime.now();
        final lastUpdate = lastUpdateTime.value;
        if (data.isEmpty ||
            lastUpdate == null ||
            now.difference(lastUpdate).inMilliseconds >= 50) {
          lastUpdateTime.value = now;
          if (data != content.value) {
            content.value = data;
          }
        }
      });
      return subscription.cancel;
    }, [streamingContentStream]);

    useEffect(() {
      final subscription = streamingThinkingStream.listen((value) {
        if (!context.mounted) {
          return;
        }
        isThinking.value = value;
      });
      return subscription.cancel;
    }, [streamingThinkingStream]);

    return MemoryAiChatBubble(
      content: content.value,
      role: role,
      isError: isError,
      isToolCalling: isToolCalling,
      isToolResultBubble: isToolResultBubble,
      retryLabel: retryLabel,
      onRetry: onRetry,
      packageName: packageName,
      loadingHint: isThinking.value
          ? (context.isZh ? '正在整理当前内存上下文...' : 'Analyzing current memory context...')
          : null,
    );
  }
}

class _MemoryBubbleState extends BubbleState {
  const _MemoryBubbleState({
    required super.content,
    required super.role,
    required super.isError,
    required super.onRetry,
    required super.isToolCalling,
    required super.packageName,
    required this.isToolResultBubble,
    super.retryLabel,
    super.loadingHint,
  });

  final bool isToolResultBubble;

  @override
  bool get isToolResult => isToolResultBubble || super.isToolResult;

  bool get isSystem => role == 'system';
}

class _MemoryBubbleContainerPart extends BaseBubbleContainerPart {
  const _MemoryBubbleContainerPart();

  @override
  MainAxisAlignment resolveMainAxisAlignment(BubbleState state) {
    if (state is _MemoryBubbleState && state.isSystem) {
      return MainAxisAlignment.center;
    }
    return super.resolveMainAxisAlignment(state);
  }

  @override
  Alignment resolveBubbleAlignment(BubbleState state) {
    if (state is _MemoryBubbleState && state.isSystem) {
      return Alignment.center;
    }
    return super.resolveBubbleAlignment(state);
  }

  @override
  EdgeInsetsGeometry resolveBubbleMargin(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    return EdgeInsets.only(bottom: (isCompact ? 10 : 16) * scale);
  }

  @override
  BoxConstraints resolveBubbleConstraints(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    return BoxConstraints(
      maxWidth: (isCompact ? 328.0 : 540.0) * scale,
    );
  }

  @override
  Decoration? buildBubbleDecoration(
    BuildContext context,
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    if (state.isToolResult) {
      return null;
    }

    if (state is _MemoryBubbleState && state.isSystem) {
      return BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular((isCompact ? 12 : 14) * scale),
      );
    }

    if (state.isUser) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            context.colorScheme.primary,
            context.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular((isCompact ? 16 : 20) * scale),
          topRight: Radius.circular((isCompact ? 16 : 20) * scale),
          bottomLeft: Radius.circular((isCompact ? 16 : 20) * scale),
          bottomRight: Radius.circular(6 * scale),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.14),
            blurRadius: (isCompact ? 9 : 12) * scale,
            offset: Offset(0, (isCompact ? 3 : 4) * scale),
          ),
        ],
      );
    }

    return BoxDecoration(
      color: state.isError
          ? context.colorScheme.errorContainer.withValues(alpha: 0.74)
          : context.colorScheme.surface.withValues(alpha: 0.96),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isCompact ? 16 : 20) * scale),
        topRight: Radius.circular((isCompact ? 16 : 20) * scale),
        bottomLeft: Radius.circular(6 * scale),
        bottomRight: Radius.circular((isCompact ? 16 : 20) * scale),
      ),
      border: Border.all(
        color: state.isError
            ? context.colorScheme.error.withValues(alpha: 0.26)
            : context.colorScheme.outlineVariant.withValues(alpha: 0.24),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: (isCompact ? 8 : 12) * scale,
          offset: Offset(0, (isCompact ? 3 : 4) * scale),
        ),
      ],
    );
  }
}

class _MemoryBubbleContentPart extends BaseBubbleContentPart {
  const _MemoryBubbleContentPart();

  @override
  Widget buildToolResult(BuildContext context, BubbleState state) {
    return _MemoryToolResultCard(content: state.content);
  }

  @override
  MarkdownStyleSheet buildMarkdownTheme(BuildContext context, BubbleState state) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    final isSystem = state is _MemoryBubbleState && state.isSystem;
    final bodyColor = isSystem
        ? context.colorScheme.onSurfaceVariant
        : state.isUser
        ? context.colorScheme.onPrimary
        : state.isError
        ? context.colorScheme.onErrorContainer
        : context.colorScheme.onSurface;

    return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
      p: TextStyle(
        color: bodyColor,
        fontSize: (isCompact ? (isSystem ? 11 : 13) : (isSystem ? 12 : 15)) * scale,
        height: 1.48,
        fontWeight: isSystem ? FontWeight.w600 : FontWeight.w500,
      ),
      h1: TextStyle(
        color: bodyColor,
        fontSize: (isCompact ? 16 : 18) * scale,
        fontWeight: FontWeight.w800,
      ),

      h2: TextStyle(
        color: bodyColor,
        fontSize: (isCompact ? 14 : 16) * scale,
        fontWeight: FontWeight.w800,
      ),
      strong: TextStyle(
        color: bodyColor,
        fontWeight: FontWeight.w800,
      ),
      code: TextStyle(
        fontSize: (isCompact ? 12 : 13.5) * scale,
        fontFamily: 'monospace',
        backgroundColor: state.isUser
            ? Colors.white.withValues(alpha: 0.14)
            : context.colorScheme.primary.withValues(alpha: 0.08),
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
      ),
      codeblockDecoration: BoxDecoration(
        color: state.isUser
            ? Colors.black.withValues(alpha: 0.16)
            : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      blockquoteDecoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      listBullet: TextStyle(
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
        fontWeight: FontWeight.w800,
      ),
      a: TextStyle(
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

class _MemoryToolResultCard extends HookWidget {
  const _MemoryToolResultCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final expanded = useState(false);
    final lines = content.trim().split('\n');
    final summary = lines.isEmpty ? content : lines.first.trim();
    final detail = lines.length > 1 ? lines.skip(1).join('\n').trim() : '';
    final isSuccess = content.startsWith('✅');
    final accent = isSuccess
        ? const Color(0xFF2E9B62)
        : const Color(0xFFC84E4E);
    final tokens = _extractTokens(content);

    return Container(
      margin: EdgeInsets.only(bottom: 16 * scale),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: context.isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 26 * scale,
                  height: 26 * scale,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess
                        ? Icons.memory_rounded
                        : Icons.error_outline_rounded,
                    size: 15 * scale,
                    color: accent,
                  ),
                ),
                SizedBox(width: 8 * scale),
                Expanded(
                  child: Text(
                    summary,
                    style: TextStyle(
                      fontSize: 12.5 * scale,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      height: 1.35,
                    ),
                  ),
                ),
                if (detail.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      expanded.value = !expanded.value;
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2 * scale),
                      child: Icon(
                        expanded.value ? Icons.expand_less : Icons.expand_more,
                        size: 16 * scale,
                        color: accent,
                      ),
                    ),
                  ),
              ],
            ),
            if (tokens.isNotEmpty) ...<Widget>[
              SizedBox(height: 10 * scale),
              Wrap(
                spacing: 6 * scale,
                runSpacing: 6 * scale,
                children: tokens
                    .take(4)
                    .map((token) => _MemoryTokenChip(token: token, accent: accent))
                    .toList(growable: false),
              ),
            ],
            if (detail.isNotEmpty && expanded.value) ...<Widget>[
              SizedBox(height: 10 * scale),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10 * scale),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                child: SelectableText(
                  detail,
                  style: TextStyle(
                    fontSize: 11.5 * scale,
                    height: 1.45,
                    color: context.colorScheme.onSurface,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static List<String> _extractTokens(String text) {
    final pattern = RegExp(
      r'(0x[0-9a-fA-F]+|(?:[A-Za-z0-9_\-./]+\.so)|(?:[A-Za-z]:\\[^\s]+)|(?:\/[^\s]+))',
    );
    final results = <String>[];
    for (final match in pattern.allMatches(text)) {
      final token = match.group(0);
      if (token == null || results.contains(token)) {
        continue;
      }
      results.add(token);
      if (results.length >= 6) {
        break;
      }
    }
    return results;
  }
}

class _MemoryTokenChip extends StatelessWidget {
  const _MemoryTokenChip({
    required this.token,
    required this.accent,
  });

  final String token;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8 * scale,
        vertical: 4 * scale,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Text(
        token,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10 * scale,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}
