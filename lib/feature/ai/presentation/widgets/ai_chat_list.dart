import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/feature/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/feature/ai/presentation/widgets/ai_chat_bubble/ai_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AiChatList extends HookConsumerWidget {
  final List<AiMessage> messages;
  final ScrollController scrollController;
  final String packageName;
  final String? systemPrompt;
  final String? customTitle;
  final String? customSubtitle;

  const AiChatList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.packageName,
    this.systemPrompt,
    this.customTitle,
    this.customSubtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (messages.isEmpty) {
      return Container(
        height: 0.5.sh,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary,
                ],
              ).createShader(bounds),
              child: Icon(Icons.auto_awesome, size: 80.w, color: Colors.white),
            ),
            SizedBox(height: 24.h),
            Text(
              customTitle ?? context.l10n.aiAssistantTitle,
              style: TextStyle(
                color: context.textTheme.titleLarge?.color?.withValues(alpha: 0.8),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              customSubtitle ?? context.l10n.aiAssistantSubtitle,
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      );
    }

    final actionProvider = ref.watch(aiChatActionProvider(packageName: packageName));
    final actionNotifier = ref.read(aiChatActionProvider(packageName: packageName).notifier);
    final visibleTotalCount = actionProvider.visibleMessagesCount;
    final hasMore = actionProvider.messages.length < visibleTotalCount;
    final remainingCount = (visibleTotalCount - actionProvider.messages.length)
        .clamp(0, visibleTotalCount);
    final isStreaming = actionProvider.isStreaming;

    // 我们需要将消息列表反转，因为 ListView(reverse: true) 会从列表末尾开始渲染
    final reversedMessages = messages.reversed.toList();

    return ListView.builder(
      controller: scrollController,
      reverse: true, // 从下往上渲染
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: reversedMessages.length + (hasMore ? 1 : 0),
      cacheExtent: 500, // 增加缓存范围，减少滚动时的闪烁
      addAutomaticKeepAlives: false, // 禁用自动保持存活
      addRepaintBoundaries: true, // 启用重绘边界优化
      itemBuilder: (context, index) {
        if (index == reversedMessages.length) {
          // 在最上方（reversed 列表的末尾）显示加载更多
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: TextButton(
              onPressed: () => ref.read(aiChatActionProvider(packageName: packageName).notifier).loadMore(),
              child: Text(
                context.l10n.aiShowMoreMessages(remainingCount),
                style: TextStyle(color: context.colorScheme.primary),
              ),
            ),
          );
        }

        final msg = reversedMessages[index];
        // 找到原始索引用于重试逻辑（由于是反转的，原始索引是 length - 1 - index）
        final originalIndex = messages.length - 1 - index;

        // 判断是否是最后一条消息且正在流式输出
        // 必须同时满足：1) 是第一条（最新的）2) 正在流式 3) 是助手消息
        final isLastMessage = index == 0;
        final shouldShowStreaming = isLastMessage &&
                                   isStreaming &&
                                   msg.role == 'assistant' &&
                                   !msg.isError;

        if (shouldShowStreaming) {
          // 最后一条消息在流式时，使用特殊的 StreamingBubble
          // 使用相同的 key 避免重建
          return _StreamingAiChatBubble(
            key: ValueKey(msg.id),
            messageId: msg.id,
            role: msg.role,
            isError: msg.isError,
            streamingContentStream: actionNotifier.streamingContentStream,
            onRetry: () => actionNotifier.retry(originalIndex),
            packageName: packageName,
          );
        }

        return RepaintBoundary(
          child: AiChatBubble(
            key: ValueKey(msg.id),
            content: msg.content,
            role: msg.role,
            isError: msg.isError,
            onRetry: () => actionNotifier.retry(originalIndex),
            packageName: packageName,
          ),
        );
      },
    );
  }
}

/// 专门用于显示流式内容的 Bubble，只有这个会监听 stream
class _StreamingAiChatBubble extends HookWidget {
  final String messageId;
  final String role;
  final bool isError;
  final Stream<String> streamingContentStream;
  final VoidCallback? onRetry;
  final String? packageName;

  const _StreamingAiChatBubble({
    super.key,
    required this.messageId,
    required this.role,
    required this.isError,
    required this.streamingContentStream,
    this.onRetry,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    // 手动管理订阅，确保更新只在安全的时机发生
    final content = useState('');
    final lastUpdateTime = useState<DateTime?>(null);

    useEffect(() {
      final subscription = streamingContentStream.listen((data) {
        // 检查 context 是否仍然挂载，避免在组件销毁后更新
        if (context.mounted) {
          final now = DateTime.now();
          final lastUpdate = lastUpdateTime.value;

          // 防抖：如果距离上次更新不到 50ms，跳过本次更新
          // 但如果内容为空（清空操作）或者是最终内容，立即更新
          if (data.isEmpty || lastUpdate == null || now.difference(lastUpdate).inMilliseconds >= 50) {
            lastUpdateTime.value = now;
            // 只在内容变化时更新，避免不必要的重建
            if (data != content.value) {
              content.value = data;
            }
          }
        }
      });

      return subscription.cancel;
    }, [streamingContentStream]);

    // 流式时直接把内容渲染为 markdown（包括工具调用进度文本）
    return RepaintBoundary(
      child: AiChatBubble(
        content: content.value,
        role: role,
        isError: isError,
        onRetry: onRetry,
        packageName: packageName,
      ),
    );
  }
}
