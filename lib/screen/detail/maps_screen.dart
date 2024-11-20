import 'package:dev_stories/screen/detail/placemark_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapsScreen extends StatefulWidget {
  final LatLng latLng;

  const MapsScreen({super.key, required this.latLng});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late final double lat;
  late final double long;
  late final LatLng storyLocation;
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();
    lat = widget.latLng.latitude;
    long = widget.latLng.longitude;
    storyLocation = LatLng(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Location'),
      ),
      body: Center(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(zoom: 15, target: storyLocation),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onMapCreated: (controller) async {
              await _buildStoryLocation(controller);
            },
          ),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: PlacemarkWidget(
                placemark: placemark!,
              ),
            ),
        ],
      )),
    );
  }

  Future<void> _buildStoryLocation(GoogleMapController controller) async {
    final info = await geo.placemarkFromCoordinates(
        storyLocation.latitude, storyLocation.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(storyLocation, street, address);

    setState(() {
      mapController = controller;
    });
  }

  void defineMarker(LatLng latLng, String? street, String? address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
