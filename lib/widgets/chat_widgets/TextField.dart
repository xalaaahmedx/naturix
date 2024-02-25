import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key? key,
      required this.controller,
      required this.obsecureText,
      required this.hintText})
      : super(key: key);

  final TextEditingController controller;
  final bool obsecureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,

      // Set the text color to the primary color of the theme
      decoration: InputDecoration(
          hintText: hintText, // Moved hintText here
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
  }
}
