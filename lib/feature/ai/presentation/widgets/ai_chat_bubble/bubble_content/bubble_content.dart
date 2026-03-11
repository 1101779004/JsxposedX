import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bubble_states/bubble_state.dart';
import '../bubble_toolbar/bubble_toolbar.dart';
import 'widgets/ai_code_element_builder.dart';
import 'widgets/dot_loading_indicator.dart';
import 'widgets/tool_calling_indicator.dart';
import 'widgets/tool_result_card.dart';

abstract class BaseBubbleContentPart {
  const BaseBubbleContentPart();

  Widget build(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    if (state.isLoading) {
      return buildLoading(context, state);
    }
    if (state.isToolResult) {
      return buildToolResult(context, state);
    }
    if (state.isToolCalling) {
      return buildToolCalling(context, state);
    }
    return buildMarkdown(context, state, toolbarPart: toolbarPart);
  }

  @protected
  Widget buildLoading(BuildContext context, BubbleState state) {
    return const DotLoadingIndicator();
  }

  @protected
  Widget buildToolResult(BuildContext context, BubbleState state) {
    return ToolResultCard(content: state.content);
  }

  @protected
  Widget buildToolCalling(BuildContext context, BubbleState state) {
    return ToolCallingIndicator(content: state.content);
  }

  @protected
  Widget buildMarkdown(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    return GestureDetector(
      onLongPress: () => toolbarPart.handleCopyToClipboard(context, state.content),
      child: MarkdownBody(
        data: resolveMarkdownData(context, state),
        styleSheet: buildMarkdownTheme(context, state),
        selectable: false,
        builders: {
          'code': AiCodeElementBuilder(state: state, toolbarPart: toolbarPart),
        },
        shrinkWrap: true,
        fitContent: true,
      ),
    );
  }

  @protected
  String resolveMarkdownData(BuildContext context, BubbleState state) {
    if (state.isError && state.content.isEmpty) {
      return context.l10n.aiMessageSendFailed;
    }
    return state.content;
  }

  @protected
  MarkdownStyleSheet buildMarkdownTheme(BuildContext context, BubbleState state) {
    return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
      p: TextStyle(
        color: state.isUser
            ? Colors.white
            : (context.isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : context.textTheme.bodyLarge?.color),
        fontSize: 15.sp,
        height: 1.5,
      ),
      code: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'monospace',
        backgroundColor: context.isDark
            ? Colors.black26
            : Colors.black.withValues(alpha: 0.05),
        color: state.isUser
            ? Colors.white
            : (context.isDark
                  ? context.colorScheme.secondaryContainer
                  : Colors.deepOrange),
      ),
      codeblockDecoration: const BoxDecoration(),
      blockquoteDecoration: BoxDecoration(
        color: context.isDark ? Colors.white10 : Colors.grey[200],
        borderRadius: BorderRadius.circular(4.r),
      ),
      listBullet: TextStyle(
        color: state.isUser ? Colors.white : context.colorScheme.primary,
      ),
    );
  }
}

class DefaultBubbleContentPart extends BaseBubbleContentPart {
  const DefaultBubbleContentPart();
}
