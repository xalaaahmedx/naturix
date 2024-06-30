import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:naturix/screens/chat/chatpage.dart';
import 'package:naturix/screens/user_profile_screen.dart';
import 'package:naturix/widgets/posts/edit_post.dart';

import 'package:naturix/widgets/widgetss/comment.dart'; // Fix this import
import 'package:naturix/helper/helper_methods.dart';
import 'package:sizer/sizer.dart';

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
  String userRole = '';

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user)
          .get();
      if (userDoc.exists) {
        setState(() {
          userRole = userDoc['role']; // Set user role from Firestore
        });
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  void deletePost() async {
    if (widget.user == currentUser.email) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Post'),
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


                setState(() {
                  showComments = false;
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can only delete your own posts."),
        ),
      );
    }
  }

  void toggleFavorite() async {
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
      if (likes.contains(currentUser.email)) {
        // Remove the current user from the list of likes
        likes.remove(currentUser.email);

        // Show a message indicating that the post is removed from favorites
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        // Add the current user to the list of likes
        likes.add(currentUser.email);

        // Show a confirmation message or handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }

      // Update the list of likes in Firestore
      await postRef.update({'Likes': likes});

      // Update the local isLiked state
      setState(() {
        isLiked = !isLiked;
      });
    } catch (e) {
      print('Error toggling favorite: $e');
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return FutureBuilder<List<Comments>>(
          future: widget.commentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<Comments> comments = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
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
                            radius: 24.sp, // Use sp from DeviceExt
                          ),
                        ),
                        SizedBox(width: 8.0),
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
                                    return Text('Loading...');
                                  }

                                  final userData = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  final username = userData['username'] ?? '';

                                  return Row(
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              18.sp, // Use sp from DeviceExt
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      if (userRole.isNotEmpty) ...[
                                        _getRoleIcon(userRole),
                                      ],
                                    ],
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
                        PopupMenuButton<String>(
                          icon: widget.user == currentUser.email
                              ? Icon(Icons.more_vert, color: Colors.grey)
                              : Icon(
                                  isLiked ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                ),
                          itemBuilder: (context) => [
                            if (widget.user == currentUser.email)
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.user == currentUser.email)
                              PopupMenuItem<String>(
                                value: 'update',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 1, 158, 140),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 1, 158, 140),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            PopupMenuItem<String>(
                              value: 'favorites',
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked ? Icons.star : Icons.star_border,
                                    color: Color.fromARGB(255, 1, 158, 140),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    isLiked
                                        ? 'Remove from Favorites'
                                        : 'Add to Favorites',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 158, 140),
                                    ),
                                  ),
                                ],
                              ),
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
                                    builder: (context) => EditPostScreen(
                                      postId: widget.postId,
                                      initialMessage: widget.messages,
                                      initialImageUrl: widget.imageUrl,
                                    ),
                                  ),
                                );

                                break;
                              case 'favorites':
                                toggleFavorite();
                                break;
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.messages,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp, // Use sp from DeviceExt
                      ),
                    ),
                  ),
                  if (widget.imageUrl.isNotEmpty)
                    Container(
                      height: 300.sp, // Use sp from DeviceExt
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
                    padding: EdgeInsets.all(8.0),
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
                                    final data = userDocument.data()
                                        as Map<String, dynamic>;

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
                                  width: 30.sp, // Use sp from DeviceExt
                                  height: 30.sp, // Use sp from DeviceExt
                                ),
                              ),
                            SizedBox(width: 16.sp), // Use sp from DeviceExt
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showComments = !showComments;
                                });
                              },
                              child: Image.asset(
                                'assets/icons/comments.png',
                                width: 30.sp, // Use sp from DeviceExt
                                height: 30.sp, // Use sp from DeviceExt
                              ),
                            ),
                            SizedBox(width: 8.sp), // Use sp from DeviceExt
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user posts')
                                  .doc(widget.postId)
                                  .collection('Comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.sp, // Use sp from DeviceExt
                                    ),
                                  );
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp, // Use sp from DeviceExt
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
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<Widget> commentWidgets =
                            snapshot.data!.docs.map<Widget>((doc) {
                          final commentData =
                              doc.data() as Map<String, dynamic>;
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
      },
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
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
            icon:
                const Icon(Icons.send, color: Color.fromARGB(255, 1, 158, 140)),
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

  Widget _getRoleIcon(String role) {
    String assetPath = ''; // Initialize empty asset path

    switch (role.toLowerCase()) {
      case 'restaurant':
        assetPath = 'assets/images/restaurant (1).png';
        break;
      case 'organization':
        assetPath = 'assets/images/charity (1).png';
        break;
      case 'user':
        assetPath = 'assets/images/user (1).png';
        break;
      default:
        assetPath = 'assets/images/user (1).png';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Image.asset(
        assetPath,
        width: 30.sp,
        height: 30.sp,
      ),
    );
  }
}
