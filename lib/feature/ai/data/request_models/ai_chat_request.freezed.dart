// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatRequest {

 String get model; List<AiMessageDto> get messages; bool get stream; double get temperature; int get maxTokens;@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? get tools;
/// Create a copy of AiChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatRequestCopyWith<AiChatRequest> get copyWith => _$AiChatRequestCopyWithImpl<AiChatRequest>(this as AiChatRequest, _$identity);

  /// Serializes this AiChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatRequest&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.stream, stream) || other.stream == stream)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&const DeepCollectionEquality().equals(other.tools, tools));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,model,const DeepCollectionEquality().hash(messages),stream,temperature,maxTokens,const DeepCollectionEquality().hash(tools));

@override
String toString() {
  return 'AiChatRequest(model: $model, messages: $messages, stream: $stream, temperature: $temperature, maxTokens: $maxTokens, tools: $tools)';
}


}

/// @nodoc
abstract mixin class $AiChatRequestCopyWith<$Res>  {
  factory $AiChatRequestCopyWith(AiChatRequest value, $Res Function(AiChatRequest) _then) = _$AiChatRequestCopyWithImpl;
@useResult
$Res call({
 String model, List<AiMessageDto> messages, bool stream, double temperature, int maxTokens,@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools
});




}
/// @nodoc
class _$AiChatRequestCopyWithImpl<$Res>
    implements $AiChatRequestCopyWith<$Res> {
  _$AiChatRequestCopyWithImpl(this._self, this._then);

  final AiChatRequest _self;
  final $Res Function(AiChatRequest) _then;

/// Create a copy of AiChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? messages = null,Object? stream = null,Object? temperature = null,Object? maxTokens = null,Object? tools = freezed,}) {
  return _then(_self.copyWith(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessageDto>,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,tools: freezed == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatRequest].
extension AiChatRequestPatterns on AiChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _AiChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  List<AiMessageDto> messages,  bool stream,  double temperature,  int maxTokens, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatRequest() when $default != null:
return $default(_that.model,_that.messages,_that.stream,_that.temperature,_that.maxTokens,_that.tools);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  List<AiMessageDto> messages,  bool stream,  double temperature,  int maxTokens, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)  $default,) {final _that = this;
switch (_that) {
case _AiChatRequest():
return $default(_that.model,_that.messages,_that.stream,_that.temperature,_that.maxTokens,_that.tools);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  List<AiMessageDto> messages,  bool stream,  double temperature,  int maxTokens, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)?  $default,) {final _that = this;
switch (_that) {
case _AiChatRequest() when $default != null:
return $default(_that.model,_that.messages,_that.stream,_that.temperature,_that.maxTokens,_that.tools);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatRequest implements AiChatRequest {
  const _AiChatRequest({required this.model, required final  List<AiMessageDto> messages, this.stream = true, this.temperature = 0.7, this.maxTokens = 300, @JsonKey(includeIfNull: false) final  List<Map<String, dynamic>>? tools}): _messages = messages,_tools = tools;
  factory _AiChatRequest.fromJson(Map<String, dynamic> json) => _$AiChatRequestFromJson(json);

@override final  String model;
 final  List<AiMessageDto> _messages;
@override List<AiMessageDto> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool stream;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  int maxTokens;
 final  List<Map<String, dynamic>>? _tools;
@override@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? get tools {
  final value = _tools;
  if (value == null) return null;
  if (_tools is EqualUnmodifiableListView) return _tools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AiChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatRequestCopyWith<_AiChatRequest> get copyWith => __$AiChatRequestCopyWithImpl<_AiChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatRequest&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.stream, stream) || other.stream == stream)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&const DeepCollectionEquality().equals(other._tools, _tools));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,model,const DeepCollectionEquality().hash(_messages),stream,temperature,maxTokens,const DeepCollectionEquality().hash(_tools));

@override
String toString() {
  return 'AiChatRequest(model: $model, messages: $messages, stream: $stream, temperature: $temperature, maxTokens: $maxTokens, tools: $tools)';
}


}

/// @nodoc
abstract mixin class _$AiChatRequestCopyWith<$Res> implements $AiChatRequestCopyWith<$Res> {
  factory _$AiChatRequestCopyWith(_AiChatRequest value, $Res Function(_AiChatRequest) _then) = __$AiChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String model, List<AiMessageDto> messages, bool stream, double temperature, int maxTokens,@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools
});




}
/// @nodoc
class __$AiChatRequestCopyWithImpl<$Res>
    implements _$AiChatRequestCopyWith<$Res> {
  __$AiChatRequestCopyWithImpl(this._self, this._then);

  final _AiChatRequest _self;
  final $Res Function(_AiChatRequest) _then;

/// Create a copy of AiChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? messages = null,Object? stream = null,Object? temperature = null,Object? maxTokens = null,Object? tools = freezed,}) {
  return _then(_AiChatRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessageDto>,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,tools: freezed == tools ? _self._tools : tools // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}


}

// dart format on
