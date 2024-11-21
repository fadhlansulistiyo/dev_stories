import 'package:dev_stories/data/model/story.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_story_response.freezed.dart';
part 'list_story_response.g.dart';

@freezed
class ListStoryResponse with _$ListStoryResponse {
  const factory ListStoryResponse({
    required bool error,
    required String message,
    required List<Story> listStory,
  }) = _ListStoryResponse;

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ListStoryResponseFromJson(json);
}