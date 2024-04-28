import 'package:flutter/material.dart';

import 'package:naturix/widgets/tipcard.dart';
import 'package:naturix/widgets/tips_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class FoodWasteTipsScreen extends StatefulWidget {
  const FoodWasteTipsScreen({Key? key}) : super(key: key);

  @override
  _FoodWasteTipsScreenState createState() => _FoodWasteTipsScreenState();
}

class _FoodWasteTipsScreenState extends State<FoodWasteTipsScreen> {
  List<SwipeItem> _tipCards = [];
  late MatchEngine _matchEngine;
  final int _currentIndex = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _initializeTipCards();
    _matchEngine = MatchEngine(swipeItems: _tipCards);
  }

  void _initializeTipCards() {
    List<FoodWasteTip> tips = [
      FoodWasteTip(
        title: "Plan Your Meals",
        description: "Plan your meals for the week to buy only what you need.",
      ),
      FoodWasteTip(
        title: "Check Expiry Dates",
        description:
            "Regularly check the expiry dates of your perishable items.",
      ),
      FoodWasteTip(
        title: "Use Leftovers Creatively",
        description: "Get creative with leftovers to minimize food waste.",
      ),
      FoodWasteTip(
        title: "Store Food Properly",
        description: "Store food properly to keep them fresh for longer.",
      ),
      FoodWasteTip(
        title: "Donate Excess Food",
        description: "Donate excess food to those in need.",
      ),
      FoodWasteTip(
        title: "Compost Food Scraps",
        description: "Compost food scraps to reduce food waste.",
      ),
      FoodWasteTip(
        title: "Mindful Eating Out",
        description: "When dining out, order only what you can finish",
      ),
    ];

    List<Color> tipColors = [
      const Color.fromARGB(255, 80, 217, 227),
      const Color.fromARGB(255, 18, 200, 154),
      Color.fromARGB(255, 232, 110, 187),
      const Color.fromARGB(255, 198, 139, 240),
      const Color.fromARGB(255, 255, 160, 183),
      const Color.fromARGB(255, 255, 132, 110),
      const Color.fromARGB(255, 74, 208, 191),
    ];

    List<String> imagePaths = [
      'assets/images/Reminders.gif',
      'assets/images/Poke-bowl-bro.png',
      'assets/images/Compost-cycle.gif',
      'assets/images/Online-Groceries.gif',
      'assets/images/healthy-food.gif',
      'assets/images/Delivery-pana.png',
      'assets/images/MotherEarth.png',
    ];

    if (tips.length == tipColors.length && tips.length == imagePaths.length) {
      _tipCards = tips
          .asMap()
          .entries
          .map((entry) => SwipeItem(
                content: TipCard(
                  title: entry.value.title,
                  description: entry.value.description,
                  color: tipColors[entry.key],
                  fontFamily: 'anekMalayalam',
                  image: AssetImage(
                    imagePaths[entry.key],
                  ),
                ),
                likeAction: () {},
                nopeAction: () {},
              ))
          .toList();
    } else {
      print('Mismatch in lengths of tips, tipColors, and imagePaths lists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tips'),
        titleTextStyle: const TextStyle(
          fontFamily: 'anekMalayalam',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 25,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  if (_finished) {
                    return _buildFinishedMessage();
                  } else {
                    final adjustedIndex =
                        (_currentIndex + index) % _tipCards.length;
                    return _tipCards[adjustedIndex].content;
                  }
                },
                itemChanged: (SwipeItem item, int index) {
                  print('Current card index: $index');
                  if (index == 0) {
                    print('First card is shown');
                  } else if (index == _tipCards.length - 1) {
                    print('Last card is shown');
                    // Reshuffle when reaching the last card
                  } else {
                    print('Card at index $index is shown');
                  }
                },
                leftSwipeAllowed: true,
                fillSpace: true,
                onStackFinished: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You have finished all tips!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _finished = false;
              });
            },
            child: const Text('Restart Tips'),
          ),
        ],
      ),
    );
  }
}
