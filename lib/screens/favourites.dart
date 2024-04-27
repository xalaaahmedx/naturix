import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/widgets/posts/wallposts.dart'; // Import WallPost widget
import 'package:naturix/widgets/widgetss/comment.dart';
import 'package:naturix/helper/helper_methods.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

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
          userProfileImageUrl:
              commentData['UserProfileImageUrl'] as String? ?? '',
          text: commentData['CommentText'] as String? ?? '',
          user: commentData['CommentedBy'] as String? ?? '',
          time: formatData(commentData['CommentTime']),
          imageUrl: null,
        );
      }).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<String> getUserProfileImageUrl(String userEmail) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      if (userDoc.exists) {
        return userDoc['profileImageUrl'] ?? '';
      } else {
        return ''; // Return empty string if user document doesn't exist
      }
    } catch (e) {
      print('Error fetching user profile image URL: $e');
      return ''; // Return empty string on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user posts')
            .where('Likes', arrayContains: currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorite posts'));
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final imageUrl = post['ImageUrl'] as String? ?? '';

                  if (post['UserEmail'] == currentUser.email) {
                    return Container(); // Skip rendering this post
                  }

                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(post['UserEmail'])
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          !userSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            // Modernizing the circular progress indicator
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 1, 158, 140),
                            ),
                          ),
                        );
                      }

                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;

                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user posts')
                            .doc(snapshot.data!.docs[index].id)
                            .collection('Comments')
                            .orderBy('CommentTime', descending: true)
                            .get(),
                        builder: (context, commentSnapshot) {
                          if (commentSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !commentSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                // Modernizing the circular progress indicator
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 1, 158, 140),
                                ),
                              ),
                            );
                          }

                          final comments =
                              commentSnapshot.data!.docs.map<Comments>((doc) {
                            final commentData =
                                doc.data();
                            return Comments(
                              userProfileImageUrl:
                                  userData['profileImageUrl'] as String? ?? '',
                              text: commentData['CommentText'],
                              user: commentData['CommentedBy'],
                              time: formatData(commentData['CommentTime']),
                              imageUrl: null,
                            );
                          }).toList();

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  WallPost(
                                    userProfileImageUrl:
                                        userData['profileImageUrl']
                                                as String? ??
                                            '',
                                    messages: post['Message'],
                                    user: post['UserEmail'],
                                    postId: snapshot.data!.docs[index].id ?? '',
                                    likes:
                                        List<String>.from(post['Likes'] ?? []),
                                    time: formatData(post['TimeStamp']),
                                    imageUrl: imageUrl,
                                    commentsFuture: fetchComments(
                                        snapshot.data!.docs[index].id ?? ''),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
          );
        },
      ),
    );
  }
}
