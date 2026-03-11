// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_action_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiChatActionState {

 List<AiMessage> get messages;// 当前显示的（分页后）
 List<AiMessage> get allMessages;// 完整的历史记录
 List<AiSession> get sessions; bool get isStreaming; String? get error; String? get currentSessionId;// APK分析上下文
 String? get systemPrompt; String? get apkSessionId; List<String> get dexPaths;
/// Create a copy of AiChatActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatActionStateCopyWith<AiChatActionState> get copyWith => _$AiChatActionStateCopyWithImpl<AiChatActionState>(this as AiChatActionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatActionState&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.allMessages, allMessages)&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.error, error) || other.error == error)&&(identical(other.currentSessionId, currentSessionId) || other.currentSessionId == currentSessionId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.apkSessionId, apkSessionId) || other.apkSessionId == apkSessionId)&&const DeepCollectionEquality().equals(other.dexPaths, dexPaths));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(allMessages),const DeepCollectionEquality().hash(sessions),isStreaming,error,currentSessionId,systemPrompt,apkSessionId,const DeepCollectionEquality().hash(dexPaths));

@override
String toString() {
  return 'AiChatActionState(messages: $messages, allMessages: $allMessages, sessions: $sessions, isStreaming: $isStreaming, error: $error, currentSessionId: $currentSessionId, systemPrompt: $systemPrompt, apkSessionId: $apkSessionId, dexPaths: $dexPaths)';
}


}

/// @nodoc
abstract mixin class $AiChatActionStateCopyWith<$Res>  {
  factory $AiChatActionStateCopyWith(AiChatActionState value, $Res Function(AiChatActionState) _then) = _$AiChatActionStateCopyWithImpl;
@useResult
$Res call({
 List<AiMessage> messages, List<AiMessage> allMessages, List<AiSession> sessions, bool isStreaming, String? error, String? currentSessionId, String? systemPrompt, String? apkSessionId, List<String> dexPaths
});




}
/// @nodoc
class _$AiChatActionStateCopyWithImpl<$Res>
    implements $AiChatActionStateCopyWith<$Res> {
  _$AiChatActionStateCopyWithImpl(this._self, this._then);

  final AiChatActionState _self;
  final $Res Function(AiChatActionState) _then;

/// Create a copy of AiChatActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? allMessages = null,Object? sessions = null,Object? isStreaming = null,Object? error = freezed,Object? currentSessionId = freezed,Object? systemPrompt = freezed,Object? apkSessionId = freezed,Object? dexPaths = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,allMessages: null == allMessages ? _self.allMessages : allMessages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AiSession>,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,currentSessionId: freezed == currentSessionId ? _self.currentSessionId : currentSessionId // ignore: cast_nullable_to_non_nullable
as String?,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,apkSessionId: freezed == apkSessionId ? _self.apkSessionId : apkSessionId // ignore: cast_nullable_to_non_nullable
as String?,dexPaths: null == dexPaths ? _self.dexPaths : dexPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatActionState].
extension AiChatActionStatePatterns on AiChatActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatActionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatActionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatActionState value)  $default,){
final _that = this;
switch (_that) {
case _AiChatActionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatActionState value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatActionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiMessage> messages,  List<AiMessage> allMessages,  List<AiSession> sessions,  bool isStreaming,  String? error,  String? currentSessionId,  String? systemPrompt,  String? apkSessionId,  List<String> dexPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatActionState() when $default != null:
return $default(_that.messages,_that.allMessages,_that.sessions,_that.isStreaming,_that.error,_that.currentSessionId,_that.systemPrompt,_that.apkSessionId,_that.dexPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiMessage> messages,  List<AiMessage> allMessages,  List<AiSession> sessions,  bool isStreaming,  String? error,  String? currentSessionId,  String? systemPrompt,  String? apkSessionId,  List<String> dexPaths)  $default,) {final _that = this;
switch (_that) {
case _AiChatActionState():
return $default(_that.messages,_that.allMessages,_that.sessions,_that.isStreaming,_that.error,_that.currentSessionId,_that.systemPrompt,_that.apkSessionId,_that.dexPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiMessage> messages,  List<AiMessage> allMessages,  List<AiSession> sessions,  bool isStreaming,  String? error,  String? currentSessionId,  String? systemPrompt,  String? apkSessionId,  List<String> dexPaths)?  $default,) {final _that = this;
switch (_that) {
case _AiChatActionState() when $default != null:
return $default(_that.messages,_that.allMessages,_that.sessions,_that.isStreaming,_that.error,_that.currentSessionId,_that.systemPrompt,_that.apkSessionId,_that.dexPaths);case _:
  return null;

}
}

}

/// @nodoc


class _AiChatActionState extends AiChatActionState {
  const _AiChatActionState({final  List<AiMessage> messages = const [], final  List<AiMessage> allMessages = const [], final  List<AiSession> sessions = const [], this.isStreaming = false, this.error = null, this.currentSessionId = null, this.systemPrompt = null, this.apkSessionId = null, final  List<String> dexPaths = const []}): _messages = messages,_allMessages = allMessages,_sessions = sessions,_dexPaths = dexPaths,super._();
  

 final  List<AiMessage> _messages;
@override@JsonKey() List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

// 当前显示的（分页后）
 final  List<AiMessage> _allMessages;
// 当前显示的（分页后）
@override@JsonKey() List<AiMessage> get allMessages {
  if (_allMessages is EqualUnmodifiableListView) return _allMessages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allMessages);
}

// 完整的历史记录
 final  List<AiSession> _sessions;
// 完整的历史记录
@override@JsonKey() List<AiSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override@JsonKey() final  bool isStreaming;
@override@JsonKey() final  String? error;
@override@JsonKey() final  String? currentSessionId;
// APK分析上下文
@override@JsonKey() final  String? systemPrompt;
@override@JsonKey() final  String? apkSessionId;
 final  List<String> _dexPaths;
@override@JsonKey() List<String> get dexPaths {
  if (_dexPaths is EqualUnmodifiableListView) return _dexPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dexPaths);
}


/// Create a copy of AiChatActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatActionStateCopyWith<_AiChatActionState> get copyWith => __$AiChatActionStateCopyWithImpl<_AiChatActionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatActionState&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._allMessages, _allMessages)&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.error, error) || other.error == error)&&(identical(other.currentSessionId, currentSessionId) || other.currentSessionId == currentSessionId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.apkSessionId, apkSessionId) || other.apkSessionId == apkSessionId)&&const DeepCollectionEquality().equals(other._dexPaths, _dexPaths));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_allMessages),const DeepCollectionEquality().hash(_sessions),isStreaming,error,currentSessionId,systemPrompt,apkSessionId,const DeepCollectionEquality().hash(_dexPaths));

@override
String toString() {
  return 'AiChatActionState(messages: $messages, allMessages: $allMessages, sessions: $sessions, isStreaming: $isStreaming, error: $error, currentSessionId: $currentSessionId, systemPrompt: $systemPrompt, apkSessionId: $apkSessionId, dexPaths: $dexPaths)';
}


}

/// @nodoc
abstract mixin class _$AiChatActionStateCopyWith<$Res> implements $AiChatActionStateCopyWith<$Res> {
  factory _$AiChatActionStateCopyWith(_AiChatActionState value, $Res Function(_AiChatActionState) _then) = __$AiChatActionStateCopyWithImpl;
@override @useResult
$Res call({
 List<AiMessage> messages, List<AiMessage> allMessages, List<AiSession> sessions, bool isStreaming, String? error, String? currentSessionId, String? systemPrompt, String? apkSessionId, List<String> dexPaths
});




}
/// @nodoc
class __$AiChatActionStateCopyWithImpl<$Res>
    implements _$AiChatActionStateCopyWith<$Res> {
  __$AiChatActionStateCopyWithImpl(this._self, this._then);

  final _AiChatActionState _self;
  final $Res Function(_AiChatActionState) _then;

/// Create a copy of AiChatActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? allMessages = null,Object? sessions = null,Object? isStreaming = null,Object? error = freezed,Object? currentSessionId = freezed,Object? systemPrompt = freezed,Object? apkSessionId = freezed,Object? dexPaths = null,}) {
  return _then(_AiChatActionState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,allMessages: null == allMessages ? _self._allMessages : allMessages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AiSession>,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,currentSessionId: freezed == currentSessionId ? _self.currentSessionId : currentSessionId // ignore: cast_nullable_to_non_nullable
as String?,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,apkSessionId: freezed == apkSessionId ? _self.apkSessionId : apkSessionId // ignore: cast_nullable_to_non_nullable
as String?,dexPaths: null == dexPaths ? _self._dexPaths : dexPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
