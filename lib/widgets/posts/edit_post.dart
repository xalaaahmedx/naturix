import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String initialMessage;
  final String initialImageUrl;

  const EditPostScreen({
    Key? key,
    required this.postId,
    required this.initialMessage,
    required this.initialImageUrl,
  }) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _messageController;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.initialMessage);
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> updatePost() async {
    try {
      await FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId)
          .update({
        'Message': _messageController.text,
        'ImageUrl': _imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
    } catch (e) {
      print('Error updating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update post')),
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(File(pickedFile.path));

        // Get download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();

        setState(() {
          _imageUrl = imageUrl; // Update _imageUrl with the download URL
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Sizer(
        builder: (context, orientation, deviceType) {
          return Padding(
            padding: EdgeInsets.all(5.w),
            child: ListView(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Stack(
                    children: [
                      if (_imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (_imageUrl.isEmpty)
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'No Image',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 2.h,
                        right: 2.w,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _getImageFromGallery();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Edit Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.all(5.w),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 5.h),
                ElevatedButton(
                  onPressed: () {
                    updatePost();
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Update Post'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
