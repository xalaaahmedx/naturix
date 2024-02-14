import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: AddPostForm(
        textEditingController: _textEditingController,
        pickedImage: _pickedImage,
      ),
    );
  }
}

class AddPostForm extends StatefulWidget {
  AddPostForm({
    Key? key,
    required this.textEditingController,
    this.pickedImage,
  }) : super(key: key);

  final TextEditingController textEditingController;
  XFile? pickedImage;

  @override
  _AddPostFormState createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  bool _uploading = false;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        widget.textEditingController.clear();
        widget.textEditingController.clearComposing();
        widget.pickedImage = pickedImage;
      });
    }
  }

  Future<void> _uploadPost() async {
    try {
      setState(() {
        _uploading = true;
      });

      String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      String? downloadUrl;

      if (widget.pickedImage != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');
        File imageFile = File(widget.pickedImage!.path);
        UploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() => null);

        downloadUrl = await storageReference.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('user posts').add({
        'UserEmail': currentUserEmail,
        'Message': widget.textEditingController.text,
        'TimeStamp': Timestamp.fromDate(DateTime.now()),
        'Likes': [],
        'ImageUrl': downloadUrl,
      });

      setState(() {
        _uploading = false;
      });

      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close the current screen (AddPostScreen)
      } else {
        // Handle the case when there's no navigator to pop
        print('No valid navigator to pop');
      }
    } catch (e) {
      print('Error uploading post: $e');
      setState(() {
        _uploading = false;
      });
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              controller: widget.textEditingController,
              decoration: InputDecoration(
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
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo),
                        const SizedBox(width: 8),
                        Text('Add Photo', style: TextStyle(fontSize: 16, color:   Color.fromARGB(255, 1, 158, 140),)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _uploading ? null : _uploadPost,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 1, 158, 140),
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        const SizedBox(width: 8),
                        Text(
                          'Create Post',
                          style: TextStyle(
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
            if (widget.pickedImage != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(widget.pickedImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (_uploading)
              const SizedBox(height: 16, child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
