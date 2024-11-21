import 'package:dev_stories/data/model/story.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_story_response.g.dart';

@JsonSerializable()
class ListStoryResponse {
  bool error;
  String message;
  List<Story> listStory;

  ListStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoryResponse.fromJson(json) => _$ListStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryResponseToJson(this);
}

