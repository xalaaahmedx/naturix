part of 'recommendation_cubit.dart';

@immutable
abstract class RecommendationState {}

class RecommendationInitial extends RecommendationState {}

class RecommendationIsLoading extends RecommendationState {}

class RecommendationSuccess extends RecommendationState {
  static List<RecommendationResponse?> recommendations = [];

  RecommendationSuccess(List<RecommendationResponse?>? recommendations) {
    if(recommendations != null) {
      RecommendationSuccess.recommendations = recommendations;

    }
  }

}

class RecommendationError extends RecommendationState {
  static String error = "";
  RecommendationError(String error){
    RecommendationError.error = error;
  }

}
