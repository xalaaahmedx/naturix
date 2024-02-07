import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:naturix/widgets/image.dart';
import 'package:sizer/sizer.dart';

class AddPostWidget extends StatelessWidget {
  final snapShot;

  const AddPostWidget(this.snapShot, {super.key});

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
                    child: CachedImage(
                      snapShot['profileImage'] ?? '',
                    )),
              ),
              title: Text(
                snapShot['username']!,
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Text(
                snapShot['location']!,
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
          child: CachedImage(
            snapShot['postImage'] ?? '',
          )
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
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                snapShot['likes'].length.toString() + ' likes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
              Text(snapShot['caption']! + '',
                  style: TextStyle(
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
          child: Text(
            '',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
