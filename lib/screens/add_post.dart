import 'package:flutter/material.dart';
import 'package:naturix/screens/add_post_screen.dart';
import 'package:naturix/screens/add_reels.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

int currentIndex = 0;

class _AddPostState extends State<AddPost> {
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
      body: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              AddPostScreen(),
              AddReelsScreen(),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 10,
            right: currentIndex == 0 ? 100 : 150,
            child: Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 165, 146).withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => navigationTapped(0),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == 0
                              ? Colors.white
                              : Color.fromARGB(255, 135, 247, 215),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigationTapped(1),
                      child: Text(
                        'Reels',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == 1
                              ? Colors.white
                              : Color.fromARGB(255, 135, 247, 215),
                        ),
                      ),
                    ),
                  ]),
            ),
          )
        ],
      )),
    );
  }
}
