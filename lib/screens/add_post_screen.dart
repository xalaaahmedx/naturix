import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/widgets/btm_nav_bar.dart';

class AddPostScreen extends StatefulWidget {
  final String? postId;

  const AddPostScreen({Key? key, this.postId}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  File? _pickedImage;
  bool _isEditing = false;
  bool _isLoading = false;
  String? userRole = 'User'; // Add this line

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      _isEditing = true;
      fetchPostContent();
    }
  }

@override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
    _textEditingController.dispose();
    
  }
  void fetchPostContent() async {
    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(widget.postId)
          .get();
      String postContent = postSnapshot['Message'];
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
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      String? downloadUrl;

      if (_pickedImage != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = storageReference.putFile(_pickedImage!);
        await uploadTask.whenComplete(() => null);
        downloadUrl = await storageReference.getDownloadURL();
      }

      if (_isEditing) {
        await FirebaseFirestore.instance
            .collection('user posts')
            .doc(widget.postId)
            .update({
          'Message': _textEditingController.text,
          'ImageUrl': downloadUrl,
        });
      } else {
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
                const BtmNavBar(role: "",)), // Replace HomePage with your home page widget
      );
    } catch (e) {
      print('Error uploading post: $e');
    } finally {
      setState(() {
        _isLoading = false;
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
        title: Text('Create Post'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 400.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: _pickedImage == null
                      ? Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 60.w,
                            color: Colors.grey,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.w),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 158, 140),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8.w),
                          Text(
                            _isEditing ? 'Update Post' : 'Create Post',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
