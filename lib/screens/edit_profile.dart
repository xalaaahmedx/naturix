import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> fields;

  EditProfile({required this.fields});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Map<String, TextEditingController> _textControllers;
  late File _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _textControllers = Map.fromEntries(
      widget.fields.keys.map(
        (field) => MapEntry(
          field,
          TextEditingController(text: widget.fields[field].toString()),
        ),
      ),
    );
    _selectedImage = File('');
  }

  Future<void> _pickImageFromGallery() async {
    final imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _selectedImage = File(imageFile.path);
      });
    }
  }

  Future<void> _uploadImageToStorage(String field) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/${field}.jpg');

      await storageReference.putFile(_selectedImage);
      final String imageUrl = await storageReference.getDownloadURL();

      Navigator.of(context).pop({field: imageUrl});
    } catch (e) {
      print('Error uploading image to storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove app bar shadow
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: () {
              Map<String, dynamic> updatedValues = {};

              for (var entry in widget.fields.entries) {
                String field = entry.key;

                if (field.toLowerCase() == 'image') {
                  _uploadImageToStorage(field);
                } else {
                  updatedValues[field] = _textControllers[field]?.text;
                }
              }

              Navigator.of(context).pop(updatedValues);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (var entry in widget.fields.entries)
              if (entry.key.toLowerCase() == 'image')
                GestureDetector(
                  onTap: () {
                    _pickImageFromGallery();
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage.path.isNotEmpty
                          ? FileImage(_selectedImage)
                          : AssetImage('assets/placeholder_image.jpg')
                              as ImageProvider,
                    ),
                  ),
                ),
            SizedBox(height: 20),
            for (var entry in widget.fields.entries)
              if (entry.key.toLowerCase() != 'image')
                TextField(
                  controller: _textControllers[entry.key],
                  maxLines: entry.key.toLowerCase() == 'password' ? 1 : null,
                  obscureText: entry.key.toLowerCase() == 'password',
                  decoration: InputDecoration(
                    hintText: 'Enter new ${entry.key}',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
