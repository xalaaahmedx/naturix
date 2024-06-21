import 'package:flutter/material.dart';

import '../../data/entities/recommendation_response.dart';
import '../screens/single_recommendation_screen.dart';

class RecommendedRecipeCard extends StatelessWidget {
  RecommendationResponse? response;
   RecommendedRecipeCard({super.key,required this.response});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> SingleRecommendationScreen(response : response))),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              fit: BoxFit.fitWidth,
              response?.recipeImage ?? "",
              width: 400,
              height: 250,
            ),

            SizedBox(height: 15,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // response.recipeName
                    response?.recipeName ?? 'Unknown recipe',
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 158, 140),
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 5,),

                  Text(
                    // response.recipeName
                    response?.instructions ?? 'Unknown recipe',
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,

                    ),
                    maxLines: 2,
                      overflow : TextOverflow.ellipsis
                  ),

                  SizedBox(height: 5,),


                  Wrap(
                    children: List.generate(response?.ingredients?.length ?? 0, (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        backgroundColor: Color.fromARGB(255, 1, 158, 140),
                        label: Text(response?.ingredients?[index] ?? "",style: TextStyle(
                            fontSize: 13,
                          color : Colors.white
                        ),),
                          side : BorderSide(color : Colors.transparent),
                      ),

                    )),
                  ),
                  SizedBox(height: 10,),

                ],
              ),
            )



          ],
        )
      ),
    );
  }
}
