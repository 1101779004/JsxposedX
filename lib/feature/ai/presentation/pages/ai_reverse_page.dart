import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/feature/ai/domain/models/ai_context.dart';
import 'package:JsxposedX/feature/ai/domain/services/prompt_builder.dart';
import 'package:JsxposedX/feature/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/feature/ai/presentation/widgets/ai_chat_input.dart';
import 'package:JsxposedX/feature/ai/presentation/widgets/ai_chat_list.dart';
import 'package:JsxposedX/feature/ai/presentation/widgets/ai_reverse_header.dart';
import 'package:JsxposedX/feature/apk_analysis/presentation/pages/apk_analysis_page.dart';
import 'package:JsxposedX/feature/apk_analysis/presentation/providers/apk_analysis_action_provider.dart';
import 'package:JsxposedX/feature/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiReversePage extends HookConsumerWidget {
  final String packageName;

  const AiReversePage({super.key, required this.packageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apkActionRepository = ref.read(apkAnalysisActionRepositoryProvider);
    final chatNotifier = ref.read(
      aiChatActionProvider(packageName: packageName).notifier,
    );
    final chatState = ref.watch(
      aiChatActionProvider(packageName: packageName),
    );
    final scrollController = useScrollController();
    final pageController = usePageController();
    final sessionId = useState<String>('');

    final lastMessageId = useRef<String?>(null);
    useEffect(() {
      if (chatState.messages.isNotEmpty) {
        final currentLastId = chatState.messages.last.id;
        final isNewMessage = lastMessageId.value != currentLastId;
        lastMessageId.value = currentLastId;
        if (scrollController.hasClients && isNewMessage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
      return null;
    }, [chatState.messages.length]);

    useEffect(() {
      const followThreshold = 80.0;

      final subscription = chatNotifier.streamingContentStream.listen((content) {
        if (content.isEmpty || !scrollController.hasClients) return;
        if (scrollController.offset > followThreshold) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;
          if (scrollController.offset > followThreshold) return;
          scrollController.jumpTo(0.0);
        });
      });

      return subscription.cancel;
    }, [chatNotifier, scrollController]);

    useEffect(() {
      Future.microtask(() async {
        SmartDialog.showLoading();
        try {
          // 1. 打开 APK 会话
          final id = await apkActionRepository.openApkSession(packageName);
          sessionId.value = id;

          // 2. 解析 Manifest 构建上下文
          final queryRepo = ref.read(apkAnalysisQueryRepositoryProvider);
          final manifest = await queryRepo.parseManifest(id);
          
          // 3. 获取 APK 资源，提取 SO 文件列表
          final assets = await queryRepo.getApkAssets(id);
          final soFiles = assets
              .where((a) => a.name.endsWith('.so'))
              .map((a) => a.path)
              .toList();
          final apkContext = AiApkContext.fromManifest(manifest, soFiles: soFiles);

          // 4. 获取 dex 文件路径
          final dexPaths = assets
              .where((a) => a.name.endsWith('.dex'))
              .map((a) => a.path)
              .toList();

          // 5. 构建 system prompt
          final isZh = context.isZh;
          final apiSummary = await PromptBuilder.loadApiSummary();
          final prompt = PromptBuilder(isZh: isZh)
              .withApkContext(apkContext)
              .withApiSummary(apiSummary)
              .withTools()
              .withSoTools()
              .buildSystemPrompt();
          // 6. 设置 APK 分析会话和 system prompt 到 Provider
          final notifier = ref
              .read(aiChatActionProvider(packageName: packageName).notifier);
          notifier.setSystemPrompt(prompt);
          notifier.setApkSession(id, dexPaths);
        } catch (_) {
        } finally {
          SmartDialog.dismiss();
        }
      });
      return () {
        final id = sessionId.value;
        if (id.isNotEmpty) {
          apkActionRepository.closeApkSession(id);
        }
      };
    }, []);

    final lastBackPressTime = useRef<DateTime?>(null);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final now = DateTime.now();
        final last = lastBackPressTime.value;
        if (last != null && now.difference(last) < const Duration(seconds: 2)) {
          Navigator.of(context).pop();
        } else {
          lastBackPressTime.value = now;
          ToastMessage.show(context.l10n.pressBackAgainToExit);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              AiReverseHeader(packageName: packageName),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    AiChatList(
                      messages: chatState.messages,
                      scrollController: scrollController,
                      packageName: packageName,
                    ),
                    ApkAnalysisPage(
                      packageName: packageName,
                      sessionId: sessionId.value,
                    ),
                  ],
                ),
              ),
              AiChatInput(
                packageName: packageName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
