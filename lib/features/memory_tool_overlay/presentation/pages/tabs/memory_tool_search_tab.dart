import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/tabs/widgets/memory_tool_search_form_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/tabs/widgets/memory_tool_search_result_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/tabs/widgets/memory_tool_search_session_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchTab extends HookConsumerWidget {
  const MemoryToolSearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
    final searchFormState = ref.watch(memoryToolSearchFormProvider);
    final searchActionState = ref.watch(memorySearchActionProvider);
    final sessionStateAsync = ref.watch(getSearchSessionStateProvider);
    final hasMatchingSession = ref.watch(hasMatchingSearchSessionProvider);
    final resultsAsync = ref.watch(currentSearchResultsProvider);
    final valueController = useTextEditingController(
      text: searchFormState.value,
    );

    useEffect(() {
      if (valueController.text == searchFormState.value) {
        return null;
      }

      valueController.value = valueController.value.copyWith(
        text: searchFormState.value,
        selection: TextSelection.collapsed(
          offset: searchFormState.value.length,
        ),
        composing: TextRange.empty,
      );
      return null;
    }, [searchFormState.value, valueController]);

    final formCard = MemoryToolSearchFormCard(
      selectedProcess: selectedProcess,
      valueController: valueController,
      state: searchFormState,
      actionState: searchActionState,
      canRunNextScan: hasMatchingSession,
      onValueChanged: ref
          .read(memoryToolSearchFormProvider.notifier)
          .updateValue,
      onTypeChanged: ref.read(memoryToolSearchFormProvider.notifier).updateType,
      onEndianChanged: ref
          .read(memoryToolSearchFormProvider.notifier)
          .updateEndian,
      onFirstScan: ref.read(memoryToolSearchFormProvider.notifier).firstScan,
      onNextScan: ref.read(memoryToolSearchFormProvider.notifier).nextScan,
      onReset: ref
          .read(memoryToolSearchFormProvider.notifier)
          .resetSearchSession,
    );

    final sessionCard = MemoryToolSearchSessionCard(
      sessionStateAsync: sessionStateAsync,
      selectedPid: selectedProcess?.pid,
    );

    final resultCard = MemoryToolSearchResultCard(
      hasMatchingSession: hasMatchingSession,
      resultsAsync: resultsAsync,
      onRetry: () {
        ref.invalidate(getSearchSessionStateProvider);
        ref.invalidate(getSearchResultsProvider);
        ref.invalidate(hasMatchingSearchSessionProvider);
        ref.invalidate(currentSearchResultsProvider);
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.r;
        final padding = EdgeInsets.all(
          constraints.maxHeight < 320 ? 8.r : 12.r,
        );
        final isCompactLandscape =
            constraints.maxHeight < 320 && constraints.maxWidth > 560;
        final isCompactHeight = constraints.maxHeight < 420;

        if (isCompactLandscape) {
          return Padding(
            padding: padding,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 11,
                  child: ListView(
                    children: <Widget>[
                      formCard,
                      SizedBox(height: spacing),
                      sessionCard,
                    ],
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(flex: 9, child: resultCard),
              ],
            ),
          );
        }

        if (isCompactHeight) {
          final resultHeight =
              (constraints.maxHeight.clamp(220.0, 320.0) as double) * 0.9;
          return ListView(
            padding: padding,
            children: <Widget>[
              formCard,
              SizedBox(height: spacing),
              sessionCard,
              SizedBox(height: spacing),
              SizedBox(height: resultHeight, child: resultCard),
            ],
          );
        }

        return Padding(
          padding: padding,
          child: Column(
            children: <Widget>[
              formCard,
              SizedBox(height: spacing),
              sessionCard,
              SizedBox(height: spacing),
              Expanded(child: resultCard),
            ],
          ),
        );
      },
    );
  }
}
