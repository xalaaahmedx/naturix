import 'package:flutter/material.dart';

class ShoppingListCard extends StatelessWidget {
  String recommendedItem;
  ShoppingListCard({super.key, required this.recommendedItem});

  @override
  Widget build(BuildContext context) {
    return Card(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(Icons.food_bank_outlined),


            SizedBox(width: 10,),

            Text(recommendedItem),
          ],
        ),
      ),
    );
  }
}
