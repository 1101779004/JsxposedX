import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bubble_states/bubble_state.dart';
import 'widgets/code_save_action.dart';

abstract class BaseBubbleToolbarPart {
  const BaseBubbleToolbarPart();

  void handleCopyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastMessage.show(context.l10n.codeCopied);
  }

  List<Widget> buildCodeActions({
    required BubbleState state,
    required String language,
    required String code,
  }) {
    return const [];
  }
}

class DefaultBubbleToolbarPart extends BaseBubbleToolbarPart {
  const DefaultBubbleToolbarPart();

  @override
  List<Widget> buildCodeActions({
    required BubbleState state,
    required String language,
    required String code,
  }) {
    return [
      CodeSaveAction(
        code: code,
        packageName: state.packageName,
        language: language,
      ),
      SizedBox(width: 4.w),
    ];
  }
}
