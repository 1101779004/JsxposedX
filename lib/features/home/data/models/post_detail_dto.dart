import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/post_detail.dart';
import 'package:JsxposedX/features/home/data/models/common_user_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_category_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_stats_dto.dart';

part 'post_detail_dto.freezed.dart';
part 'post_detail_dto.g.dart';

@freezed
abstract class PostDetailDto with _$PostDetailDto {
  const PostDetailDto._();

  const factory PostDetailDto({
    @Default(0) int id,
    @Default("") String title,
    @Default("") String description,
    @Default(PostCategoryDto()) PostCategoryDto postCategory,
    @Default("") String cover,
    @Default(0) int publishTime,
    @Default(CommonUserDto()) CommonUserDto uploader,
    @Default(PostStatsDto()) PostStatsDto postStats,
    @Default([]) List<int> badges,
    @Default("") String content,
  }) = _PostDetailDto;

  factory PostDetailDto.fromJson(Map<String, dynamic> json) =>
      _$PostDetailDtoFromJson(json);

  PostDetail toEntity() {
    return PostDetail(
      id: id,
      title: title,
      description: description,
      postCategory: postCategory.toEntity(),
      cover: cover,
      publishTime: publishTime,
      uploader: uploader.toEntity(),
      postStats: postStats.toEntity(),
      badges: badges,
      content: content,
    );
  }
}
