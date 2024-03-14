import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final followingCollection =
      FirebaseFirestore.instance.collection('following');

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Following (${followingList.length})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return Text('User data not available');
                          } else {
                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;

                            final followedEmail = userData['email'] as String?;
                            if (followedEmail != null) {
                              checkAndAddEmailField(followedEmail);
                            } else {
                              print('Followed email is null');
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userData['profileImageUrl'] ?? ''),
                              ),
                              title: Text(userData['username'] ?? ''),
                              subtitle: Text(userData['bio'] ?? ''),
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
          .where('email', isEqualTo: followedEmail)
          .limit(1)
          .get()
          .then((value) => value.docs.first);
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
