import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturix/screens/add_post_text.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<File> selectedImages = [];
  int selectedImageIndex = 0;

  Future<void> _fetchNewMedia() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImages.add(File(pickedFile.path));
      setState(() {
        selectedImageIndex = selectedImages.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        title: Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'anekMalayalam',
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                child: Text('Next'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddPostTextScreen(
                        selectedImages[selectedImageIndex],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375,
                child: selectedImages.isNotEmpty
                    ? buildImageWidget(selectedImages[selectedImageIndex])
                    : Container(),
              ),
              Container(
                width: double.infinity,
                height: 48,
                color: Colors.grey[100],
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchNewMedia();
                },
                child: Text(
                  'Open Image Picker',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget(File imageFile) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
