import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/helper/helper_methods.dart';

import 'package:naturix/widgets/posts/wallposts.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class UserPosts extends StatelessWidget {
  final List<DocumentSnapshot> posts;
  final Map<String, dynamic> userData;

  const UserPosts({
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
            margin: EdgeInsets.all(8),
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
                      SizedBox(width: 8),
                      Text(
                        userData['username'] as String? ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    post['Message'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (post['ImageUrl'] != null)
                    Image.network(
                      post['ImageUrl'] as String? ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 4),
                      Text(
                        '${List<String>.from(post['Likes'] ?? []).length}',
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.comment),
                      SizedBox(width: 4),
                      FutureBuilder<List<Comments>>(
                        future: fetchComments(posts[index].id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          if (snapshot.hasData) {
                            return Text('${snapshot.data!.length}');
                          }
                          return Text('0');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatData(post['TimeStamp']),
                    style: TextStyle(
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
