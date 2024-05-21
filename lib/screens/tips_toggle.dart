import 'package:flutter/material.dart';
import 'package:naturix/screens/tips.dart';
import 'package:naturix/screens/organic_fertlizers_tips.dart';

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({super.key});

  @override
  _ToggleScreenState createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double containerHeight = (screenSize.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top) /
            2 -
        40; // Subtracting app bar height and padding

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          'Tips',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'anekMalayalam',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Adjusted alignment
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FoodWasteTipsScreen(),
                  ),
                );
              },
              child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          'assets/images/org_tips.jpeg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.transparent,
                      child: const Text(
                        'Food Waste Tips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganicFetlizersTips(),
                  ),
                );
              },
              child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          'assets/images/tips22.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.transparent,
                      child: const Text(
                        'Organic Fertilizer Tips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
