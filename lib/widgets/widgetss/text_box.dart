import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    this.onTap,
  });

  final String text;
  final String sectionName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
