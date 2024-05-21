import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/widgets/btm_nav_bar.dart';

class AddPostScreen extends StatefulWidget {
  final String? postId;

  const AddPostScreen({Key? key, this.postId}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  XFile? _pickedImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      _isEditing = true;
      // Fetch the existing post content if in edit mode
      fetchPostContent();
    }
  }

  void fetchPostContent() async {
    try {
      // Fetch the post document from Firestore
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId)
          .get();

      // Extract the post content
      String postContent = postSnapshot['Message'];

      // Set the post content to the text field
      _textEditingController.text = postContent;
    } catch (e) {
      print('Error fetching post content: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _textEditingController.clear();
        _textEditingController.clearComposing();
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _uploadPost() async {
    try {
      String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      String? downloadUrl;

      if (_pickedImage != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');
        File imageFile = File(_pickedImage!.path);
        UploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() => null);

        downloadUrl = await storageReference.getDownloadURL();
      }

      if (_isEditing) {
        // Update existing post if in edit mode
        await FirebaseFirestore.instance
            .collection('user posts')
            .doc(widget.postId)
            .update({
          'Message': _textEditingController.text,
          'ImageUrl': downloadUrl,
        });
      } else {
        // Add new post if not in edit mode
        await FirebaseFirestore.instance.collection('user posts').add({
          'UserEmail': currentUserEmail,
          'Message': _textEditingController.text,
          'TimeStamp': Timestamp.fromDate(DateTime.now()),
          'Likes': [],
          'ImageUrl': downloadUrl,
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const BtmNavBar()), // Replace HomePage with your home page widget
      );
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'Create Post'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Container(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenSize.width * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: screenSize.width * 0.01,
                spreadRadius: screenSize.width * 0.002,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              SizedBox(height: screenSize.width * 0.04),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenSize.width * 0.03),
                            bottomRight:
                                Radius.circular(screenSize.width * 0.03),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo),
                          SizedBox(width: screenSize.width * 0.02),
                          Text(
                            'Add Photo',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              color: Color.fromARGB(255, 1, 158, 140),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 1, 158, 140),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenSize.width * 0.03),
                            bottomRight:
                                Radius.circular(screenSize.width * 0.03),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: screenSize.width * 0.02),
                          Text(
                            _isEditing ? 'Update Post' : 'Create Post',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_pickedImage != null)
                Container(
                  margin: EdgeInsets.only(top: screenSize.width * 0.04),
                  height: screenSize.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.03),
                    image: DecorationImage(
                      image: FileImage(File(_pickedImage!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
