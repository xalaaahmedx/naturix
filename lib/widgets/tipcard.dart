import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String fontFamily;
  final ImageProvider<Object>? image;

  const TipCard({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
    required this.fontFamily,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start, // Start higher
        children: [
          if (image != null)
            Container(
              height: isSmallScreen ? screenSize.height * 0.5 : 450,
              width: isSmallScreen ? screenSize.width * 1 : 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'anekMalayalam'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'anekMalayalam',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
