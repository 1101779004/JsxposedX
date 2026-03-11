// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anthropic_chat_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnthropicChatRequest {

 String get model; List<AnthropicMessage> get messages;@JsonKey(name: 'max_tokens') int get maxTokens; double get temperature; bool get stream;@JsonKey(includeIfNull: false) String? get system;@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? get tools;
/// Create a copy of AnthropicChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnthropicChatRequestCopyWith<AnthropicChatRequest> get copyWith => _$AnthropicChatRequestCopyWithImpl<AnthropicChatRequest>(this as AnthropicChatRequest, _$identity);

  /// Serializes this AnthropicChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropicChatRequest&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.stream, stream) || other.stream == stream)&&(identical(other.system, system) || other.system == system)&&const DeepCollectionEquality().equals(other.tools, tools));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,model,const DeepCollectionEquality().hash(messages),maxTokens,temperature,stream,system,const DeepCollectionEquality().hash(tools));

@override
String toString() {
  return 'AnthropicChatRequest(model: $model, messages: $messages, maxTokens: $maxTokens, temperature: $temperature, stream: $stream, system: $system, tools: $tools)';
}


}

/// @nodoc
abstract mixin class $AnthropicChatRequestCopyWith<$Res>  {
  factory $AnthropicChatRequestCopyWith(AnthropicChatRequest value, $Res Function(AnthropicChatRequest) _then) = _$AnthropicChatRequestCopyWithImpl;
@useResult
$Res call({
 String model, List<AnthropicMessage> messages,@JsonKey(name: 'max_tokens') int maxTokens, double temperature, bool stream,@JsonKey(includeIfNull: false) String? system,@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools
});




}
/// @nodoc
class _$AnthropicChatRequestCopyWithImpl<$Res>
    implements $AnthropicChatRequestCopyWith<$Res> {
  _$AnthropicChatRequestCopyWithImpl(this._self, this._then);

  final AnthropicChatRequest _self;
  final $Res Function(AnthropicChatRequest) _then;

/// Create a copy of AnthropicChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? messages = null,Object? maxTokens = null,Object? temperature = null,Object? stream = null,Object? system = freezed,Object? tools = freezed,}) {
  return _then(_self.copyWith(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AnthropicMessage>,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,tools: freezed == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnthropicChatRequest].
extension AnthropicChatRequestPatterns on AnthropicChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnthropicChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnthropicChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnthropicChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _AnthropicChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnthropicChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AnthropicChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  List<AnthropicMessage> messages, @JsonKey(name: 'max_tokens')  int maxTokens,  double temperature,  bool stream, @JsonKey(includeIfNull: false)  String? system, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnthropicChatRequest() when $default != null:
return $default(_that.model,_that.messages,_that.maxTokens,_that.temperature,_that.stream,_that.system,_that.tools);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  List<AnthropicMessage> messages, @JsonKey(name: 'max_tokens')  int maxTokens,  double temperature,  bool stream, @JsonKey(includeIfNull: false)  String? system, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)  $default,) {final _that = this;
switch (_that) {
case _AnthropicChatRequest():
return $default(_that.model,_that.messages,_that.maxTokens,_that.temperature,_that.stream,_that.system,_that.tools);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  List<AnthropicMessage> messages, @JsonKey(name: 'max_tokens')  int maxTokens,  double temperature,  bool stream, @JsonKey(includeIfNull: false)  String? system, @JsonKey(includeIfNull: false)  List<Map<String, dynamic>>? tools)?  $default,) {final _that = this;
switch (_that) {
case _AnthropicChatRequest() when $default != null:
return $default(_that.model,_that.messages,_that.maxTokens,_that.temperature,_that.stream,_that.system,_that.tools);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnthropicChatRequest implements AnthropicChatRequest {
  const _AnthropicChatRequest({required this.model, required final  List<AnthropicMessage> messages, @JsonKey(name: 'max_tokens') this.maxTokens = 4096, this.temperature = 1.0, this.stream = false, @JsonKey(includeIfNull: false) this.system, @JsonKey(includeIfNull: false) final  List<Map<String, dynamic>>? tools}): _messages = messages,_tools = tools;
  factory _AnthropicChatRequest.fromJson(Map<String, dynamic> json) => _$AnthropicChatRequestFromJson(json);

@override final  String model;
 final  List<AnthropicMessage> _messages;
@override List<AnthropicMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey(name: 'max_tokens') final  int maxTokens;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  bool stream;
@override@JsonKey(includeIfNull: false) final  String? system;
 final  List<Map<String, dynamic>>? _tools;
@override@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? get tools {
  final value = _tools;
  if (value == null) return null;
  if (_tools is EqualUnmodifiableListView) return _tools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AnthropicChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnthropicChatRequestCopyWith<_AnthropicChatRequest> get copyWith => __$AnthropicChatRequestCopyWithImpl<_AnthropicChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnthropicChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnthropicChatRequest&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.stream, stream) || other.stream == stream)&&(identical(other.system, system) || other.system == system)&&const DeepCollectionEquality().equals(other._tools, _tools));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,model,const DeepCollectionEquality().hash(_messages),maxTokens,temperature,stream,system,const DeepCollectionEquality().hash(_tools));

@override
String toString() {
  return 'AnthropicChatRequest(model: $model, messages: $messages, maxTokens: $maxTokens, temperature: $temperature, stream: $stream, system: $system, tools: $tools)';
}


}

/// @nodoc
abstract mixin class _$AnthropicChatRequestCopyWith<$Res> implements $AnthropicChatRequestCopyWith<$Res> {
  factory _$AnthropicChatRequestCopyWith(_AnthropicChatRequest value, $Res Function(_AnthropicChatRequest) _then) = __$AnthropicChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String model, List<AnthropicMessage> messages,@JsonKey(name: 'max_tokens') int maxTokens, double temperature, bool stream,@JsonKey(includeIfNull: false) String? system,@JsonKey(includeIfNull: false) List<Map<String, dynamic>>? tools
});




}
/// @nodoc
class __$AnthropicChatRequestCopyWithImpl<$Res>
    implements _$AnthropicChatRequestCopyWith<$Res> {
  __$AnthropicChatRequestCopyWithImpl(this._self, this._then);

  final _AnthropicChatRequest _self;
  final $Res Function(_AnthropicChatRequest) _then;

/// Create a copy of AnthropicChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? messages = null,Object? maxTokens = null,Object? temperature = null,Object? stream = null,Object? system = freezed,Object? tools = freezed,}) {
  return _then(_AnthropicChatRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AnthropicMessage>,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,tools: freezed == tools ? _self._tools : tools // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}


}


/// @nodoc
mixin _$AnthropicMessage {

 String get role; dynamic get content;
/// Create a copy of AnthropicMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnthropicMessageCopyWith<AnthropicMessage> get copyWith => _$AnthropicMessageCopyWithImpl<AnthropicMessage>(this as AnthropicMessage, _$identity);

  /// Serializes this AnthropicMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropicMessage&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.content, content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'AnthropicMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class $AnthropicMessageCopyWith<$Res>  {
  factory $AnthropicMessageCopyWith(AnthropicMessage value, $Res Function(AnthropicMessage) _then) = _$AnthropicMessageCopyWithImpl;
@useResult
$Res call({
 String role, dynamic content
});




}
/// @nodoc
class _$AnthropicMessageCopyWithImpl<$Res>
    implements $AnthropicMessageCopyWith<$Res> {
  _$AnthropicMessageCopyWithImpl(this._self, this._then);

  final AnthropicMessage _self;
  final $Res Function(AnthropicMessage) _then;

/// Create a copy of AnthropicMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? content = freezed,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AnthropicMessage].
extension AnthropicMessagePatterns on AnthropicMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnthropicMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnthropicMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnthropicMessage value)  $default,){
final _that = this;
switch (_that) {
case _AnthropicMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnthropicMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AnthropicMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  dynamic content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnthropicMessage() when $default != null:
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  dynamic content)  $default,) {final _that = this;
switch (_that) {
case _AnthropicMessage():
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  dynamic content)?  $default,) {final _that = this;
switch (_that) {
case _AnthropicMessage() when $default != null:
return $default(_that.role,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnthropicMessage implements AnthropicMessage {
  const _AnthropicMessage({required this.role, required this.content});
  factory _AnthropicMessage.fromJson(Map<String, dynamic> json) => _$AnthropicMessageFromJson(json);

@override final  String role;
@override final  dynamic content;

/// Create a copy of AnthropicMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnthropicMessageCopyWith<_AnthropicMessage> get copyWith => __$AnthropicMessageCopyWithImpl<_AnthropicMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnthropicMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnthropicMessage&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.content, content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'AnthropicMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class _$AnthropicMessageCopyWith<$Res> implements $AnthropicMessageCopyWith<$Res> {
  factory _$AnthropicMessageCopyWith(_AnthropicMessage value, $Res Function(_AnthropicMessage) _then) = __$AnthropicMessageCopyWithImpl;
@override @useResult
$Res call({
 String role, dynamic content
});




}
/// @nodoc
class __$AnthropicMessageCopyWithImpl<$Res>
    implements _$AnthropicMessageCopyWith<$Res> {
  __$AnthropicMessageCopyWithImpl(this._self, this._then);

  final _AnthropicMessage _self;
  final $Res Function(_AnthropicMessage) _then;

/// Create a copy of AnthropicMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? content = freezed,}) {
  return _then(_AnthropicMessage(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
