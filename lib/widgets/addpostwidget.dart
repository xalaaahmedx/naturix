import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({Key? key}) : super(key: key);

  @override
  State<AddPostWidget> createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 54,
          color: Colors.grey[100]!,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset('assets/images/bear.png'),
                ),
              ),
              title: Text(
                'username',
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Text(
                'location',
                style: TextStyle(
                  fontSize: 11.sp,
                ),
              ),
              trailing: Icon(
                Icons.more_horiz_rounded,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 375,
          height: 375,
          color: Colors.grey[100]!,
          child: Image.asset(
            'assets/images/plant-three.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        // Row containing favorite icon and "0" UI element
        Container(
          width: 375,
          height: 54,
          color: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                  SizedBox(
                    width: 180,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 8),
          child: Text(
            '0',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            children: [
              Text('username' + '',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 5,
              ),
              Text('caption',
                  style: TextStyle(
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
          child: Text(
            'dateformat',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
