import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naturix/services/firestor.dart';
import 'package:naturix/model/user.dart';
import 'package:naturix/widgets/image.dart';
import 'package:sizer/sizer.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key});
  bool isEditingBio = false;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('My Profile'),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: Firebase_FireStor().getUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Head(snapshot.data!);
                  },
                ),
              ),
              StreamBuilder(
                stream: _firebaseFirestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  var snapLength = snapshot.data!.docs.length;
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var snap = snapshot.data!.docs[index];
                        return Container(
                          color: Colors.grey[100],
                          child: CachedImage(
                            snap['postImage'],
                          ),
                        );
                      },
                      childCount: snapLength,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Head(UserModels user) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  // child: CachedImage(''),
                ),
              ),
            ),
            SizedBox(
              width: 15, // Added space between the image and numbers
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0.sp,
                      ),
                    ),
                    SizedBox(
                      width: 18.w,
                    ),
                    Text(
                      // user.followers.length.toString(),
                      '10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(
                      width: 22.w,
                    ),
                    Text(

                      //user.following.length.toString(),
                      '10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Posts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Followers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Following',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.username,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'bio',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
              alignment: Alignment.center,
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(255, 1, 158, 140),
                ),
              ),
              child: Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 158, 140),
                    fontSize: 15,
                  ),
                ),
              )),
        ),
        SizedBox(
          height: 30,
          width: double.infinity,
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 1, 158, 140),
            tabs: [
              Icon(
                Icons.grid_on,
                color: Color.fromARGB(255, 1, 158, 140),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
