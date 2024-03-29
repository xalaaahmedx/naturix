import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String bio;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final VoidCallback toggleFollow;
  final VoidCallback messageUser;

  const UserProfileHeader({
    required this.userData,
    required this.bio,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
    required this.toggleFollow,
    required this.messageUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 1, 158, 140),
            Color.fromARGB(255, 0, 109, 97),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              // Implement the image change functionality if needed
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userData['profileImageUrl'] ??
                    'https://example.com/default-profile-image.jpg',
              ),
              radius: 50,
            ),
          ),
          SizedBox(height: 16),
          Text(
            userData['username'] ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            bio,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$postsCount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$followersCount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$followingCount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: messageUser,
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: toggleFollow,
                style: ElevatedButton.styleFrom(
                  primary: isFollowing
                      ? Colors.grey[200]
                      : Color.fromARGB(255, 1, 158, 140),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Row(
                  children: [
                    Icon(
                        isFollowing
                            ? Icons.person_remove
                            : Icons.person_add,
                        size: 24),
                    SizedBox(width: 8),
                    Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
