import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/data/categories.dart';
import 'package:naturix/model/category.dart';
import 'package:naturix/model/grocery_item.dart';
import 'package:naturix/widgets/custom_buttons.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _selectedCategory = categories[Categories.vegetables]!;
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _isSending = false;

  final CollectionReference _groceryItemsCollection =
      FirebaseFirestore.instance.collection('groceryItems');

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      try {
        await _groceryItemsCollection.add({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
          'isSelected': false,
        });

        // Reset the form
        _formKey.currentState!.reset();

        setState(() {
          _isSending = false;
        });

        Navigator.of(context).pop(); // Close the NewItem screen
      } catch (e) {
        // Handle error (display a snackbar, for example)
        print('Error saving item: $e');
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Item',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'anekMalayalam',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/list.png', // Replace with the actual image path
                  width: 300, // Set your desired width
                  height: 300, // Set your desired height
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 1, 158, 140),
                            ),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 50) {
                            return 'Must be between 1 and 50 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 1, 158, 140),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 1, 158, 140),
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: _enteredQuantity.toString(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return 'Must be a valid, positive number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredQuantity = int.parse(value!);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField(
                              value: _selectedCategory,
                              items: [
                                for (final category in categories.entries)
                                  DropdownMenuItem(
                                    value: category.value,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          category.value.iconPath,
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          category.value.title,
                                          style: TextStyle(
                                            fontFamily: 'anekMalayalam',
                                            color: Colors
                                                .black, // Set the text color to black
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 158, 140),
                          )),
                    ),
                    CustomButton(
                      onPressed: _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Item',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
