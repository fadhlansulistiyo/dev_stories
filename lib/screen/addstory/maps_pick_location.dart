import 'package:dev_stories/screen/addstory/location_manager.dart';
import 'package:dev_stories/screen/addstory/placemark_story_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';

class MapsPickLocation extends StatefulWidget {
  final LatLng? latLng;
  final Function(LatLng latLng) onChoose;

  const MapsPickLocation({super.key, this.latLng, required this.onChoose});

  @override
  State<MapsPickLocation> createState() => _MapsPickLocationState();
}

class _MapsPickLocationState extends State<MapsPickLocation> {
  late LatLng storyLocation;
  LatLng? _selectedLatLng;
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    storyLocation = LatLng(widget.latLng?.latitude ?? -6.8957473,
        widget.latLng?.longitude ?? 107.6337669);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location'),
      ),
      body: Center(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(zoom: 18, target: storyLocation),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onMapCreated: (controller) async {
              final info = await geo.placemarkFromCoordinates(
                  storyLocation.latitude, storyLocation.longitude);
              final place = info[0];
              final street = place.street!;
              final address = '${place.subLocality}, '
                  '${place.locality}, '
                  '${place.postalCode}, '
                  '${place.country}';
              setState(() {
                placemark = place;
              });

              defineMarker(storyLocation, street, address);

              setState(() {
                mapController = controller;
              });
            },
            onTap: (LatLng latLng) => onTapGoogleMap(latLng),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () => onMyLocationButtonPress(),
            ),
          ),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: PlacemarkStoryWidget(
                placemark: placemark!,
                onChoose: () => _onChooseLocation(context),
              ),
            ),
        ],
      )),
    );
  }

  void _onChooseLocation(BuildContext context) async {
    if (_selectedLatLng != null) {
      widget.onChoose(_selectedLatLng!);

      final locationManager = context.read<LocationManager>();
      locationManager.returnData(_selectedLatLng!);
    }
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late LocationData locationData;

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
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

  void onTapGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
      _selectedLatLng = latLng;
    });
    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
