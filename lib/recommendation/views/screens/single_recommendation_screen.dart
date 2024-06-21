import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:naturix/recommendation/data/entities/recommendation_response.dart";
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SingleRecommendationScreen extends StatefulWidget {
  RecommendationResponse? response;

  SingleRecommendationScreen( {super.key,this.response,});

  @override
  State<SingleRecommendationScreen> createState() => _SingleRecommendationScreenState();
}

class _SingleRecommendationScreenState extends State<SingleRecommendationScreen> {

  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController:
        VideoPlayerController.networkUrl(Uri.parse(widget.response?.recipeVideo ?? ""),
    ));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("recipe"),
      ),
      body: ListView(
        children: [
//        padding: EdgeInsets.symmetric(horizontal: 20),

          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            child: Image.network(
              fit: BoxFit.fitWidth,
              widget.response?.recipeImage ?? "",
              width: double.infinity,
              height: 250,
            ),
          ),

          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.response?.recipeName?? "",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 1, 158, 140)


            ),),
          ),

          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Ingredients",style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 1, 158, 140)

            ),),
          ),
          SizedBox(height: 10,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              children: List.generate(widget.response?.ingredients?.length ?? 0, (index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: RawChip(
                  backgroundColor: Color.fromARGB(255, 1, 158, 140),
                  label: Text(widget.response?.ingredients?[index] ?? "",style: TextStyle(
                      fontSize: 13,
                      color : Colors.white
                  ),),
                  side : BorderSide(color : Colors.transparent),
                ),

              )),
            ),
          ),
          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Food Nutrition",style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 1, 158, 140)
            ),),
          ),

          SizedBox(height: 10,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("🔹Proten : ${widget.response?.protein}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)

                  ),),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("🔹Fat : ${widget.response?.fat}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)

                  ),),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("🔹Calories : ${widget.response?.calories}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)

                  ),),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("🔹Sugar : ${widget.response?.sugar}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)

                  ),),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("🔹Carbohydrates : ${widget.response?.carbohydrates}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)

                  ),),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("🔹Fiber : ${widget.response?.fiber}",style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)
                  ),),
                ),
              ],
            ),
          ),



          SizedBox(height: 30,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Instructions",style: TextStyle(
                fontSize: 25,
              fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 1, 158, 140)

            ),),
          ),
          SizedBox(height: 10,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("${widget.response?.instructions}",style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 1, 158, 140).withOpacity(0.5)
            ),),
          ),

          SizedBox(height: 30,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Recipe video",style: TextStyle(
                color: Color.fromARGB(255, 1, 158, 140),
                fontSize: 25,
                fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FlickVideoPlayer(
                flickManager: flickManager
            ),
          ),

          SizedBox(height: 50,),

        ],
      ),
    );
  }
}
