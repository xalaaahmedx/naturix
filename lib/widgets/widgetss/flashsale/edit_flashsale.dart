import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditFlashSaleScreen extends StatefulWidget {
  final String flashSaleId;

  const EditFlashSaleScreen({Key? key, required this.flashSaleId})
      : super(key: key);

  @override
  _EditFlashSaleScreenState createState() => _EditFlashSaleScreenState();
}

class _EditFlashSaleScreenState extends State<EditFlashSaleScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _pickedImage;
  String _imageUrl = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadFlashSaleData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadFlashSaleData() async {
    final flashSale = await FirebaseFirestore.instance
        .collection('flashSales')
        .doc(widget.flashSaleId)
        .get();
    setState(() {
      _descriptionController.text = flashSale['description'];
      _priceController.text = flashSale['price']; // Load the price
      _imageUrl = flashSale['imageUrl'];
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> _updateFlashSale() async {
    if (_pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('flash_sales/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(File(_pickedImage!.path));
      _imageUrl = await (await uploadTask).ref.getDownloadURL();
    }

    FirebaseFirestore.instance
        .collection('flashSales')
        .doc(widget.flashSaleId)
        .update({
      'description': _descriptionController.text,
      'price': _priceController.text, // Update the price
      'imageUrl': _imageUrl,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Flash Sale')),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to avoid infinite height issue
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 400,
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
                                fontSize: 16, color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(5),
                ),
                maxLines: null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(5),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateFlashSale,
                child: Text('Update Flash Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
