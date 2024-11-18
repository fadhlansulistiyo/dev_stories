// To parse this JSON data, do
//
//     final detailStory = detailStoryFromJson(jsonString);

import 'dart:convert';

DetailStoryResult detailStoryFromJson(String str) =>
    DetailStoryResult.fromJson(json.decode(str));

String detailStoryToJson(DetailStoryResult data) => json.encode(data.toJson());

class DetailStoryResult {
  bool error;
  String message;
  DetailStory story;

  DetailStoryResult({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryResult.fromJson(Map<String, dynamic> json) =>
      DetailStoryResult(
        error: json["error"],
        message: json["message"],
        story: DetailStory.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}

class DetailStory {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  DetailStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory DetailStory.fromJson(Map<String, dynamic> json) => DetailStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
