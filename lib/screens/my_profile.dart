import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/addpostwidget.dart';
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit $field',
                      style: const TextStyle(color: Colors.white)),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter new $field',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(controller.text);
                        },
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
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
        backgroundColor: Colors.grey[300],
        title: const Text('My Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return FutureBuilder<QuerySnapshot>(
              // Fetch user posts
              future: userPostsCollection
                  .where('UserEmail', isEqualTo: currentUser?.email)
                  .get(),
              builder: (context, userPostsSnapshot) {
                if (userPostsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userPostsSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${userPostsSnapshot.error}'));
                } else {
                  final userPosts = userPostsSnapshot.data!.docs;
                  return ListView(
                    children: [
                      const SizedBox(height: 50),
                      const Icon(Icons.person,
                          size: 100, color: Color.fromARGB(255, 0, 0, 0)),
                      Text(
                        currentUser?.email ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'My Details',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      MyTextBox(
                        text: userData['username'] ?? '',
                        sectionName: 'username',
                        onTap: () {
                          print('Tapped on username');
                          editField('username');
                        },
                      ),
                      MyTextBox(
                        text: userData['bio'] ?? '',
                        sectionName: 'bio',
                        onTap: () {
                          print('Tapped on bio');
                          editField('bio');
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'My Posts',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      // Display user posts
                      for (final post in userPosts)
                        WallPost(
                          messages: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatData(post['TimeStamp']), imageUrl: '',
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
          return const Center(
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
