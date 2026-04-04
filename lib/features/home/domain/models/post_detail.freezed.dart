// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostDetail {

 int get id; String get title; String get description; PostCategory get postCategory; String get cover; int get publishTime; CommonUser get uploader; PostStats get postStats; List<int> get badges; String get content;
/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailCopyWith<PostDetail> get copyWith => _$PostDetailCopyWithImpl<PostDetail>(this as PostDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,postCategory,cover,publishTime,uploader,postStats,const DeepCollectionEquality().hash(badges),content);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, description: $description, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class $PostDetailCopyWith<$Res>  {
  factory $PostDetailCopyWith(PostDetail value, $Res Function(PostDetail) _then) = _$PostDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, PostCategory postCategory, String cover, int publishTime, CommonUser uploader, PostStats postStats, List<int> badges, String content
});


$PostCategoryCopyWith<$Res> get postCategory;$CommonUserCopyWith<$Res> get uploader;$PostStatsCopyWith<$Res> get postStats;

}
/// @nodoc
class _$PostDetailCopyWithImpl<$Res>
    implements $PostDetailCopyWith<$Res> {
  _$PostDetailCopyWithImpl(this._self, this._then);

  final PostDetail _self;
  final $Res Function(PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? badges = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategory,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUser,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStats,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryCopyWith<$Res> get postCategory {
  
  return $PostCategoryCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserCopyWith<$Res> get uploader {
  
  return $CommonUserCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsCopyWith<$Res> get postStats {
  
  return $PostStatsCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDetail].
extension PostDetailPatterns on PostDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDetail value)  $default,){
final _that = this;
switch (_that) {
case _PostDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  List<int> badges,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  List<int> badges,  String content)  $default,) {final _that = this;
switch (_that) {
case _PostDetail():
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  List<int> badges,  String content)?  $default,) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _PostDetail extends PostDetail {
  const _PostDetail({required this.id, required this.title, required this.description, required this.postCategory, required this.cover, required this.publishTime, required this.uploader, required this.postStats, required final  List<int> badges, required this.content}): _badges = badges,super._();
  

@override final  int id;
@override final  String title;
@override final  String description;
@override final  PostCategory postCategory;
@override final  String cover;
@override final  int publishTime;
@override final  CommonUser uploader;
@override final  PostStats postStats;
 final  List<int> _badges;
@override List<int> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override final  String content;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDetailCopyWith<_PostDetail> get copyWith => __$PostDetailCopyWithImpl<_PostDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,postCategory,cover,publishTime,uploader,postStats,const DeepCollectionEquality().hash(_badges),content);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, description: $description, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class _$PostDetailCopyWith<$Res> implements $PostDetailCopyWith<$Res> {
  factory _$PostDetailCopyWith(_PostDetail value, $Res Function(_PostDetail) _then) = __$PostDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, PostCategory postCategory, String cover, int publishTime, CommonUser uploader, PostStats postStats, List<int> badges, String content
});


@override $PostCategoryCopyWith<$Res> get postCategory;@override $CommonUserCopyWith<$Res> get uploader;@override $PostStatsCopyWith<$Res> get postStats;

}
/// @nodoc
class __$PostDetailCopyWithImpl<$Res>
    implements _$PostDetailCopyWith<$Res> {
  __$PostDetailCopyWithImpl(this._self, this._then);

  final _PostDetail _self;
  final $Res Function(_PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? badges = null,Object? content = null,}) {
  return _then(_PostDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategory,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUser,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStats,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryCopyWith<$Res> get postCategory {
  
  return $PostCategoryCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserCopyWith<$Res> get uploader {
  
  return $CommonUserCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsCopyWith<$Res> get postStats {
  
  return $PostStatsCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}
}

// dart format on
