import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naturix/widgets/widgetss/comment.dart';
import 'package:naturix/widgets/widgetss/comment_button.dart';
import 'package:naturix/widgets/widgetss/delete_button.dart';
import 'package:naturix/widgets/widgetss/like_button.dart';
import 'package:naturix/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  const WallPost({
    Key? key,
    required this.messages,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    required this.imageUrl,
  }) : super(key: key);

  final String messages;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  final String imageUrl;
  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool showComments = false; // Track whether to show comments or not
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance
                  .collection('user posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('user posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection('user posts')
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print('Post Deleted'))
                  .catchError(
                      (error) => print('Failed to delete post: $error'));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('user posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String comment) {
    FirebaseFirestore.instance
        .collection('user posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": comment,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Enter your comment...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addComment(commentController.text);
              commentController.clear();
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.messages,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.imageUrl.isNotEmpty) // Check if imageUrl is not empty
            Container(
              height: 200, // Set the desired height for the image
              child: Image.network(
                widget.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(width: 8),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  CommentButton(onTap: showCommentsDialog),
                  const SizedBox(width: 8),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user posts')
                        .doc(widget.postId)
                        .collection('Comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          '0',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        );
                      }
                      return Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showComments = !showComments;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  showComments ? 'Hide Comments' : 'Show Comments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          // Display comments if showComments is true
          if (showComments)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .orderBy('CommentTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Widget> commentWidgets =
                    snapshot.data!.docs.map<Widget>((doc) {
                  final commentData = doc.data();
                  return Comments(
                    text: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    time: formatData(commentData['CommentTime']),
                    imageUrl: null,
                  );
                }).toList();

                return Column(
                  children: commentWidgets,
                );
              },
            ),
        ],
      ),
    );
  }
}
