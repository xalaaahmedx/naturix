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

// Example implementation for fetching following count
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

  @override
  void initState() {
    super.initState();
    // Ensure currentUser and its properties are not null
    if (currentUser != null) {
      // Fetch initial counts
      String userId = currentUser?.uid ?? '';
      fetchCounts(userId, currentUser?.email ?? '');
    }
  }

  Future<void> fetchCounts(String userId, String userEmail) async {
    followersCount = await fetchFollowersCount(userId);
    followingCount = await fetchFollowingCount(userId);
    postsCount = await fetchPostsCount(userEmail);

    // Update the state to trigger a rebuild
    setState(() {
      followersCount = followersCount;
      followingCount = followingCount;
      postsCount = postsCount;
    });
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

  Future<void> _pickImageFromGallery() async {
    final imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _selectedImage = File(imageFile.path);
      });

      // Upload the image to Firestore storage
      await _uploadImageToStorage();
    }
  }

  Future<void> _uploadImageToStorage() async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${currentUser?.uid}.jpg');

      await storageReference.putFile(_selectedImage);
      final String imageUrl = await storageReference.getDownloadURL();

      // Update the user's profile image URL in Firestore
      await userCollection
          .doc(currentUser?.email)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error uploading image to storage: $e');
    }
  }

  Future<void> _editField(Map<String, String> fields) async {
    dynamic newValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfile(fields: fields),
      ),
    );

    if (newValue != null && newValue.isNotEmpty) {
      fields.forEach((field, initialValue) async {
        if (field.toLowerCase() == 'image') {
          await _uploadImageToStorage();
        } else {
          await userCollection
              .doc(currentUser?.email)
              .update({field: newValue[field]});
        }
      });
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
              // Example: Edit the username
              _editField({
                'username': 'Current Username',
                'bio': 'Current Bio',
                'image': 'Current Image',
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
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userData['profileImageUrl'] ??
                                    'https://example.com/placeholder.jpg',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              userData['username'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                SizedBox(width: 24),
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
                                SizedBox(width: 24),
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
                            ListTile(),
                            MyTextBox(
                              text: userData['bio'] ?? '',
                              sectionName: 'Bio',
                              onTap: () {
                                _editField({
                                  'username': 'Current Username',
                                  'bio': 'Current Bio',
                                  'image': 'Current Image',
                                });
                              },
                            ),
                            Divider(),
                            for (final post in userPosts)
                              Column(
                                children: [
                                  WallPost(
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
