import 'package:JsxposedX/features/home/domain/models/common_user.dart';
import 'package:JsxposedX/features/home/domain/models/post_category.dart';
import 'package:JsxposedX/features/home/domain/models/post_stats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail.freezed.dart';

@freezed
abstract class PostDetail with _$PostDetail {
  const PostDetail._();

  const factory PostDetail({
    required int id,
    required String title,
    required String description,
    required PostCategory postCategory,
    required String cover,
    required int publishTime,
    required CommonUser uploader,
    required PostStats postStats,
    required List<int> badges,
    required String content,
  }) = _PostDetail;
}
