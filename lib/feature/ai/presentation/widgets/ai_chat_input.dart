import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/feature/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/feature/ai/domain/models/ai_session_init_state.dart';
import 'package:JsxposedX/feature/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/feature/ai/presentation/states/ai_chat_action_state.dart';
import 'package:JsxposedX/feature/ai/presentation/widgets/ai_quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiChatInput extends HookConsumerWidget {
  final String packageName;
  final String? systemPrompt;
  final bool showQuickActions;
  final Future<void> Function()? onRetryInitialization;
  final VoidCallback? onOpenAnalysis;

  const AiChatInput({
    super.key,
    required this.packageName,
    this.systemPrompt,
    this.showQuickActions = true,
    this.onRetryInitialization,
    this.onOpenAnalysis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final chatState = ref.watch(aiChatActionProvider(packageName: packageName));

    final textValue = useValueListenable(textController);
    final hasContent = textValue.text.trim().isNotEmpty;
    final isStreaming = chatState.isStreaming;
    final canSend = hasContent && chatState.canSend;
    final hasContextDetails =
        chatState.hasUserMessages ||
        chatState.sessionContext.hasStructuredMemory;
    final canRetryLastTurn = !hasContent && chatState.canRetryLastTurn;
    final canRetryInitialization =
        !hasContent &&
        chatState.sessionInitState == AiSessionInitState.failed &&
        onRetryInitialization != null;
    final actionIcon = isStreaming
        ? Icons.stop_rounded
        : canSend
        ? Icons.arrow_upward_rounded
        : canRetryLastTurn
        ? Icons.refresh_rounded
        : canRetryInitialization
        ? Icons.replay_rounded
        : Icons.arrow_upward_rounded;
    final actionColor =
        isStreaming || canSend || canRetryLastTurn || canRetryInitialization
        ? context.colorScheme.primary
        : context.theme.disabledColor;
    final hintText = switch (chatState.sessionInitState) {
      AiSessionInitState.initializing =>
        context.l10n.aiReverseSessionInitializingHint,
      AiSessionInitState.failed => context.l10n.aiReverseSessionInitFailedHint,
      AiSessionInitState.ready => context.l10n.aiChatInputHint,
    };
    final actionLabel = isStreaming
        ? context.l10n.aiStopGeneration
        : canSend
        ? context.l10n.sendToAi
        : canRetryLastTurn
        ? (chatState.canResumeToolPhase
              ? context.l10n.aiResumeToolPhase
              : chatState.canContinueGeneration
              ? context.l10n.aiContinue
              : context.l10n.aiRetryLastTurn)
        : canRetryInitialization
        ? context.l10n.aiRetryInitialization
        : context.l10n.aiUnavailableToSend;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showQuickActions)
          AiQuickActions(
            packageName: packageName,
            systemPrompt: systemPrompt,
            onOpenAnalysis: onOpenAnalysis,
          ),
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: context.isDark
                ? context.theme.scaffoldBackgroundColor
                : Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.isDark
                  ? context.colorScheme.surfaceContainerLow
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasContextDetails)
                    GestureDetector(
                      onTap: () {
                        AppBottomSheet.show<void>(
                          context: context,
                          title: context.l10n.aiContextTitle,
                          child: _ContextSheet(chatState: chatState),
                        );
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        margin: EdgeInsets.only(left: 6.w),
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? context.colorScheme.surfaceContainerLow
                              : context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: context.colorScheme.outlineVariant
                                .withValues(alpha: context.isDark ? 0.55 : 0.8),
                          ),
                        ),
                        child: Tooltip(
                          message: context.l10n.aiContext,
                          child: Icon(
                            Icons.data_object_rounded,
                            size: 18.sp,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: TextField(
                        controller: textController,
                        enabled:
                            chatState.sessionInitState ==
                            AiSessionInitState.ready,
                        onSubmitted: (_) {
                          if (!canSend) {
                            return;
                          }
                          final text = textController.text.trim();
                          ref
                              .read(
                                aiChatActionProvider(
                                  packageName: packageName,
                                ).notifier,
                              )
                              .send(text);
                          textController.clear();
                        },
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.4,
                          color: context.textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(
                            color: context.theme.hintColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      final notifier = ref.read(
                        aiChatActionProvider(packageName: packageName).notifier,
                      );
                      if (isStreaming) {
                        await notifier.stopStreaming();
                        return;
                      }
                      if (canSend) {
                        final text = textController.text.trim();
                        await notifier.send(text);
                        textController.clear();
                        return;
                      }
                      if (canRetryLastTurn) {
                        await notifier.retryLastTurn();
                        return;
                      }
                      if (canRetryInitialization) {
                        await onRetryInitialization?.call();
                      }
                    },
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      margin: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: actionColor,
                      ),
                      child: Tooltip(
                        message: actionLabel,
                        child: Icon(
                          actionIcon,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContextSheet extends StatelessWidget {
  const _ContextSheet({required this.chatState});

  final AiChatActionState chatState;

  @override
  Widget build(BuildContext context) {
    final sessionContext = chatState.sessionContext;
    final stats = chatState.contextStats;
    final checkpoint = sessionContext.checkpoint;
    final layers = stats.includedLayers.join(' / ');
    final lastRecoveryMode = sessionContext.taskState.lastRecoveryMode;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ContextInfoCard(
                title: context.l10n.aiContextBudget,
                rows: [
                  '${context.l10n.aiContextBudget}: ${stats.estimatedTokens}/${stats.tokenBudget}',
                  '${context.l10n.aiContextRemaining}: ${stats.remainingTokens}',
                  '${context.l10n.aiContextLayers}: ${layers.isEmpty ? '-' : layers}',
                  '${context.l10n.aiContextRecentRounds}: ${stats.recentRoundsKept}',
                  '${context.l10n.aiContextCompression}: '
                      '${_localizedCompactReason(context, stats.compactReason)}',
                  '${context.l10n.aiContextMigration}: '
                      '${stats.migratedLegacySummary ? context.l10n.aiContextMigrationDone : context.l10n.aiContextMigrationNone}',
                  '${context.l10n.aiContextToolTrace}: '
                      '${sessionContext.hasPendingToolPhase ? context.l10n.aiContextToolTracePending : context.l10n.aiContextToolTraceClear}',
                ],
              ),
              SizedBox(height: 10.h),
              _ContextInfoCard(
                title: context.l10n.aiContextMemory,
                rows: [
                  '${context.l10n.aiContextGoals}: ${_joinList(sessionContext.sessionMemory.userGoals)}',
                  '${context.l10n.aiContextFacts}: ${_joinList(sessionContext.sessionMemory.confirmedFacts)}',
                  '${context.l10n.aiContextHypotheses}: ${_joinList(sessionContext.sessionMemory.openHypotheses)}',
                  '${context.l10n.aiContextFindings}: ${_joinList(sessionContext.sessionMemory.toolFindings)}',
                  '${context.l10n.aiContextTaskBlockers}: ${_joinList(sessionContext.sessionMemory.blockers)}',
                  '${context.l10n.aiContextTaskCurrent}: ${sessionContext.taskState.currentStep ?? context.l10n.aiSummaryEmpty}',
                  '${context.l10n.aiContextTaskNext}: ${sessionContext.taskState.nextStep ?? context.l10n.aiSummaryEmpty}',
                ],
              ),
              SizedBox(height: 10.h),
              _ContextInfoCard(
                title: context.l10n.aiContextCheckpoint,
                rows: checkpoint == null
                    ? [context.l10n.aiContextNoCheckpoint]
                    : [
                        '${context.l10n.aiContextCheckpointTime}: ${checkpoint.createdAtIso}',
                        '${context.l10n.aiContextCheckpointPrompt}: ${checkpoint.lastUserMessage?.content ?? context.l10n.aiSummaryEmpty}',
                        '${context.l10n.aiContextCheckpointMode}: ${_localizedRecoveryMode(context, lastRecoveryMode)}',
                      ],
              ),
              SizedBox(height: 10.h),
              _ContextInfoCard(
                title: context.l10n.aiContextLastError,
                rows: [
                  sessionContext.taskState.lastError ??
                      context.l10n.aiContextNoError,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _joinList(List<String> items) {
    if (items.isEmpty) {
      return '';
    }
    return items.join(' | ');
  }

  String _localizedCompactReason(BuildContext context, String? reason) {
    return switch (reason) {
      'budget' => context.l10n.aiContextCompactReasonBudget,
      'manual' => context.l10n.aiContextCompactReasonManual,
      _ => context.l10n.aiContextCompactReasonNone,
    };
  }

  String _localizedRecoveryMode(
    BuildContext context,
    AiChatRecoveryMode recoveryMode,
  ) {
    return switch (recoveryMode) {
      AiChatRecoveryMode.retryLastTurn => context.l10n.aiRecoveryModeRetry,
      AiChatRecoveryMode.continueGeneration =>
        context.l10n.aiRecoveryModeContinue,
      AiChatRecoveryMode.resumeToolPhase => context.l10n.aiRecoveryModeTool,
      AiChatRecoveryMode.retryInitialization =>
        context.l10n.aiRetryInitialization,
      AiChatRecoveryMode.none => '-',
    };
  }
}

class _ContextInfoCard extends StatelessWidget {
  const _ContextInfoCard({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 8.h),
          for (final item in rows)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13.sp, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
