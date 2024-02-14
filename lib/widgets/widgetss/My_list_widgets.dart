import 'package:flutter/material.dart';

class MyListTiles extends StatelessWidget {
  const MyListTiles(
      {super.key, required this.icon, required this.text, this.onTap});

  final IconData icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
