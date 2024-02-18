import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/screens/add_post_screen.dart';
import 'package:naturix/screens/my_profile.dart';
import 'package:naturix/widgets/wallposts.dart';
import 'package:naturix/widgets/maindrawe.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
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

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void goToProfile() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyProfile(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 1, 158, 140),
                    Color.fromARGB(255, 2, 165, 146),
                    Color.fromARGB(246, 199, 218, 218),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: MainDrawer(
                navigateToPage: navigateToPage,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..setEntry(0, 3, 200 * value)
              ..rotateY((pi / 6) * value),
            child: Scaffold(
              extendBody: true,
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                elevation: 2, // Add elevation for a subtle shadow effect
                title: Text(
                  'Naturix',
                  style: TextStyle(
                    fontFamily: 'anekMalayalam', // Add your custom font here
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                backgroundColor: Colors.grey[100],
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    setState(() {
                      value == 0 ? value = 1 : value = 0;
                    });
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
                                    final post = snapshot.data!.docs[index]
                                        .data() as Map<String, dynamic>;
                                    final imageUrl =
                                        post['ImageUrl'] as String? ?? '';
                                    return FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('user posts')
                                          .doc(snapshot.data!.docs[index].id)
                                          .collection('Comments')
                                          .orderBy('CommentTime',
                                              descending: true)
                                          .get(),
                                      builder: (context, commentSnapshot) {
                                        if (commentSnapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            !commentSnapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }

                                        final comments = commentSnapshot
                                            .data!.docs
                                            .map<Comments>((doc) {
                                          final commentData = doc.data()
                                              as Map<String, dynamic>;
                                          return Comments(
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                WallPost(
                                                  messages: post['Message'],
                                                  user: post['UserEmail'],
                                                  postId: snapshot.data!
                                                          .docs[index].id ??
                                                      '',
                                                  likes: List<String>.from(
                                                      post['Likes'] ?? []),
                                                  time: formatData(
                                                      post['TimeStamp']),
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
                                  });
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
