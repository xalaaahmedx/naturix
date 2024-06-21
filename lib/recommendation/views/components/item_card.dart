import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  String recommendedItem;
  void Function()? onTap;
  ItemCard({super.key, required this.recommendedItem,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              children: [
                Icon(Icons.fastfood_outlined),

                SizedBox(width: 10,),

                Text(recommendedItem),
              ],
            ),




            InkWell(
                onTap: onTap,
                child: Icon(Icons.delete_outline_rounded
            )),

          ],
        ),
      ),
    );
  }
}
