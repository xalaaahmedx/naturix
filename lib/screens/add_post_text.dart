import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naturix/storage.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/firestor.dart';

class AddPostTextScreen extends StatefulWidget {
  File? _file;
  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => AddPostTextScreenState();
}

class AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isLooding = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    caption.dispose();
    location.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 1, 158, 140)),
          backgroundColor: Colors.grey[100]!,
          title: const Text(
            'New Post',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLooding = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file!);
                  await Firebase_FireStor().CreatePost(
                      postImage: post_url,
                      caption: caption.text,
                      location: location.text);
                  Navigator.pop(context);
                },
                child: Text(
                  'share',
                  style: TextStyle(
                      color: Color.fromARGB(255, 1, 158, 140),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              )),
            ),
          ],
        ),
        body: isLooding
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 1, 158, 140),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  image: DecorationImage(
                                      image: FileImage(widget._file!),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 280,
                              height: 60,
                              child: TextField(
                                controller: caption,
                                decoration: InputDecoration(
                                  hintText: 'Write a caption...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 280.w,
                          height: 30,
                          child: TextField(
                            controller: location,
                            decoration: InputDecoration(
                              hintText: 'Add Location',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
