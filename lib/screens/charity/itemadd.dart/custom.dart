import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAddMemberScreen extends StatelessWidget {
  CustomAddMemberScreen({
    Key? key,
    required this.x,
    required this.memberName,
  }) : super(key: key);

  String x;
  String memberName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(.5)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "- $memberName",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Ensure text is black
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 50.w,
              height: 50.h,
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                border: Border.all(color: Theme.of(context).primaryColor),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "$x K",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
