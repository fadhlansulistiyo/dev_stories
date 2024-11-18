import 'package:dev_stories/data/model/detail_story.dart';

sealed class DetailStoryState {}

class DetailNoneState extends DetailStoryState {}

class DetailLoadingState extends DetailStoryState {}

class DetailErrorState extends DetailStoryState {
  final String error;

  DetailErrorState(this.error);
}

class DetailLoadedState extends DetailStoryState {
  final DetailStory data;

  DetailLoadedState(this.data);
}
