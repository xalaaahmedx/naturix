import 'package:flutter/material.dart';
import 'package:naturix/screens/chat.dart';
import 'package:naturix/screens/home_page.dart';


import 'package:naturix/widgets/tipcard.dart';
import 'package:naturix/widgets/tips_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class OrganicFetlizersTips extends StatefulWidget {
  const OrganicFetlizersTips({super.key});

  @override
  State<OrganicFetlizersTips> createState() => _OrganicFetlizersTipsState();
}

class _OrganicFetlizersTipsState extends State<OrganicFetlizersTips> {
  List<SwipeItem> _tipCards = [];
  late MatchEngine _matchEngine;
  int _currentIndex = 0;
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
        title: "Separate Edible and Inedible Parts:",
        description:
            "Remove any inedible parts like stickers, bones, or non-organic materials from the spoiled food.",
      ),
      FoodWasteTip(
        title: "Chop or Shred the Spoiled Food",
        description:
            "Cutting or shredding the spoiled food into smaller pieces can speed up the composting process.",
      ),
      FoodWasteTip(
        title: "Combine with Other Compostable Materials",
        description:
            "Combine spoiled food with other compostable materials like yard waste, leaves, straw, or coffee grounds to achieve a balanced mix of nitrogen-rich (greens) and carbon-rich (browns) components in your compost.",
      ),
      FoodWasteTip(
        title: "Maintain a Good Carbon-to-Nitrogen Ratio",
        description:
            "Aim for a good balance between carbon and nitrogen in your compost pile. Generally, a ratio of 25-30 parts carbon to 1 part nitrogen is recommended. Spoiled food provides nitrogen.",
      ),
      FoodWasteTip(
        title: "Aerate the Compost Pile",
        description:
            "Regularly turn or aerate the compost pile to provide oxygen for the microorganisms that break down the organic matter.",
      ),
      FoodWasteTip(
        title: "Keep the Pile Moist",
        description:
            "Maintain proper moisture levels in the compost pile. It should be damp, like a wrung-out sponge, but not waterlogged.",
      ),
      FoodWasteTip(
        title: "Use a Compost Bin or Pile",
        description:
            "You can compost in a designated bin or create a compost pile in your backyard. Compost bins can help contain the material and accelerate the decomposition process.",
      ),
      FoodWasteTip(
          title: 'Cover the Compost Pile',
          description:
              'Covering the compost pile helps retain moisture and regulate temperature. Use a tarp or lid.'),
      FoodWasteTip(
          title: 'Be Patient',
          description:
              'Composting takes time, typically several weeks to a few months. Patience is key.'),
      FoodWasteTip(
          title: 'Avoid Composting Certain Foods',
          description:
              "Avoid composting meat, dairy, or oily foods, as they can attract pests and slow down the composting process. Also, avoid composting diseased plants."),
      FoodWasteTip(
          title: "Harvest and Use Compost",
          description:
              "Once the compost is ready, it will look like dark, crumbly soil. Harvest it and mix it into your garden soil to enhance fertility.")
    ];

    List<Color> tipColors = [
      const Color.fromARGB(255, 80, 217, 227),
      const Color.fromARGB(255, 18, 200, 154),
      const Color.fromARGB(255, 241, 168, 214),
      const Color.fromARGB(255, 198, 139, 240),
      const Color.fromARGB(255, 255, 252, 174),
      const Color.fromARGB(255, 255, 132, 110),
      const Color.fromARGB(255, 74, 208, 191),
      const Color.fromARGB(255, 255, 174, 66),
      Colors.purpleAccent,
      const Color.fromARGB(255, 247, 104, 195),
      const Color.fromARGB(255, 1, 160, 171),
    ];

    List<String> imagePaths = [
      'assets/images/plants.png',
      'assets/images/salad.png',
      'assets/images/tree.png',
      'assets/images/supermarket.png',
      'assets/images/order.png',
      'assets/images/burger.png',
      'assets/images/earth.png',
      'assets/images/Compost-cycle.gif',
      'assets/images/Compost-cycle.gif',
      'assets/images/Compost-cycle.gif',
      'assets/images/Compost-cycle.gif',
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
              height: 650,
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
