import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/screens/user_profile_screen.dart';
import 'package:naturix/widgets/posts_search.dart';
import 'package:naturix/helper/helper_methods.dart';
import 'package:naturix/widgets/widgetss/comment.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserEmail; // Variable to store the current user's email

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Retrieve current user's email when the widget is initialized
    _getCurrentUserEmail();
  }

  Future<void> _getCurrentUserEmail() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserEmail = currentUser.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textFieldHeight = screenSize.height * 0.06;
    final double tabBarHeight = screenSize.height * 0.08;

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(textFieldHeight),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(fontFamily: 'anekMalayalam'),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onChanged: (query) {
                performCombinedSearch(query);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: tabBarHeight,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Users'),
                Tab(text: 'Posts'),
              ],
              labelColor: const Color.fromARGB(255, 1, 158, 140),
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: const Color.fromARGB(255, 1, 158, 140),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTab(),
                _buildPostsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = userSnapshot.data!.docs;
        List<Map<String, dynamic>> usersSearchResults =
            users.map((doc) => doc.data()).toList();

        if (_searchController.text.isNotEmpty) {
          // If there is a search query, filter the users
          usersSearchResults = usersSearchResults.where((user) {
            return user['username']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();
        }

        // Exclude the current user from search results
        usersSearchResults = usersSearchResults
            .where((user) => user['email'] != currentUserEmail)
            .toList();

        return ListView.builder(
          itemCount: usersSearchResults.length,
          itemBuilder: (context, index) {
            final user = usersSearchResults[index];
            return _buildUserResult(user);
          },
        );
      },
    );
  }

  Widget _buildPostsTab() {
    return _buildPostSearchResults(_searchController.text);
  }

  Widget _buildPostSearchResults(String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user posts')
          .where('Message', isGreaterThanOrEqualTo: query)
          .snapshots(),
      builder: (context, postSnapshot) {
        if (!postSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final posts = postSnapshot.data!.docs;

        List<Widget> postWidgets = posts.map<Widget>((post) {
          final postDetails = post.data() as Map<String, dynamic>;

          // Check if the post is not from the current user
          if (postDetails['UserEmail'] != currentUserEmail) {
            return WallPostSearch(
              postId: post.id,
              fetchComments: fetchComments,
              userProfileImageUrl: postDetails['userProfileImageUrl'] ?? '',
              messages: postDetails['Message'],
              user: postDetails['UserEmail'],
              likes: List<String>.from(postDetails['Likes'] ?? []),
              time: formatData(postDetails['TimeStamp']),
              imageUrl: postDetails['ImageUrl'] ?? '',
            );
          } else {
            // Return an empty container for posts from the current user
            return Container();
          }
        }).toList();

        return ListView(
          children: postWidgets,
        );
      },
    );
  }

  Widget _buildUserResult(Map<String, dynamic> user) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
      ),
      title: Text(user['username'] ?? ''),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(
              useremail: user['email'],
              currentUserEmail: currentUserEmail ?? '',
            ),
          ),
        );
      },
    );
  }

  Future<List<Comments>> fetchComments(String postId) async {
    try {
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('user posts')
          .doc(postId)
          .collection('Comments')
          .get();

      return commentsSnapshot.docs.map((doc) {
        final commentData = doc.data();
        return Comments(
          userProfileImageUrl:
              commentData['UserProfileImageUrl'] as String? ?? '',
          text: commentData['CommentText'] as String? ?? '',
          user: commentData['CommentedBy'] as String? ?? '',
          time: formatData(commentData['CommentTime']),
          imageUrl: null,
        );
      }).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  void performCombinedSearch(String query) {
    // Query users
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: query)
        .get()
        .then((userSnapshot) {
      // Handle user search results
      if (userSnapshot.docs.isNotEmpty) {
        setState(() {
          List<Map<String, dynamic>> usersSearchResults =
              userSnapshot.docs.map((doc) => doc.data()).toList();
        });
        // Update UI with user search results
        // ...
      }
    });

    // Query posts
    FirebaseFirestore.instance
        .collection('user posts')
        .where('Message', isGreaterThanOrEqualTo: query)
        .get()
        .then((postSnapshot) {
      // Handle post search results
      if (postSnapshot.docs.isNotEmpty) {
        setState(() {
          List<Map<String, dynamic>> postsSearchResults =
              postSnapshot.docs.map((doc) => doc.data()).toList();
        });
        // Update UI with post search results
        // ...
      }
    });
  }
}
