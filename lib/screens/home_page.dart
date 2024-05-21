import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/helper/helper_methods.dart';

import 'package:naturix/screens/my_profile.dart';
import 'package:naturix/widgets/posts/wallposts.dart';
import 'package:naturix/widgets/maindrawe.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  double value = 0;
  int currentIndex = 0;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  late PageController _pageController;

  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _pageController.dispose();
  }

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

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void goToProfile() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyProfile(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  void navigateToPage(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Future<void> pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<String?> uploadImageToFirebase(XFile pickedImage) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      File imageFile = File(pickedImage.path);
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight =
        screenSize.height > 600 ? kToolbarHeight + 20 : kToolbarHeight;
    final double drawerWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'Naturix',
          style: TextStyle(
            fontFamily: 'anekMalayalam',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.menu, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        width: drawerWidth,
        child: Drawer(
          elevation: 0,
          child: MainDrawer(navigateToPage: navigateToPage),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user posts')
                      .orderBy('TimeStamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index].data();
                            final imageUrl = post['ImageUrl'] as String? ?? '';

                            if (post['UserEmail'] == currentUser?.email) {
                              return Container(); // Skip rendering this post
                            }

                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(post['UserEmail'])
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    !userSnapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(255, 1, 158, 140),
                                      ),
                                    ),
                                  );
                                }

                                final userData = userSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('user posts')
                                      .doc(snapshot.data!.docs[index].id)
                                      .collection('Comments')
                                      .orderBy('CommentTime', descending: true)
                                      .get(),
                                  builder: (context, commentSnapshot) {
                                    if (commentSnapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !commentSnapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(255, 1, 158, 140),
                                          ),
                                        ),
                                      );
                                    }

                                    final comments = commentSnapshot.data!.docs
                                        .map<Comments>((doc) {
                                      final commentData = doc.data();
                                      return Comments(
                                        userProfileImageUrl:
                                            userData['profileImageUrl']
                                                    as String? ??
                                                '',
                                        text: commentData['CommentText'],
                                        user: commentData['CommentedBy'],
                                        time: formatData(
                                            commentData['CommentTime']),
                                        imageUrl: null,
                                      );
                                    }).toList();

                                    return Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            WallPost(
                                              userProfileImageUrl:
                                                  userData['profileImageUrl']
                                                          as String? ??
                                                      '',
                                              messages: post['Message'],
                                              user: post['UserEmail'],
                                              postId: snapshot
                                                      .data!.docs[index].id ??
                                                  '',
                                              likes: List<String>.from(
                                                  post['Likes'] ?? []),
                                              time:
                                                  formatData(post['TimeStamp']),
                                              imageUrl: imageUrl,
                                              commentsFuture: fetchComments(
                                                  snapshot.data!.docs[index]
                                                          .id ??
                                                      ''),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 1, 158, 140),
                      ),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
