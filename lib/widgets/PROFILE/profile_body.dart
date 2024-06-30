import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/posts/wallposts.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class ProfileBodyWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> userPosts;
  final Map<String, dynamic> userData;

  const ProfileBodyWidget({
    Key? key,
    required this.userPosts,
    required this.userData,
  }) : super(key: key);

  @override
  State<ProfileBodyWidget> createState() => _ProfileBodyWidgetState();
}

class _ProfileBodyWidgetState extends State<ProfileBodyWidget> {
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
    return Padding(
      padding: EdgeInsets.all(16.sp), // Use sizer method for padding
      child: Expanded(
        // Use Expanded widget here
        child: ListView.builder(
          itemCount: widget.userPosts.length,
          itemBuilder: (context, index) {
            final post = widget.userPosts[index].data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(
                  vertical: 8.sp), // Use sizer method for margin
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12.sp), // Use sizer method for border radius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.all(12.sp), // Use sizer method for padding
                    child: WallPost(
                      userProfileImageUrl:
                          widget.userData['profileImageUrl'] as String? ?? '',
                      messages: post['Message'],
                      user: post['UserEmail'],
                      postId: widget.userPosts[index].id,
                      likes: List<String>.from(post['Likes'] ?? []),
                      time: formatData(post['TimeStamp']),
                      imageUrl: post['ImageUrl'] as String? ?? '',
                      commentsFuture: fetchComments(widget.userPosts[index].id),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
