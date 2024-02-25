import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/wallposts.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class UserProfile extends StatefulWidget {
  final String useremail;
  final String currentUserEmail;

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
  late String bio = '';

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
          userProfileImageUrl: data['UserProfileImageUrl'],
          text: data['CommentText'],
          user: data['CommentedBy'],
          time: formatData(data['CommentTime']),
          imageUrl: null,
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
    fetchBio();
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

  Future<void> fetchBio() async {
    try {
      final bioSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.useremail)
          .get();

      setState(() {
        bio = bioSnapshot.get('bio') ?? '';
      });
    } catch (e) {
      print('Error fetching bio: $e');
    }
  }

  Future<void> toggleFollow() async {
    try {
      if (isFollowing) {
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

      setState(() {
        isFollowing = !isFollowing;
      });

      fetchCounts();
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 158, 140),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 1, 158, 140),
                        Color.fromARGB(255, 0, 109, 97),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          // Implement the image change functionality if needed
                        },
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        bio,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$postsCount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Posts',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$followersCount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$followingCount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: toggleFollow,
                        style: ElevatedButton.styleFrom(
                          primary: isFollowing
                              ? Colors.grey[200]
                              : Color.fromARGB(255, 1, 158, 140),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          isFollowing ? 'Unfollow' : 'Follow',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'User Posts',
                      style: TextStyle(
                        fontFamily: 'anekMalayalam',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                                  userProfileImageUrl:
                                      userData['profileImageUrl'] as String? ??
                                          '',
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
}
