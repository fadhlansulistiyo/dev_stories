import 'package:dev_stories/data/api/api_service.dart';
import 'package:dev_stories/data/model/detail_story.dart';
import '../data/model/list_story.dart';

class StoriesRepository {
  final ApiService apiService;

  StoriesRepository({required this.apiService});

  Future<ListStory> getAllStories(int? pageItems, int sizeItem) async {
    return await apiService.getAllStories(pageItems!, sizeItem);
  }

  Future<DetailStoryResult> getDetailStory(String id) async {
    return await apiService.getDetailStory(id);
  }

}