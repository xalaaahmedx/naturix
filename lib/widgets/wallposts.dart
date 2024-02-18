import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    required this.commentsFuture,
  }) : super(key: key);

  final String messages;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  final String imageUrl;
  final Future<List<Comments>> commentsFuture;

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
      "CommentTime": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comments>>(
      future: widget.commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Comments> comments = snapshot.data ?? [];
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          // Display user avatar or profile picture
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget
                                  .imageUrl, // Use the profileImageUrl field from the post
                            ),
                          ),
                          const SizedBox(width: 8),
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
              if (widget.imageUrl.isNotEmpty)
                Container(
                  height: 200,
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
                      const SizedBox(width: 16),
                      CommentButton(
                        onTap: () {
                          setState(() {
                            showComments = !showComments;
                          });
                        },
                      ),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                ],
              ),
              // Display comments if showComments is true
              if (showComments) ...[
                _buildCommentInputField(),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user posts')
                      .doc(widget.postId)
                      .collection('Comments')
                      .orderBy('CommentTime', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<Widget> commentWidgets =
                        snapshot.data!.docs.map<Widget>((doc) {
                      final commentData = doc.data() as Map<String, dynamic>;
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
            ],
          );
        }
      },
    );
  }

  Widget _buildCommentItem(Comments comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display user avatar or profile picture
          CircleAvatar(
            // You can replace this with the user's profile picture
            child: Text(comment.user[0].toUpperCase()),
          ),
          const SizedBox(width: 8),
          // Display comment details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(comment.text),
                const SizedBox(height: 8),
                Text(
                  comment.time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Add an avatar or profile picture for the current user
          CircleAvatar(
            // You can replace this with the current user's profile picture
            child: Text(currentUser!.email![0].toUpperCase()),
          ),
          const SizedBox(width: 8),
          // Add a text input field for entering new comments
          Expanded(
            child: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          // Add a send button to post the comment
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                addComment(commentController.text);
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
