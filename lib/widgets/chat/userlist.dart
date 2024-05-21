import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.text, required this.onTap})
      : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.symmetric(
          vertical: 8.sp,
          horizontal: 16.sp,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2.sp,
              blurRadius: 5.sp,
              offset: Offset(0, 3.sp),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
              radius: 24.sp,
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 16.sp),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
