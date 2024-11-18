import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/add_story_provider.dart';
import '../../router/page_manager.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onPost;

  const AddStoryScreen({super.key, required this.onPost});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<AddStoryProvider>();
    final isUploading = watchProvider.isUploading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Story"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image preview section
              Expanded(
                flex: 4,
                child: watchProvider.imagePath == null
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      )
                    : _showImage(),
              ),
              const SizedBox(height: 16),
              // Description input field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Button section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _onGalleryView,
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _onCameraView,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Upload button
              ElevatedButton(
                onPressed: isUploading ? null : _onUpload,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: isUploading
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                ),
                child: isUploading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        "Upload",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onUpload() async {
    final uploadProvider = context.read<AddStoryProvider>();
    final pageManager = context.read<PageManager>();

    final imagePath = uploadProvider.imagePath;
    final imageFile = uploadProvider.imageFile;
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final description = _descriptionController.text.trim();

    if (imagePath == null || imageFile == null) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    if (description.isEmpty) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Description cannot be empty")),
      );
      return;
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);
    await uploadProvider.postStory(newBytes, fileName, description);

    if (uploadProvider.uploadResponse != null) {
      _descriptionController.clear();
      uploadProvider.setImageFile(null);
      uploadProvider.setImagePath(null);

      pageManager.returnData("success");
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );

    widget.onPost();
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;

    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    final uploadProvider = context.read<AddStoryProvider>();
    uploadProvider.setImageFile(null);
    uploadProvider.setImagePath(null);
    super.dispose();
  }
}
