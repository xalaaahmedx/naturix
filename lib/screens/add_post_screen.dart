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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'Create Post'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo),
                          SizedBox(width: 8),
                          Text('Add Photo',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 1, 158, 140),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 158, 140),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(
                            _isEditing ? 'Update Post' : 'Create Post',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                  margin: const EdgeInsets.only(top: 16),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
