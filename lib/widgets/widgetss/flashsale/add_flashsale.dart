import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sizer/sizer.dart';

class AddFlashSaleScreen extends StatefulWidget {
  @override
  _AddFlashSaleScreenState createState() => _AddFlashSaleScreenState();
}

class _AddFlashSaleScreenState extends State<AddFlashSaleScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> _uploadFlashSale() async {
    if (_pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('flash_sales/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(File(_pickedImage!.path));
      final downloadUrl = await (await uploadTask).ref.getDownloadURL();

      FirebaseFirestore.instance.collection('flashSales').add({
        'description': _descriptionController.text,
        'price': _priceController.text,
        'imageUrl': downloadUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flash Sale')),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400, // Adjust the height as needed
                child: Stack(
                  children: [
                    if (_pickedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_pickedImage!.path),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (_pickedImage == null)
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
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Adjust spacing
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(5.w),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20), // Adjust spacing
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(5.w),
                ),
              ),
              SizedBox(height: 20), // Adjust spacing
              ElevatedButton(
                onPressed: _uploadFlashSale,
                child: Text('Add Flash Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
