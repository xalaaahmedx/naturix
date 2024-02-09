import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:naturix/services/firebase_service.dart';
import 'package:naturix/widgets/image.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostWidget extends StatelessWidget {
  final snapshot;

  const AddPostWidget(this.snapshot, {Key? key}) : super(key: key);

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
                    snapshot['profileImage'] ?? '',
                  ),
                ),
              ),
              title: FutureBuilder(
                future: getUserData(snapshot['username']),
                builder: (context, usernameSnapshot) {
                  if (snapshot['username'] == null) {
                    return Text('Unknown');
                  }

                  if (usernameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (usernameSnapshot.hasError) {
                    return Text('Error: ${usernameSnapshot.error}');
                  }

                  final usernameData = usernameSnapshot.data;
                  if (usernameData is String) {
                    return Text(
                      usernameData,
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    );
                  } else {
                    return Text('Unknown');
                  }
                },
              ),
              subtitle: Text(
                snapshot['location']!,
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
            snapshot['postImage'] ?? '',
          ),
        ),
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
                snapshot['likes'].length.toString() + ' likes',
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
              FutureBuilder(
                future: getUserData(snapshot['username']),
                builder: (context, usernameSnapshot) {
                  if (snapshot['username'] == null) {
                    return Text('Unknown');
                  }

                  if (usernameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (usernameSnapshot.hasError) {
                    return Text('Error: ${usernameSnapshot.error}');
                  }

                  final usernameData = usernameSnapshot.data;
                  if (usernameData is String) {
                    return Text(
                      usernameData,
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    );
                  } else {
                    return Text('Unknown');
                  }
                },
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                snapshot['caption']! + '',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
          child: Text(
            '',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
