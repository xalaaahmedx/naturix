import 'package:flutter/material.dart';

class IntroPageOne extends StatefulWidget {
  const IntroPageOne({super.key});

  @override
  State<IntroPageOne> createState() => _IntroPageOneState();
}

class _IntroPageOneState extends State<IntroPageOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Image.asset(
                'assets/images/bear.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Color.fromARGB(255, 225, 244, 237),
              ),
              alignment: const Alignment(0, 0.5),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20), // Adjust the left padding
                    child: Text(
                      'GOALS',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'anekMalayalam',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20), // Adjust the left padding
                    child: Text(
                      'The most important goal is to reduce the amount of wasted food by donating your surplus or selling it through our application.',
                      style: TextStyle(
                        fontFamily: 'anekMalayalam',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 113, 118, 118),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
