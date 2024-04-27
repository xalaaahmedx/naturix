import 'package:flutter/material.dart';

class MyTextFieldWithPhotoButton extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback onPressed;

  const MyTextFieldWithPhotoButton({super.key, 
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            obscureText: obscureText,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.photo),
              SizedBox(width: 8),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
