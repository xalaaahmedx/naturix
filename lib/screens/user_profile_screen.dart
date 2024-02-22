import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/wallposts.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class UserProfile extends StatefulWidget {
  final String useremail;
  final String currentUserEmail; // Add current user email

  const UserProfile({
    Key? key,
    required this.useremail,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late int postsCount = 0;
  late int followersCount = 0;
  late int followingCount = 0;
  bool isFollowing = false;

  Future<List<Comments>> fetchComments(String postId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(postId)
          .collection('Comments')
          .orderBy('CommentTime', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Comments(
          text: data['CommentText'],
          user: data['CommentedBy'],
          time: formatData(data['CommentTime']),
          imageUrl: null, // You can modify this based on your data structure
        );
      }).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCounts();
    checkIfFollowing();
  }

  Future<void> fetchCounts() async {
    try {
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .where('UserEmail', isEqualTo: widget.useremail)
          .get();

      final followersSnapshot = await FirebaseFirestore.instance
          .collection('followers')
          .doc(widget.useremail)
          .collection('userFollowers')
          .get();

      final followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(widget.useremail)
          .collection('userFollowing')
          .get();

      setState(() {
        postsCount = postsSnapshot.size;
        followersCount = followersSnapshot.size;
        followingCount = followingSnapshot.size;
      });
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  Future<void> checkIfFollowing() async {
    try {
      final followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(widget.currentUserEmail)
          .collection('userFollowing')
          .doc(widget.useremail)
          .get();

      setState(() {
        isFollowing = followingSnapshot.exists;
      });
    } catch (e) {
      print('Error checking if following: $e');
    }
  }

  Future<void> toggleFollow() async {
    try {
      if (isFollowing) {
        // Unfollow the user
        await FirebaseFirestore.instance
            .collection('following')
            .doc(widget.currentUserEmail)
            .collection('userFollowing')
            .doc(widget.useremail)
            .delete();

        await FirebaseFirestore.instance
            .collection('followers')
            .doc(widget.useremail)
            .collection('userFollowers')
            .doc(widget.currentUserEmail)
            .delete();
      } else {
        // Follow the user
        await FirebaseFirestore.instance
            .collection('following')
            .doc(widget.currentUserEmail)
            .collection('userFollowing')
            .doc(widget.useremail)
            .set({});

        await FirebaseFirestore.instance
            .collection('followers')
            .doc(widget.useremail)
            .collection('userFollowers')
            .doc(widget.currentUserEmail)
            .set({});
      }

      // Update following status
      setState(() {
        isFollowing = !isFollowing;
      });

      // Update follower and following counts
      fetchCounts();
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'userImage${widget.useremail}',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userData['profileImageUrl'] ??
                                'https://example.com/default-profile-image.jpg',
                          ),
                          radius: 50,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        userData['username'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCountColumn('Posts', postsCount),
                          SizedBox(width: 16),
                          _buildCountColumn('Followers', followersCount),
                          SizedBox(width: 16),
                          _buildCountColumn('Following', followingCount),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: toggleFollow,
                        style: ElevatedButton.styleFrom(
                          primary: isFollowing
                              ? Colors.grey
                              : Color.fromARGB(255, 1, 158,
                                  140), // Use different colors for follow and unfollow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the border radius as needed
                          ),
                        ),
                        child: Text(
                          isFollowing ? 'Unfollow' : 'Follow',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'User Posts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final posts = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post =
                                posts[index].data() as Map<String, dynamic>;

                            return Card(
                              margin: EdgeInsets.all(8),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: WallPost(
                                  messages: post['Message'],
                                  user: post['UserEmail'],
                                  postId: posts[index].id,
                                  likes: List<String>.from(post['Likes'] ?? []),
                                  time: formatData(post['TimeStamp']),
                                  imageUrl: post['ImageUrl'] as String? ?? '',
                                  commentsFuture:
                                      fetchComments(posts[index].id),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    stream: FirebaseFirestore.instance
                        .collection('user posts')
                        .where('UserEmail', isEqualTo: widget.useremail)
                        .snapshots(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.useremail)
            .snapshots(),
      ),
    );
  }

  Widget _buildCountColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
