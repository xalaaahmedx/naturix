import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String userId;
  final String username;
  final String profileImageUrl;

  const UserProfile({
    Key? key,
    required this.userId,
    required this.username,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'userImage$userId',
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 50,
            ),
          ),
          SizedBox(height: 16),
          Text('Username: $username'),
          Text('User ID: $userId'),
          // Display other user details as needed
        ],
      ),
    );
  }
}
