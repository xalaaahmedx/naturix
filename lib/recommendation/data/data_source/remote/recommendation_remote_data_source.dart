import 'package:dio/dio.dart';
import 'package:naturix/recommendation/data/entities/shopping_list_response.dart';

import '../../entities/recommendation_response.dart';

abstract class RecommendationRemoteDataSource {
  Future<List<RecommendationResponse?>> recommendRecipe(String ingredients);

  Future<ShoppingListResponse?> shoppingList(String lastPurchaseItems);

}



class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {


  @override
  Future<List<RecommendationResponse?>> recommendRecipe(String ingredients) async {
    try {

      final data = {
        "ingredients" : ingredients
      } ;

      Response response = await  Dio().post(
          "https://recipe-recommender-w5nk.onrender.com/recommend_recipes",
          data: data
      );

      if(response.statusCode != 200){
        throw Exception("This status code is : ${response.statusCode}");
      }

      List responseData =  response.data;

      print(response.data);

      return responseData.map((item) => RecommendationResponse.fromJson(item)).toList();


    } catch(error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<ShoppingListResponse?> shoppingList(String lastPurchaseItems) async {
    try {

      final data = {
        "last_purchase_history" : lastPurchaseItems
      };

      Response response = await Dio().post(
          "https://shopping-list-tetx.onrender.com/recommendations/",
          data: data
      );
      // print("runtimeType  >>>>>>>>>>>>> "+ response.data.toString());
      //
      // Map<String,dynamic> responseData =  response.data;
      //
      // print("data from responseeeeeeee >>>>>>>>>>>>> "+response.data);

      return ShoppingListResponse.fromJson(response.data);


    } catch(error) {
      print(error.toString());
      throw Exception(error.toString());
    }
  }

}

