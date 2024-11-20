import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../data/api/api_service.dart';
import '../data/model/upload_response.dart';
import 'package:image/image.dart' as img;

class AddStoryProvider extends ChangeNotifier {
  ApiService apiService;

  AddStoryProvider({required this.apiService});

  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;

  String? imagePath;
  XFile? imageFile;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setIsUploading(bool value) {
    isUploading = value;
    notifyListeners();
  }

  Future<void> postStory(
    List<int> bytes,
    String fileName,
    String description, {
    double? lat,
    double? lon,
  }) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();
      uploadResponse = await apiService.uploadStory(
        bytes,
        fileName,
        description,
        lat: lat,
        lon: lon,
      );
      message = uploadResponse?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
