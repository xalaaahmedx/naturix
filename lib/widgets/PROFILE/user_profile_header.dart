import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    Key? key,
    required this.userData,
    required this.bio,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
    required this.toggleFollow,
    required this.messageUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userRole = userData['role'] ?? ''; // Fetch user role

    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: const BoxDecoration(
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
          SizedBox(height: 5.sp),
          GestureDetector(
            onTap: () {
              // Implement the image change functionality if needed
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userData['profileImageUrl'] ??
                    'https://example.com/default-profile-image.jpg',
              ),
              radius: 50.sp,
            ),
          ),
          SizedBox(height: 5.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userData['username'] ?? '',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              if (userRole.isNotEmpty) ...[
                _getRoleIcon(userRole),
              ],
            ],
          ),
          SizedBox(height: 5.sp),
          Text(
            bio,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$postsCount',
                    style: TextStyle(
                      fontSize: 18.sp,
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
                      fontSize: 18.sp,
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
                      fontSize: 18.sp,
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
          SizedBox(height: 16.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: messageUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                    vertical: 10.sp,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail, size: 18.sp),
                    SizedBox(width: 8.sp),
                    Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.sp),
              ElevatedButton(
                onPressed: toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing
                      ? Colors.grey[200]
                      : Color.fromARGB(255, 1, 158, 140),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                    vertical: 10.sp,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isFollowing ? Icons.person_remove : Icons.person_add,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        fontSize: 14.sp,
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

  Widget _getRoleIcon(String role) {
    String assetPath = ''; // Initialize empty asset path

    switch (role.toLowerCase()) {
      case 'restaurant':
        assetPath = 'assets/images/restaurant (2).png';
        break;
      case 'organization':
        assetPath = 'assets/images/charity (1).png';
        break;
      case 'user':
        assetPath = 'assets/images/user (2).png';
        break;
      default:
        assetPath = 'assets/images/user (2).png';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Image.asset(
        assetPath,
        width: 30.sp,
        height: 30.sp,
      ),
    );
  }
}
