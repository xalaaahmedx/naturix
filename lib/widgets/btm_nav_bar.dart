import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:naturix/screens/add_post_screen.dart';
import 'package:naturix/screens/chat/chat_home.dart';

import 'package:naturix/screens/home_page.dart';

import 'package:naturix/screens/favourites.dart';
import 'package:naturix/screens/search.dart';

import '../recommendation/views/screens/recommendation_screen.dart';

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
      backgroundColor: Colors.grey[100],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          RecommendationScreen(),
          HomePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: navigationTapped,
        selectedIndex: currentIndex,
        destinations: [


          NavigationDestination(

            icon: Icon(Icons.home),
              label: "home"

          ),
          NavigationDestination(
            icon: Icon(Icons.search),
              label: "search"

          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle),
              label: "create"

          ),
          NavigationDestination(
            icon: Icon(Icons.recommend),
              label: "recommend"

          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: "chat"
          ),
        ],)
    );
  }
}


