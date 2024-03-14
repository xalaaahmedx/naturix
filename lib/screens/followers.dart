import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/screens/user_profile_screen.dart';

class FollowersScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final followersCollection =
      FirebaseFirestore.instance.collection('followers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: followersCollection
            .doc(currentUser?.email)
            .collection('userFollowers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final followersList = snapshot.data!.docs
                .map((doc) => doc.id)
                .toList(); // Extract IDs from documents
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Followers (${followersList.length})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: followersList.length,
                    itemBuilder: (context, index) {
                      final followerEmail = followersList[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: followerEmail)
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

                            final followerEmail = userData['email'] as String?;
                            if (followerEmail != null) {
                              checkAndAddEmailField(followerEmail);
                            } else {
                              print('Follower email is null');
                            }

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                              useremail: followerEmail ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            userData['profileImageUrl'] ?? ''),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData['username'] ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            userData['bio'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
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

  Future<void> checkAndAddEmailField(String followerEmail) async {
    try {
      final userDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(followerEmail)
          .get();
      if (!userDocs.exists || !userDocs.data()!.containsKey('email')) {
        // Add the email field to the user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followerEmail)
            .set({
          'email': followerEmail,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error checking and adding email field: $e');
    }
  }
}
