import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;

  const EditPostScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController _textEditingController = TextEditingController();
  XFile? _pickedImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Fetch the current post data and set it to the text field
    _fetchPostData();
  }

  void _fetchPostData() async {
    setState(() {
      _loading = true;
    });
    try {
      final postSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId)
          .get();
      setState(() {
        _textEditingController.text = postSnapshot['Message'] ?? '';
        _loading = false;
      });
    } catch (error) {
      print('Error fetching post data: $error');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _updatePost() async {
    setState(() {
      _loading = true;
    });

    try {
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

      await FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId)
          .update({
        'Message': _textEditingController.text,
        'ImageUrl': downloadUrl,
      });

      setState(() {
        _loading = false;
      });

      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close the current screen (EditPostScreen)
      } else {
        // Handle the case when there's no navigator to pop
        print('No valid navigator to pop');
      }
    } catch (e) {
      print('Error updating post: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Edit your post...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    const SizedBox(height: 16),
                    _pickedImage != null
                        ? Image.file(File(_pickedImage!.path))
                        : SizedBox(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updatePost,
                      child: Text('Update Post'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
