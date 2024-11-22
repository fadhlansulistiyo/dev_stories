import 'dart:io';
import 'package:dev_stories/screen/addstory/location_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../provider/add_story_provider.dart';
import '../../router/page_manager.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onPost;
  final Function(LatLng latLng) onChooseLocation;

  const AddStoryScreen({
    super.key,
    required this.onPost,
    required this.onChooseLocation,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  double? selectedLat;
  double? selectedLon;
  String locationButtonText = "Add Location";
  Color? locationButtonColor;
  String? _selectedLocationOption;

  @override
  void initState() {
    super.initState();
    _initiateLocation();
  }

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
              // Action Button section
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text("Current Location"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: _selectedLocationOption == "current"
                              ? Colors.green
                              : Theme.of(context).colorScheme.surface,
                        ),
                        backgroundColor: _selectedLocationOption == "current"
                            ? Colors.green.shade50
                            : null, // Default
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _chooseLocationFromMap(context),
                      icon: const Icon(Icons.map),
                      label: const Text("Choose from Map"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: _selectedLocationOption == "map"
                              ? Colors.green
                              : Theme.of(context).colorScheme.surface,
                        ),
                        backgroundColor: _selectedLocationOption == "map"
                            ? Colors.green.shade50
                            : null, // Default
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Upload button
              ElevatedButton(
                onPressed: isUploading ? null : () => _onUpload(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: isUploading
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  isUploading ? 'Uploading...' : 'Upload',
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

  Future<void> _getCurrentLocation() async {
    late ScaffoldMessengerState scaffoldMessengerState;

    if (context.mounted) {
      scaffoldMessengerState = ScaffoldMessenger.of(context);

      scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text("Choose Current Location. Please wait..."),
        ),
      );
    }

    final latLng = await _initiateLocation();

    if (latLng == null) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text("Failed to get data. Please try again."),
        ),
      );
      return;
    }

    final lat = latLng.latitude;
    final lon = latLng.longitude;

    setState(() {
      locationButtonText = "Using Current Location";
      locationButtonColor = Theme.of(context).colorScheme.secondary;
      selectedLat = lat;
      selectedLon = lon;
      _selectedLocationOption = "current";
    });
  }

  void _chooseLocationFromMap(BuildContext context) async {
    late ScaffoldMessengerState scaffoldMessengerState;
    final locationManager = context.read<LocationManager>();

    if (context.mounted) {
      scaffoldMessengerState = ScaffoldMessenger.of(context);

      scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text("Choose Location from Maps. Please wait..."),
        ),
      );
    }

    final latLng = await _initiateLocation();

    if (latLng == null) {
      if (context.mounted) {
        scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text("Failed to get data. Please try again."),
          ),
        );
      }
      return;
    }

    widget.onChooseLocation(LatLng(latLng.latitude, latLng.longitude));

    final result = await locationManager.waitForResult();

    setState(() {
      locationButtonText = "Location Chosen on Map";
      locationButtonColor = Theme.of(context).colorScheme.secondary;
      selectedLat = result.latitude;
      selectedLon = result.longitude;
      _selectedLocationOption = "map";
    });
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

    uploadProvider.setIsUploading(true);

    await Future.delayed(const Duration(seconds: 1));

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);
    await uploadProvider.postStory(newBytes, fileName, description,
        lat: selectedLat, lon: selectedLon);

    if (uploadProvider.uploadResponse != null) {
      _descriptionController.clear();
      uploadProvider.setImageFile(null);
      uploadProvider.setImagePath(null);

      pageManager.returnData("success");

      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text('Story successfully created')),
      );
      widget.onPost();
    }

    setState(() {
      uploadProvider.setIsUploading(false);
    });
  }

  Future<LatLng?> _initiateLocation() async {
    final Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        print("Location services are not enabled");
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return null;
      }
    }

    final locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    return latLng;
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
    super.dispose();
  }
}
