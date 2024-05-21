import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Import sizer package
import 'package:naturix/screens/followers.dart';
import 'package:naturix/screens/following_screen.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final Function()? onEditProfile;
  final Function()? onChangeProfilePicture;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    this.onEditProfile,
    this.onChangeProfilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp), // Use sizer method for padding
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
          GestureDetector(
            onTap: onChangeProfilePicture,
            child: Stack(
              children: [
                Container(
                  width: 100.sp, // Use sizer method for width
                  height: 100.sp, // Use sizer method for height
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4.sp, // Use sizer method for border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius:
                            2.sp, // Use sizer method for spread radius
                        blurRadius: 5.sp, // Use sizer method for blur radius
                        offset: Offset(0, 3.sp), // Use sizer method for offset
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 200.sp, // Use sizer method for radius
                    backgroundColor: Colors.white,
                    backgroundImage: userData['profileImageUrl'] != null
                        ? Image.network(userData['profileImageUrl']!).image
                        : AssetImage('assets/images/bear.png'),
                  ),
                ),
                Positioned(
                  bottom: 2.sp, // Use sizer method for position
                  right: 2.sp, // Use sizer method for position
                  child: Container(
                    padding:
                        EdgeInsets.all(4.sp), // Use sizer method for padding
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16.sp, // Use sizer method for icon size
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.sp), // Use sizer method for spacing
          Text(
            userData['username'] ?? '',
            style: TextStyle(
              fontSize: 24.sp, // Use sizer method for font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.sp), // Use sizer method for spacing
          Text(
            userData['bio'] ?? '',
            style: TextStyle(
              fontSize: 16.sp, // Use sizer method for font size
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.sp), // Use sizer method for spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$postsCount',
                    style: TextStyle(
                      fontSize: 18.sp, // Use sizer method for font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FollowersScreen(),
                      ),
                    ),
                    child: Text(
                      '$followersCount',
                      style: TextStyle(
                        fontSize: 18.sp, // Use sizer method for font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FollowingScreen(),
                      ),
                    ),
                    child: Text(
                      '$followingCount',
                      style: TextStyle(
                        fontSize: 18.sp, // Use sizer method for font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
