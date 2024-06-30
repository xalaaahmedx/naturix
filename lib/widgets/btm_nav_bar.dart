import 'package:flutter/material.dart';
import 'package:naturix/screens/add_post_screen.dart';
import 'package:naturix/screens/chat/chat_home.dart';
import 'package:naturix/screens/favourites.dart';
import 'package:naturix/screens/home_page.dart';

import 'package:naturix/screens/search.dart';
import 'package:naturix/screens/organization_home.dart'; // Import necessary screens

import '../recommendation/views/screens/recommendation_screen.dart';

class BtmNavBar extends StatefulWidget {
  final String role;
  const BtmNavBar({required this.role, super.key});

  @override
  State<BtmNavBar> createState() => _BtmNavBarState();
}

class _BtmNavBarState extends State<BtmNavBar> {
  late PageController pageController;
  int currentIndex = 0; // Move currentIndex inside the state

  @override
  void dispose() {
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

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Color _getNavBarBackgroundColor(String role) {
    switch (role) {
      case 'User':
        return Colors.blue;
      case 'Organization':
        return Colors.green;
      case 'Restaurant':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _buildScreensBasedOnRole(widget.role), // Pass the role
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: navigationTapped,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        backgroundColor:
            _getNavBarBackgroundColor(widget.role), // Pass the role
        selectedItemColor: Color.fromARGB(255, 1, 158, 140),
        unselectedItemColor: Colors.grey,
        items:
            _buildNavigationBarItemsBasedOnRole(widget.role), // Pass the role
      ),
    );
  }

  List<Widget> _buildScreensBasedOnRole(String role) {
    // Depending on the role, return different sets of screens
    // Adjust this logic based on your actual screen setup
    switch (role) {
      case 'User':
        return [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          RecommendationScreen(),
          HomePage(),
        ];
      case 'Organization':
        return [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          RecommendationScreen(),
          HomePage(),
        ];
      case 'Restaurant':
        return [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          RecommendationScreen(),
          HomePage(),
        ];
      default:
        return [
          HomePageScreen(),
          SearchScreen(),
          AddPostScreen(),
          RecommendationScreen(),
          HomePage(),
        ];
    }
  }

  List<BottomNavigationBarItem> _buildNavigationBarItemsBasedOnRole(
      String role) {
    // Depending on the role, return different sets of navigation items
    // Adjust this logic based on your actual navigation requirements
    switch (role) {
      case 'User':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Recommend'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ];
      case 'Organization':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Recommend'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ];
      case 'Restaurant':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Recommend'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ];
      default:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Recommend'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ];
    }
  }
}
