import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        color: const Color.fromARGB(255, 0, 196, 173),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2.sp,
            blurRadius: 5.sp,
            offset: Offset(0, 2.sp),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
