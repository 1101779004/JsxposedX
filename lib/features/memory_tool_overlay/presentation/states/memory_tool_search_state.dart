import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_tool_search_state.freezed.dart';

enum MemoryToolSearchValidationError { valueRequired, invalidBytes }

@freezed
abstract class MemoryToolSearchState with _$MemoryToolSearchState {
  const factory MemoryToolSearchState({
    @Default('') String value,
    @Default(SearchValueType.i32) SearchValueType selectedType,
    @Default(true) bool isLittleEndian,
    MemoryToolSearchValidationError? validationError,
  }) = _MemoryToolSearchState;
}
