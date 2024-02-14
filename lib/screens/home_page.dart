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
import 'package:naturix/widgets/addpostwidget.dart';

import 'package:naturix/widgets/maindrawe.dart';

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
      backgroundColor: Colors.grey[100]!,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
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
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.all(16.0),
            child: MainDrawer(
              navigateToPage: navigateToPage,
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
                elevation: 0,
                title: const Text(
                  'Naturix',
                  style: TextStyle(
                    fontFamily: 'anekMalayalam',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                backgroundColor: Colors.transparent,
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
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user posts')
                            .orderBy('TimeStamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final post = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                                final imageUrl =
                                    post['ImageUrl'] as String? ?? '';

                                return WallPost(
                                  messages: post['Message'],
                                  user: post['UserEmail'],
                                  postId: snapshot.data!.docs[index].id,
                                  likes: List<String>.from(post['Likes'] ?? []),
                                  time: formatData(post['TimeStamp']),
                                  imageUrl: imageUrl,
                                );
                              },
                            );
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
        ],
      ),
    );
  }
}
