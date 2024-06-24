import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naturix/screens/favourites.dart';
import 'package:naturix/screens/tips_toggle.dart';
import 'package:naturix/widgets/grocery_list.dart';
import 'package:naturix/screens/my_profile.dart';
import 'package:naturix/screens/settings.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key, required this.navigateToPage}) : super(key: key);

  final Function(int) navigateToPage;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    currentUser = FirebaseAuth.instance.currentUser!;
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 158, 140),
                Color.fromARGB(255, 2, 165, 146),
                Color.fromARGB(246, 199, 218, 218),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      // Handle the error or absence of data, for now, log out the user
                      signOut();
                      return Container();
                    }

                    final userData = (snapshot.data!
                            as DocumentSnapshot<Map<String, dynamic>>)
                        .data();

                    if (userData == null) {
                      // Handle the case when userData is null, for now, log out the user
                      signOut();
                      return Container();
                    }

                    final username = userData['username'] ?? '';
                    final profileImageUrl = userData['profileImageUrl'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40, // Increased size of the image
                          backgroundImage: NetworkImage(profileImageUrl),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            username,
                            style: const TextStyle(
                              fontSize: 18, // Increased font size
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'anekMalayalam',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    buildDrawerItem(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfile()),
                        );
                      },
                    ),
                    buildDrawerItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()),
                        );
                      },
                    ),
                    buildDrawerItem(
                      icon: Icons.list,
                      title: 'Your List',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GroceryList()),
                        );
                      },
                    ),
                    buildDrawerItem(
                      icon: Icons.lightbulb,
                      title: 'Tips',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ToggleScreen()),
                        );
                      },
                    ),
                    buildDrawerItem(
                      icon: Icons.star,
                      title: 'Favorites',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritesScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              buildDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: signOut,
              ),
            ],
          ),
        ));
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Expanded(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'anekMalayalam',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
