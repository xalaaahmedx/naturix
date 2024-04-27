import 'package:flutter/material.dart';

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
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (var entry in widget.fields.entries)
              if (entry.key.toLowerCase() != 'image')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: _textControllers[entry.key],
                    maxLines: entry.key.toLowerCase() == 'password' ? 1 : null,
                    obscureText: entry.key.toLowerCase() == 'password',
                    decoration: InputDecoration(
                      labelText: 'Enter new ${entry.key}',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 1, 158, 140)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 1, 158, 140)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
