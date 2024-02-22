import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/screens/edit_profile.dart';
import 'package:naturix/widgets/wallposts.dart';
import 'package:naturix/widgets/widgetss/comment.dart';
import 'package:naturix/widgets/widgetss/text_box.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final userPostsCollection =
      FirebaseFirestore.instance.collection('user posts');
  final ImagePicker _imagePicker = ImagePicker();
  late File _selectedImage = File('');
  late int followersCount = 0;
  late int followingCount = 0;
  late int postsCount = 0;

  Future<int> fetchPostsCount(String userEmail) async {
    try {
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .where('UserEmail', isEqualTo: userEmail)
          .get();

      return postsSnapshot.size;
    } catch (e) {
      print('Error fetching posts count: $e');
      return 0;
    }
  }

  Future<void> fetchUserCounts(String userEmail) async {
    try {
      int followers = await fetchFollowersCount(userEmail);
      int following = await fetchFollowingCount(userEmail);
      int posts = await fetchPostsCount(userEmail);

      setState(() {
        followersCount = followers;
        followingCount = following;
        postsCount = posts;
      });
    } catch (e) {
      print('Error fetching user counts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      String userEmail = currentUser?.email ?? '';
      fetchUserCounts(userEmail);
    }
  }

  Future<void> fetchCounts(String userId, String userEmail) async {
    try {
      int followers = await fetchFollowersCount(userId);
      int following = await fetchFollowingCount(userId);
      int posts = await fetchPostsCount(userEmail);

      setState(() {
        followersCount = followers;
        followingCount = following;
        postsCount = posts;
      });
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  Future<List<Comments>> fetchComments(String postId) async {
    try {
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(postId)
          .collection('Comments')
          .get();

      return commentsSnapshot.docs.map((doc) {
        final commentData = doc.data();
        return Comments(
          userProfileImageUrl: commentData['UserProfileImageUrl'],
          text: commentData['CommentText'],
          user: commentData['CommentedBy'],
          time: formatData(commentData['CommentTime']),
          imageUrl: null,
        );
      }).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> _editField(Map<String, dynamic> fields) async {
    final updatedValues = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfile(fields: fields),
      ),
    );

    if (updatedValues != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .update(updatedValues);

        setState(() {
          // Update local state based on the updatedValues
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<int> fetchFollowersCount(String userId) async {
    try {
      final followersSnapshot = await FirebaseFirestore.instance
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      return followersSnapshot.size;
    } catch (e) {
      print('Error fetching followers count: $e');
      return 0;
    }
  }

  Future<int> fetchFollowingCount(String userId) async {
    try {
      final followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(userId)
          .collection('userFollowing')
          .get();

      return followingSnapshot.size;
    } catch (e) {
      print('Error fetching following count: $e');
      return 0;
    }
  }

  Future<void> _changeProfilePicture() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        String imageUrl = await uploadImageToFirebase(pickedFile.path);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .update({'profileImageUrl': imageUrl});

        setState(() {
          followersCount = followersCount;
          followingCount = followingCount;
          postsCount = postsCount;

          // Update local state based on the new image URL
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error changing profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error changing profile picture. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> uploadImageToFirebase(String filePath) async {
    try {
      File file = File(filePath);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      await storageReference.putFile(file);

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase: $e');
      throw Exception('Failed to upload image to Firebase Storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              _editField({
                'username': '',
                'bio': '',
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return FutureBuilder<QuerySnapshot>(
              future: userPostsCollection
                  .where('UserEmail', isEqualTo: currentUser?.email)
                  .get(),
              builder: (context, userPostsSnapshot) {
                if (userPostsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userPostsSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${userPostsSnapshot.error}'),
                  );
                } else {
                  final userPosts = userPostsSnapshot.data!.docs;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _changeProfilePicture,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 200,
                                      backgroundImage: userData[
                                                  'profileImageUrl'] !=
                                              null
                                          ? Image.network(
                                                  userData['profileImageUrl']!)
                                              .image
                                          : AssetImage('assets/images/bear.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              userData['username'] ?? '',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              userData['bio'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
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
                                      ),
                                    ),
                                    Text('Posts'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '$followersCount',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Followers'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '$followingCount',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Following'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Divider(),
                            for (final post in userPosts)
                              Column(
                                children: [
                                  WallPost(
                                    userProfileImageUrl:
                                        userData['profileImageUrl']
                                                as String? ??
                                            '',
                                    messages: post['Message'],
                                    user: post['UserEmail'],
                                    postId: post.id,
                                    likes:
                                        List<String>.from(post['Likes'] ?? []),
                                    time: formatData(post['TimeStamp']),
                                    imageUrl: (post.data() as Map<String,
                                            dynamic>)['ImageUrl'] as String? ??
                                        '',
                                    commentsFuture: fetchComments(post.id),
                                  ),
                                  Divider(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
      ),
    );
  }
}
