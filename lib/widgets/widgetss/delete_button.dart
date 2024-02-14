import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.delete,
        color: Colors.grey,
      )
    );
  }
}
