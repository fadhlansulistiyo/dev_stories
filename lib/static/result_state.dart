import 'package:dev_stories/data/model/story.dart';

sealed class ResultState {}

class NoneState extends ResultState {}

class LoadingState extends ResultState {}

class ErrorState extends ResultState {
  final String error;

  ErrorState(this.error);
}

class LoadedState extends ResultState {
  final List<Story> data;

  LoadedState(this.data);
}
