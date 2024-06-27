import 'package:flutter/material.dart';
import 'package:naturix/intro_screens/intro_page_2.dart';
import 'package:naturix/intro_screens/intro_page_3.dart';
import 'package:naturix/intro_screens/intro_page_4.dart';
import 'package:naturix/intro_screens/intropage_1.dart';
import 'package:naturix/screens/login_page.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreens> {
  final _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                onLastPage = value == 3;
              });
            },
            controller: _controller,
            children: const [
              IntroPageOne(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: const WormEffect(
                    activeDotColor: Color.fromARGB(255, 1, 158, 140),
                    dotColor: Color.fromARGB(255, 149, 148, 148),
                    dotHeight: 5,
                    dotWidth: 20,
                    spacing: 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    onLastPage ? 'Start' : 'Skip',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 2, 165, 146),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
