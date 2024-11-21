import 'package:freezed_annotation/freezed_annotation.dart';
import 'detail_story.dart';

part 'detail_story_response.g.dart';

@JsonSerializable()
class DetailStoryResponse {
  bool error;
  String message;
  DetailStory story;

  DetailStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryResponse.fromJson(json) => _$DetailStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryResponseToJson(this);
}
