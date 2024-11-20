import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoryImage extends StatelessWidget {
  final String photoUrl;

  const StoryImage({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(photoUrl), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey.shade300,
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, size: 48),
            ),
          );
        } else {
          return Image.network(
            photoUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 48),
                ),
              );
            },
          );
        }
      },
    );
  }
}
