import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../data/data_source/remote/recommendation_remote_data_source.dart';
import '../../data/entities/recommendation_response.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit() : super(RecommendationInitial());

   TextEditingController searchController = TextEditingController();




   Future<void> recommend(String query) async {

       emit(RecommendationIsLoading());
       await RecommendationRemoteDataSourceImpl().recommendRecipe(query).then(
               (value) {
                 emit(RecommendationSuccess(value));

               }).catchError(
               (onError){
                 emit(RecommendationError(onError.toString()));

               });


  }
}
