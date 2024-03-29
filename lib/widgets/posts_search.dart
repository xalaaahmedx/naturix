import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/screens/chat/chatpage.dart';
import 'package:naturix/widgets/posts/wallposts.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class WallPostSearch extends StatelessWidget {
  final String postId;
  final Future<List<Comments>> Function(String) fetchComments;

  const WallPostSearch({
    Key? key,
    required this.postId,
    required this.fetchComments, required userProfileImageUrl, required messages, required user, required List<String> likes, required String time, required imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('user posts').doc(postId).get(),
      builder: (context, postSnapshot) {
        if (!postSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final post = postSnapshot.data!.data() as Map<String, dynamic>;

        return _buildPostDetails(context, post);
      },
    );
  }

  Widget _buildPostDetails(BuildContext context, Map<String, dynamic> post) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(post['UserEmail'])
          .get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = userSnapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                WallPost(
                  userProfileImageUrl: user['profileImageUrl'] ?? '',
                  messages: post['Message'],
                  user: post['UserEmail'],
                  postId: postId,
                  likes: List<String>.from(post['Likes'] ?? []),
                  time: formatData(post['TimeStamp']),
                  imageUrl: post['ImageUrl'] ?? '',
                  commentsFuture: fetchComments(postId),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
