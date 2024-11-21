import 'package:dev_stories/data/api/api_service.dart';
import '../data/model/detail_story_response.dart';
import '../data/model/list_story_response.dart';

class StoriesRepository {
  final ApiService apiService;

  StoriesRepository({required this.apiService});

  Future<ListStoryResponse> getAllStories(int? pageItems, int sizeItem) async {
    return await apiService.getAllStories(pageItems!, sizeItem);
  }

  Future<DetailStoryResponse> getDetailStory(String id) async {
    return await apiService.getDetailStory(id);
  }

}