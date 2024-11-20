import 'package:dev_stories/data/model/detail_story.dart';
import 'package:dev_stories/provider/stories_provider.dart';
import 'package:dev_stories/screen/detail/maps_screen.dart';
import 'package:dev_stories/screen/detail/story_image_widget.dart';
import 'package:dev_stories/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../static/detail_story_state.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final Function(double lat, double lon) toStoryLocation;

  const DetailScreen(
      {super.key, required this.id, required this.toStoryLocation});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoriesProvider>().getDetailStory(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<StoriesProvider>(
      builder: (context, value, child) {
        switch (value.detailState) {
          case DetailLoadingState():
            return const Center(child: CircularProgressIndicator());
          case DetailLoadedState(data: var storyDetail):
            return _buildDetail(storyDetail);
          case DetailErrorState(error: var message):
            return Center(child: _buildError(message, value));
          default:
            return const SizedBox();
        }
      },
    );
  }

  SingleChildScrollView _buildDetail(DetailStory story) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: StoryImage(photoUrl: story.photoUrl),
          ),
          const SizedBox(height: 16),
          Text(
            story.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Created At: ${formatWithTimeZone(story.createdAt)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            story.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (story.lat != null && story.lon != null)
            _buildLocationContainer(story),
        ],
      ),
    );
  }

  Container _buildLocationContainer(DetailStory story) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Google Map
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(story.lat!, story.lon!),
                  zoom: 10,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('storyLocation'),
                    position: LatLng(story.lat!, story.lon!),
                    infoWindow: const InfoWindow(
                      title: 'Story Location',
                    ),
                  ),
                },
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              if (story.lat != null && story.lon != null) {
                widget.toStoryLocation(story.lat!, story.lon!);
              }
              return;
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              "View Detail Story Location",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, StoriesProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.getDetailStory(widget.id),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
