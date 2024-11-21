import 'dart:io';
import 'package:dev_stories/screen/addstory/maps_pick_location.dart';
import 'package:dev_stories/screen/addstory/upload_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../provider/add_story_provider.dart';
import '../../provider/stories_provider.dart';
import '../../router/page_manager.dart';
import 'location_option.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onPost;

  const AddStoryScreen({super.key, required this.onPost});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  LatLng? _latLng;
  double? selectedLat;
  double? selectedLon;
  String locationButtonText = "Add Location";
  Color? locationButtonColor;

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
              // Location Button
              ElevatedButton.icon(
                onPressed: _onAddLocation,
                icon: const Icon(Icons.location_on),
                label: Text(locationButtonText),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                        color: locationButtonColor ??
                            Theme.of(context).colorScheme.surface)),
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

  void _onAddLocation() async {
    final result = await showDialog<LocationOption>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Location"),
          content: const Text(
              "Do you want to use your current location or choose from the map?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(LocationOption.current),
              child: const Text("Current Location"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(LocationOption.map),
              child: const Text("Choose from Map"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    if (result == LocationOption.current) {
      _getCurrentLocation();
    } else if (result == LocationOption.map) {
      _chooseLocationFromMap();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      locationButtonText = "Using Current Location";
      locationButtonColor = Theme.of(context).colorScheme.secondary;
      selectedLat = _latLng?.latitude;
      selectedLon = _latLng?.longitude;
    });
  }

  Future<void> _chooseLocationFromMap() async {
    final coordinates = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => MapsPickLocation(
          latLng: LatLng(_latLng!.latitude, _latLng!.longitude),
        ),
      ),
    );

    if (coordinates != null) {
      setState(() {
        locationButtonText = "Location Chosen on Map";
        locationButtonColor = Theme.of(context).colorScheme.secondary;
        selectedLat = coordinates.latitude;
        selectedLon = coordinates.longitude;
      });
    }
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UploadDialog(
          onComplete: () {
            widget.onPost();
          },
        );
      },
    );

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
    }

    setState(() {
      uploadProvider.setIsUploading(false);
    });
  }

  void _initiateLocation() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    _latLng = LatLng(locationData.latitude!, locationData.longitude!);
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
