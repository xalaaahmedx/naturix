import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> fields;

  const EditProfile({super.key, required this.fields});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Map<String, TextEditingController> _textControllers;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove app bar shadow
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18.sp, // Responsive font size
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black, size: 24.w),
            onPressed: () {
              Map<String, dynamic> updatedValues = {};

              for (var entry in widget.fields.entries) {
                updatedValues[entry.key] = _textControllers[entry.key]?.text;
              }

              Navigator.of(context).pop(updatedValues);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w), // Responsive padding
        child: ListView(
          children: [
            for (var entry in widget.fields.entries)
              if (entry.key.toLowerCase() != 'image')
                Padding(
                  padding: EdgeInsets.only(bottom: 20.w), // Responsive padding
                  child: TextField(
                    controller: _textControllers[entry.key],
                    maxLines: entry.key.toLowerCase() == 'password' ? 1 : null,
                    obscureText: entry.key.toLowerCase() == 'password',
                    decoration: InputDecoration(
                      labelText: 'Enter new ${entry.key}',
                      labelStyle: TextStyle(
                        color: Colors.teal,
                        fontSize: 14.sp, // Responsive font size
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal,
                          width: 1.w, // Responsive border width
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.w, // Responsive border width
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.w), // Rounded corners
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 10.w,
                      ), // Padding inside the text field
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
