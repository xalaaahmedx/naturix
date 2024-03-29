import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/screens/chat/chatpage.dart';
import 'package:naturix/screens/user_profile_screen.dart';
import 'package:naturix/widgets/posts/edit_post.dart';
import 'package:naturix/widgets/widgetss/comment.dart';
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
    required this.userProfileImageUrl,
  }) : super(key: key);

  final String messages;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  final String imageUrl;
  final Future<List<Comments>> commentsFuture;
  final String userProfileImageUrl;

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool showComments = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void deletePost() async {
    if (widget.user == currentUser.email) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You can only delete your own posts."),
        ),
      );
    }
  }

  void addToFavorites() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final postRef = FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId);

      // Fetch the post document
      DocumentSnapshot postSnapshot = await postRef.get();

      // Get the current list of likes
      List<dynamic> likes = List.from(postSnapshot['Likes']);

      // Check if the current user already liked the post
      if (!likes.contains(currentUser.email)) {
        // Add the current user to the list of likes
        likes.add(currentUser.email);

        // Update the list of likes in Firestore
        await postRef.update({'Likes': likes});

        // Show a confirmation message or handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      } else {
        // Show a message indicating that the post is already in favorites
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post already in favorites')),
        );
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      // Show an error message or handle the error
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              useremail: widget.user,
                              currentUserEmail: currentUser.email!,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.userProfileImageUrl,
                        ),
                        radius: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.user)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('Loading...');
                              }

                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final username = userData['username'] ?? '';

                              return Text(
                                username,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                        PopupMenuItem(
                          child: Text('Update'),
                          value: 'update',
                        ),
                        PopupMenuItem(
                          child: Text('Add to Favorites'),
                          value: 'favorites',
                        ),
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'delete':
                            deletePost();
                            break;
                          case 'update':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPostScreen(postId: widget.postId),
                              ),
                            );
                            break;
                          case 'favorites':
                            addToFavorites();
                            break;
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.messages,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              if (widget.imageUrl.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (widget.user != currentUser.email)
                          GestureDetector(
                            onTap: () async {
                              try {
                                // Fetch the user document from Firestore
                                DocumentSnapshot userDocument =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.user)
                                        .get();

                                // Extract data from the user document
                                final data =
                                    userDocument.data() as Map<String, dynamic>;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      userEmail: data['email'],
                                      recieverUserId: data['email'],
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Error fetching user data: $e');
                              }
                            },
                            child: Image.asset(
                              'assets/icons/message.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showComments = !showComments;
                            });
                          },
                          child: Image.asset(
                            'assets/icons/comments.png',
                            width: 30,
                            height: 30,
                          ),
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
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              );
                            }
                            return Text(
                              snapshot.data!.docs.length.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                        user: commentData['CommentedBy'],
                        userProfileImageUrl: widget.userProfileImageUrl,
                        text: commentData['CommentText'],
                        time: formatData(commentData['CommentTime']),
                        imageUrl: null,
                        username: commentData['username'], // Add this line
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

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              currentUser.photoURL ?? '',
            ),
            radius: 24,
          ),
          const SizedBox(width: 8),
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
          IconButton(
            icon: Icon(Icons.send, color: Color.fromARGB(255, 1, 158, 140)),
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
