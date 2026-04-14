// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_tool_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoryToolSearchState {

 String get value; SearchValueType get selectedType; bool get isLittleEndian; MemoryToolSearchValidationError? get validationError;
/// Create a copy of MemoryToolSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryToolSearchStateCopyWith<MemoryToolSearchState> get copyWith => _$MemoryToolSearchStateCopyWithImpl<MemoryToolSearchState>(this as MemoryToolSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryToolSearchState&&(identical(other.value, value) || other.value == value)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.isLittleEndian, isLittleEndian) || other.isLittleEndian == isLittleEndian)&&(identical(other.validationError, validationError) || other.validationError == validationError));
}


@override
int get hashCode => Object.hash(runtimeType,value,selectedType,isLittleEndian,validationError);

@override
String toString() {
  return 'MemoryToolSearchState(value: $value, selectedType: $selectedType, isLittleEndian: $isLittleEndian, validationError: $validationError)';
}


}

/// @nodoc
abstract mixin class $MemoryToolSearchStateCopyWith<$Res>  {
  factory $MemoryToolSearchStateCopyWith(MemoryToolSearchState value, $Res Function(MemoryToolSearchState) _then) = _$MemoryToolSearchStateCopyWithImpl;
@useResult
$Res call({
 String value, SearchValueType selectedType, bool isLittleEndian, MemoryToolSearchValidationError? validationError
});




}
/// @nodoc
class _$MemoryToolSearchStateCopyWithImpl<$Res>
    implements $MemoryToolSearchStateCopyWith<$Res> {
  _$MemoryToolSearchStateCopyWithImpl(this._self, this._then);

  final MemoryToolSearchState _self;
  final $Res Function(MemoryToolSearchState) _then;

/// Create a copy of MemoryToolSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? selectedType = null,Object? isLittleEndian = null,Object? validationError = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as SearchValueType,isLittleEndian: null == isLittleEndian ? _self.isLittleEndian : isLittleEndian // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as MemoryToolSearchValidationError?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryToolSearchState].
extension MemoryToolSearchStatePatterns on MemoryToolSearchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryToolSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryToolSearchState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryToolSearchState value)  $default,){
final _that = this;
switch (_that) {
case _MemoryToolSearchState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryToolSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryToolSearchState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  SearchValueType selectedType,  bool isLittleEndian,  MemoryToolSearchValidationError? validationError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryToolSearchState() when $default != null:
return $default(_that.value,_that.selectedType,_that.isLittleEndian,_that.validationError);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  SearchValueType selectedType,  bool isLittleEndian,  MemoryToolSearchValidationError? validationError)  $default,) {final _that = this;
switch (_that) {
case _MemoryToolSearchState():
return $default(_that.value,_that.selectedType,_that.isLittleEndian,_that.validationError);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  SearchValueType selectedType,  bool isLittleEndian,  MemoryToolSearchValidationError? validationError)?  $default,) {final _that = this;
switch (_that) {
case _MemoryToolSearchState() when $default != null:
return $default(_that.value,_that.selectedType,_that.isLittleEndian,_that.validationError);case _:
  return null;

}
}

}

/// @nodoc


class _MemoryToolSearchState implements MemoryToolSearchState {
  const _MemoryToolSearchState({this.value = '', this.selectedType = SearchValueType.i32, this.isLittleEndian = true, this.validationError});
  

@override@JsonKey() final  String value;
@override@JsonKey() final  SearchValueType selectedType;
@override@JsonKey() final  bool isLittleEndian;
@override final  MemoryToolSearchValidationError? validationError;

/// Create a copy of MemoryToolSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryToolSearchStateCopyWith<_MemoryToolSearchState> get copyWith => __$MemoryToolSearchStateCopyWithImpl<_MemoryToolSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryToolSearchState&&(identical(other.value, value) || other.value == value)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.isLittleEndian, isLittleEndian) || other.isLittleEndian == isLittleEndian)&&(identical(other.validationError, validationError) || other.validationError == validationError));
}


@override
int get hashCode => Object.hash(runtimeType,value,selectedType,isLittleEndian,validationError);

@override
String toString() {
  return 'MemoryToolSearchState(value: $value, selectedType: $selectedType, isLittleEndian: $isLittleEndian, validationError: $validationError)';
}


}

/// @nodoc
abstract mixin class _$MemoryToolSearchStateCopyWith<$Res> implements $MemoryToolSearchStateCopyWith<$Res> {
  factory _$MemoryToolSearchStateCopyWith(_MemoryToolSearchState value, $Res Function(_MemoryToolSearchState) _then) = __$MemoryToolSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String value, SearchValueType selectedType, bool isLittleEndian, MemoryToolSearchValidationError? validationError
});




}
/// @nodoc
class __$MemoryToolSearchStateCopyWithImpl<$Res>
    implements _$MemoryToolSearchStateCopyWith<$Res> {
  __$MemoryToolSearchStateCopyWithImpl(this._self, this._then);

  final _MemoryToolSearchState _self;
  final $Res Function(_MemoryToolSearchState) _then;

/// Create a copy of MemoryToolSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? selectedType = null,Object? isLittleEndian = null,Object? validationError = freezed,}) {
  return _then(_MemoryToolSearchState(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as SearchValueType,isLittleEndian: null == isLittleEndian ? _self.isLittleEndian : isLittleEndian // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as MemoryToolSearchValidationError?,
  ));
}


}

// dart format on
