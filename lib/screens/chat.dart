import 'package:flutter/material.dart';


class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late PageController _pageController;
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200]!,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Add Post'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle the post action here
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 158, 140),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
