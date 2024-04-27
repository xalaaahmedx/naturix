import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  String? imageUrl;

  CachedImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    // Check if imageUrl is not null and not empty
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: const Color.fromARGB(255, 1, 158, 140),
                ),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) => Container(
          color: Colors.amber,
        ),
      );
    } else {
      // Handle case where imageUrl is null or empty
      return Container(
        color: Colors.amber, // Provide a placeholder or default image
      );
    }
  }
}
