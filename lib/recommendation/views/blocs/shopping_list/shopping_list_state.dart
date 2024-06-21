part of 'shopping_list_cubit.dart';

@immutable
abstract class ShoppingListState {}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListSuccess extends ShoppingListState {
  static ShoppingListResponse? shoppingListResponse;

  ShoppingListSuccess(ShoppingListResponse? response){
    ShoppingListSuccess.shoppingListResponse = response;
  }
}

class ShoppingListError extends ShoppingListState {
  static String error = "";

  ShoppingListError(String error){
    ShoppingListError.error = error;
  }
}

class ShoppingListIsLoading extends ShoppingListState {}
