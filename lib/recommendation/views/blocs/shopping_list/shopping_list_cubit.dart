import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:naturix/recommendation/data/entities/shopping_list_response.dart';

import '../../../data/data_source/remote/recommendation_remote_data_source.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ShoppingListInitial());

  TextEditingController shoppingItemsController = TextEditingController();

  List<String> items = [];

  add(){
    emit(ShoppingListIsLoading());
    items.add(shoppingItemsController.text);
    shoppingItemsController.text = "";
    print(items);
    emit(ShoppingListInitial());
  }

  remove(int index){
    emit(ShoppingListIsLoading());
    items.removeAt(index);
    emit(ShoppingListInitial());
  }



  recommendShoppingItems()async {

    print(items.join(","));

    emit(ShoppingListIsLoading());
    await RecommendationRemoteDataSourceImpl().shoppingList(items.join(","))
    .then((value) {
      emit(ShoppingListSuccess(value));
    })
    .catchError((error) {
      emit( ShoppingListError(error.toString()));
    });
  }
}
