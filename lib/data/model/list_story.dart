// To parse this JSON data, do
//
//     final listStory = listStoryFromJson(jsonString);

import 'dart:convert';

ListStory listStoryFromJson(String str) => ListStory.fromJson(json.decode(str));

String listStoryToJson(ListStory data) => json.encode(data.toJson());

class ListStory {
  bool error;
  String message;
  List<ListStoryElement> listStory;

  ListStory({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStory.fromJson(Map<String, dynamic> json) => ListStory(
        error: json["error"],
        message: json["message"],
        listStory: List<ListStoryElement>.from(
            json["listStory"].map((x) => ListStoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}

class ListStoryElement {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  ListStoryElement({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory ListStoryElement.fromJson(Map<String, dynamic> json) =>
      ListStoryElement(
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
