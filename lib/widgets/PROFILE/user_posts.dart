import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/helper/helper_methods.dart';

import 'package:naturix/widgets/widgetss/comment.dart';

class UserPosts extends StatelessWidget {
  final List<DocumentSnapshot> posts;
  final Map<String, dynamic> userData;

  const UserPosts({super.key, 
    required this.posts,
    required this.userData,
  });

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index].data() as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          userData['profileImageUrl'] as String? ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        userData['username'] as String? ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post['Message'] as String? ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (post['ImageUrl'] != null)
                    Image.network(
                      post['ImageUrl'] as String? ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.favorite),
                      const SizedBox(width: 4),
                      Text(
                        '${List<String>.from(post['Likes'] ?? []).length}',
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment),
                      const SizedBox(width: 4),
                      FutureBuilder<List<Comments>>(
                        future: fetchComments(posts[index].id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading...');
                          }
                          if (snapshot.hasData) {
                            return Text('${snapshot.data!.length}');
                          }
                          return const Text('0');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatData(post['TimeStamp']),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
