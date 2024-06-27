import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/screens/charity/itemadd.dart/viewitem.dart';

class ResalaScreen extends StatelessWidget {
  const ResalaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 200, bottom: 30, right: 30),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItem(),
                ),
                (route) => false);
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(50, 60),
              backgroundColor: Color.fromARGB(255, 1, 158, 140)),
          child: Text(
            "Donate",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/Resala 1.png",
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text("Resala ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    5,
                    (index) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ))
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Informations",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 1, 158, 140),
              ),
            ),
            Container(
              height: 4.h,
              width: 150.w,
              color: Color.fromARGB(255, 1, 158, 140),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 1, 158, 140),
                  size: 30,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "- 19450 ",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 20.sp),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              "Bank accounts :",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 158, 140), fontSize: 20.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "- 1623060320945400012",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "- 3920001000019450  ",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "- 100009213842  ",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 1, 158, 140),
                  size: 30,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Row(
                  children: [
                    Text(
                      ":",
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Color.fromARGB(255, 1, 158, 140),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "Contact_us@resala.org",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Color.fromARGB(255, 1, 158, 140),
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
