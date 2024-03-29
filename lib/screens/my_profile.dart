import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/screens/edit_profile.dart';

import 'package:naturix/widgets/PROFILE/profile_body.dart';
import 'package:naturix/widgets/PROFILE/profile_header_widget.dart';
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
  late Map<String, dynamic> userData = {};

  Future<void> fetchUserData(String userEmail) async {
    try {
      final userDoc = await userCollection.doc(userEmail).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      String userEmail = currentUser?.email ?? '';
      fetchUserCounts(userEmail);
      checkAndAddEmailField(userEmail);
      fetchUserData(userEmail);
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

  Future<void> checkAndAddEmailField(String userEmail) async {
    try {
      final userDoc = await userCollection.doc(userEmail).get();
      if (!userDoc.exists || !userDoc.data()!.containsKey('email')) {
        // Add the email field to the user document
        await userCollection.doc(userEmail).set({
          'email': userEmail,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error checking and adding email field: $e');
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    try {
      // Update the profile image URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error updating profile image URL: $e');
      throw Exception('Failed to update profile image URL');
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

        // Update the profile image URL in Firestore
        await updateProfileImage(imageUrl);

        // Update the local state based on the new image URL
        setState(() {
          // Assuming you want to update only the profileImageUrl
          followersCount = followersCount;
          followingCount = followingCount;
          postsCount = postsCount;
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error changing profile picture: $e');
      // Show an error message
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
        backgroundColor: Color.fromARGB(255, 1, 158, 140),
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
                      ProfileHeaderWidget(
                        userData: userData,
                        followersCount: followersCount,
                        followingCount: followingCount,
                        postsCount: postsCount,
                        onEditProfile: () {
                          _editField({
                            'username': '',
                            'bio': '',
                          });
                        },
                        onChangeProfilePicture: _changeProfilePicture,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ProfileBodyWidget(
                          userPosts: userPosts,
                          userData: userData,
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
