import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/addpostwidget.dart';
import 'package:naturix/widgets/widgetss/comment.dart';
import 'package:naturix/widgets/widgetss/text_box.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final userPostsCollection =
      FirebaseFirestore.instance.collection('user posts');

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
          text: commentData['CommentText'],
          user: commentData['CommentedBy'],
          time: formatData(commentData['CommentTime']),
          imageUrl: null,
        );
      }).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

 Future<void> editField(String field) async {
  final controller = TextEditingController();

  print('Opening dialog for $field editing...');

  try {
    await showDialog(
      context: context,
      builder: (context) {
        print('Dialog builder for $field');
        return Dialog(
          backgroundColor: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit $field',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 15),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  maxLines: field.toLowerCase() == 'password' ? 1 : null,
                  obscureText: field.toLowerCase() == 'password',
                  decoration: InputDecoration(
                    hintText: 'Enter new $field',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    print('Dialog closed for $field');
  } catch (e) {
    print('Error in showDialog: $e');
  }

  final newValue = controller.text;

  if (newValue.isNotEmpty) {
    await userCollection.doc(currentUser?.email).update({field: newValue});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Add edit profile action
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return FutureBuilder<QuerySnapshot>(
              future: userPostsCollection
                  .where('UserEmail', isEqualTo: currentUser?.email)
                  .get(),
              builder: (context, userPostsSnapshot) {
                if (userPostsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userPostsSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${userPostsSnapshot.error}'),
                  );
                } else {
                  final userPosts = userPostsSnapshot.data!.docs;
                  return ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Card(
                        color: Colors.grey[100],
                        elevation: 5,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    'https://example.com/profile-image.jpg'), // Add your image URL
                              ),
                              SizedBox(height: 20),
                              Text(
                                currentUser?.email ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 20),
                              MyTextBox(
                                text: userData['username'] ?? '',
                                sectionName: 'Username',
                                onTap: () {
                                  print('Tapped on username');
                                  editField('username');
                                },
                              ),
                              MyTextBox(
                                text: userData['bio'] ?? '',
                                sectionName: 'Bio',
                                onTap: () {
                                  print('Tapped on bio');
                                  editField('bio');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (final post in userPosts)
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.only(bottom: 20),
                          color: Colors.grey[100],
                          child: WallPost(
                            messages: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            time: formatData(post['TimeStamp']),
                            imageUrl: (post.data()
                                        as Map<String, dynamic>)['ImageUrl']
                                    as String? ??
                                '',
                            commentsFuture: fetchComments(post.id),
                          ),
                        ),
                    ],
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
      ),
    );
  }
}
