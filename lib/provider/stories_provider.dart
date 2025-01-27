import 'package:dev_stories/db/stories_repository.dart';
import 'package:dev_stories/static/detail_story_state.dart';
import 'package:dev_stories/static/result_state.dart';
import 'package:flutter/material.dart';
import '../data/model/story.dart';

class StoriesProvider extends ChangeNotifier {
  final StoriesRepository storiesRepository;

  StoriesProvider({required this.storiesRepository});

  ResultState _storiesState = NoneState();
  ResultState get storiesState => _storiesState;

  DetailStoryState _detailState = DetailNoneState();
  DetailStoryState get detailState => _detailState;

  List<Story> _loadedStories = [];
  List<Story> get loadedStories => _loadedStories;

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> getAllStories({bool reset = false}) async {
    try {
      if (reset) {
        _loadedStories = [];
        pageItems = 1;
        _storiesState = LoadingState();
        notifyListeners();
      }

      if (pageItems == 1) {
        _storiesState = LoadingState();
        notifyListeners();
      }

      final stories =
      await storiesRepository.getAllStories(pageItems!, sizeItems);

      if (stories.error) {
        _storiesState = ErrorState(stories.message);
      } else {
        if (pageItems == 1) {
          _loadedStories = List.from(stories.listStory);
        } else {
          _loadedStories = List.from(_loadedStories)..addAll(stories.listStory);
        }

        if (stories.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }

        _storiesState = LoadedState(_loadedStories);
        notifyListeners();
      }
    } on Exception catch (e) {
      _storiesState = ErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDetailStory(String id) async {
    try {
      _detailState = DetailLoadingState();
      notifyListeners();

      final detail = await storiesRepository.getDetailStory(id);

      if (detail.error) {
        _detailState = DetailErrorState(detail.message);
      } else {
        _detailState = DetailLoadedState(detail.story);
      }
    } on Exception catch (e) {
      _detailState = DetailErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
