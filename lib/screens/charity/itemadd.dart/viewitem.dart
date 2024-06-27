import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/screens/charity/itemadd.dart/custom.dart';
import 'package:naturix/screens/charity/view.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  List<String> itemlist = [];
  List<String> weightlist = [];

  TextEditingController _itemcontroller = TextEditingController();
  TextEditingController _weightcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, right: 16, left: 16),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: JelloIn(
                    duration: Duration(seconds: 2),
                    child: Center(
                      child: Text(
                        "Thank You",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  titlePadding: EdgeInsets.symmetric(vertical: 32),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            // Navigate to chat page or perform other actions
                          },
                          child: Text(
                            "Chat",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity.w, 50.h),
            backgroundColor: Color.fromARGB(255, 1, 158, 140),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            "Done",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CharitiesScreen();
              }));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        title: Text(
          "Donated items",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _itemcontroller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDBDBD),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                labelText: "Add Item",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black, // Ensure label text is black
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _weightcontroller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDBDBD),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 1, 158, 140),
                    width: 2.0,
                  ),
                ),
                labelText: "Add Weight",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black, // Ensure label text is black
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(120.w, 50.h),
              backgroundColor: Color.fromARGB(255, 1, 158, 140),
            ),
            onPressed: () {
              itemlist.add(_itemcontroller.text);
              weightlist.add(_weightcontroller.text);
              _itemcontroller.clear();
              _weightcontroller.clear();
              setState(() {});
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView.separated(
              itemCount: itemlist.length,
              itemBuilder: (context, index) => CustomAddMemberScreen(
                x: weightlist[index],
                memberName: itemlist[index],
              ),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 16.h);
              },
            ),
          ),
        ],
      ),
    );
  }
}
