import 'package:dev_stories/data/api/api_service.dart';
import 'package:dev_stories/data/model/detail_story.dart';

import '../data/model/list_story.dart';

class StoriesRepository {
  final ApiService apiService;

  StoriesRepository({required this.apiService});

  Future<ListStory> getAllStories() async {
    return await apiService.getAllStories();
  }

  Future<DetailStoryResult> getDetailStory(String id) async {
    return await apiService.getDetailStory(id);
  }

  /*
  * TODO: add story API call
  */
}