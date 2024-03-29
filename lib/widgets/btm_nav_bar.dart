import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:naturix/screens/add_post_screen.dart';
import 'package:naturix/screens/chat.dart';
import 'package:naturix/screens/chat/chat_home.dart';

import 'package:naturix/screens/home_page.dart';

import 'package:naturix/screens/favourites.dart';
import 'package:naturix/screens/search.dart';

class BtmNavBar extends StatefulWidget {
  const BtmNavBar({super.key});

  @override
  State<BtmNavBar> createState() => _BtmNavBarState();
}

int currentIndex = 0;

class _BtmNavBarState extends State<BtmNavBar> {
  late PageController pageController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      currentIndex = page;
    });
  }

  navigationTapped(int page) {
    // Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100]!,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          FavoritesScreen(),
          HomePage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[100]!,
        color: Color.fromARGB(255, 1, 158, 140),
        items: const [
          Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.add_circle, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.chat, color: Colors.white),
        ],
        onTap: navigationTapped,
        index: currentIndex,
      ),
    );
  }
}
