import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/screens/charity/itemadd.dart/viewitem.dart';

class FoodBankScreen extends StatelessWidget {
  const FoodBankScreen({Key? key}) : super(key: key);

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
            backgroundColor: Color.fromARGB(255, 1, 158, 140),
          ),
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
                      "assets/images/foodbank.png",
                      width: 60.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text("Egyptian Food Bank",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 25.sp)),
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
                color: Theme.of(context).primaryColor,
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
                  color: Theme.of(context).primaryColor,
                  size: 30.sp,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "- 16060 ",
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
              padding: const EdgeInsets.only(left: 56.0).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "- 888777",
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
                      "Info@efb.eg",
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
