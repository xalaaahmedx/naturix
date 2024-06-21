import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_sizer/flutter_sizer.dart";
import "package:naturix/recommendation/views/blocs/recommendation_cubit.dart";
import "package:naturix/recommendation/views/screens/shopping_list_screen.dart";

import "../components/recommended_recipe_card.dart";

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {

  @override
  void initState() {
    context.read<RecommendationCubit>().recommend("eggs, rice");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      floatingActionButton: FloatingActionButton(

        isExtended: true,
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ShoppingListScreen()));
        },
        child: Icon(Icons.fastfood_outlined),

      ),
      appBar: AppBar(
        title: const Text("Recipe recommendation"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [

          SearchBar(
            hintText: "ingrediants : eggs, rice",
            trailing: [Icon(Icons.search)],
            controller: context
                .read<RecommendationCubit>().searchController,
            onChanged: (_) => context.read<RecommendationCubit>().recommend(context.read<RecommendationCubit>().searchController.text.trim()),
          ),

          SizedBox(height: 10,),

          BlocConsumer<RecommendationCubit, RecommendationState>(
            listener: (context, state) {
              print("state is $state");
            },
            builder: (context, state) {

              if(state is RecommendationIsLoading){
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              else if(state is RecommendationError){
                return Center(child: Text(RecommendationError.error));
              }
              else if(state is RecommendationSuccess) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: RecommendationSuccess.recommendations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecommendedRecipeCard(response: RecommendationSuccess.recommendations[index],);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                );
              }

              else {
                return SizedBox();
              }
            },
          )


        ],
      ),
    ));
  }
}
