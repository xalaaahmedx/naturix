import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String userProfileImageUrl;
  final String text;
  final String user;
  final String time;
  final String? imageUrl;
  final String? username; // Add this line

  const Comments({super.key, 
    required this.userProfileImageUrl,
    required this.text,
    required this.user,
    required this.time,
    required this.imageUrl,
    this.username, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userProfileImageUrl),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(
              username ??
                  user, // Use username if available, otherwise use user email
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        if (imageUrl != null && imageUrl!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
