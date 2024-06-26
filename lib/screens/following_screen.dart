import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/screens/user_profile_screen.dart';

class FollowingScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final followingCollection =
      FirebaseFirestore.instance.collection('following');

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: followingCollection
            .doc(currentUser?.email)
            .collection('userFollowing')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final followingList = snapshot.data!.docs
                .map((doc) => doc.id)
                .toList(); // Extract IDs from documents
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  child: Text(
                    'Following (${followingList.length})',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: followingList.length,
                    itemBuilder: (context, index) {
                      final followedEmail = followingList[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: followedEmail)
                            .limit(1) // Limit the query to 1 document
                            .get()
                            .then((value) => value.docs
                                .first), // Get the first document from the result
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return SizedBox(); // Return an empty container
                          } else {
                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;

                            final followedEmail = userData['email'] as String?;
                            if (followedEmail != null) {
                              checkAndAddEmailField(followedEmail);
                            } else {
                              print('Followed email is null');
                            }

                            return Card(
                              margin: EdgeInsets.symmetric(
                                vertical: screenSize.width * 0.02,
                                horizontal: screenSize.width * 0.08,
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.04),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to user profile
                                        // You can implement the navigation logic here
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                              currentUserEmail: currentUser
                                                      ?.email ??
                                                  '', // Providing a default value
                                              useremail: followedEmail ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: screenSize.width * 0.1,
                                        backgroundImage: NetworkImage(
                                            userData['profileImageUrl'] ?? ''),
                                      ),
                                    ),
                                    SizedBox(width: screenSize.width * 0.04),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData['username'] ?? '',
                                            style: TextStyle(
                                              fontSize: screenSize.width * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenSize.width * 0.01),
                                          Text(
                                            userData['bio'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize:
                                                  screenSize.width * 0.035,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> checkAndAddEmailField(String followedEmail) async {
    try {
      final userDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(followedEmail)
          .get();
      if (!userDocs.exists || !userDocs.data()!.containsKey('email')) {
        // Add the email field to the user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followedEmail)
            .set({
          'email': followedEmail,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error checking and adding email field: $e');
    }
  }
}
