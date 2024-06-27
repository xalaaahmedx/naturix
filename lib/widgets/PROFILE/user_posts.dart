import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/widgetss/comment.dart';
import 'package:sizer/sizer.dart'; // Import sizer

class UserPosts extends StatelessWidget {
  final List<DocumentSnapshot> posts;
  final Map<String, dynamic> userData;

  const UserPosts({
    Key? key,
    required this.posts,
    required this.userData,
  }) : super(key: key);

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
            margin: EdgeInsets.all(8.sp),
            elevation: 2.sp,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundImage: NetworkImage(
                          userData['profileImageUrl'] as String? ?? '',
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      Text(
                        userData['username'] as String? ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Text(
                    post['Message'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 8.sp),
                  if (post['ImageUrl'] != null)
                    Image.network(
                      post['ImageUrl'] as String? ?? '',
                      height: 200.sp,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 4.sp),
                      Text(
                        '${List<String>.from(post['Likes'] ?? []).length}',
                      ),
                      SizedBox(width: 16.sp),
                      Icon(Icons.comment),
                      SizedBox(width: 4.sp),
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
                  SizedBox(height: 8.sp),
                  Text(
                    formatData(post['TimeStamp']),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
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
