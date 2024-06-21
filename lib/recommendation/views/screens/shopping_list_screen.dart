import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naturix/recommendation/views/blocs/shopping_list/shopping_list_cubit.dart';
import 'package:naturix/widgets/widgetss/text_field.dart';
import 'package:typewritertext/typewritertext.dart';

import '../components/item_card.dart';
import '../components/shopping_list_card.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(

        onPressed: ()=> context
            .read<ShoppingListCubit>().recommendShoppingItems(),
        child: Icon(Icons.arrow_upward_sharp),
      ),
      appBar: AppBar(
        title: const Text("Ai shopping list"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 240,
                  height: 60,
                  child: MyTextField(
                    hintText: "Enter last shopping items",
                    controller: context
                        .read<ShoppingListCubit>()
                        .shoppingItemsController,
                    // onSubmitted: (_) => context.read<ShoppingListCubit>().recommendShoppingItems(),
                    obscureText: false,

                  ),
                ),

                FloatingActionButton(

                  onPressed: ()=> context
                      .read<ShoppingListCubit>().add(),
                  child: Icon(Icons.add),
                )

              ],
            ),
          ),
          SizedBox(height: 20,),

          BlocBuilder<ShoppingListCubit, ShoppingListState>(
            builder: (context, state) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemCount: context
                      .read<ShoppingListCubit>()
                      .items
                      .length,
                  itemBuilder: (context, index) {
                    return ItemCard(recommendedItem: context
                        .read<ShoppingListCubit>()
                        .items[index],
                      onTap: ()=> context
                          .read<ShoppingListCubit>().remove(index),
                    );
                  }
              );
            },
          ),
          SizedBox(height: 20,),

          BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, state) {
                if (state is ShoppingListIsLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                else if (state is ShoppingListSuccess) {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 20,),

                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                Icon(Icons.smart_toy_outlined, size: 30,),

                                SizedBox(width: 2,),

                                Icon(Icons.chat, size: 15,),

                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            width: 250,
                            child: TypeWriter.text(
                              'This what i think you should buy these are the items that you may need \n ',
                              duration: const Duration(milliseconds: 50),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),

                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ShoppingListSuccess.shoppingListResponse
                              ?.recommendations?.length ?? 0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ShoppingListCard(
                              recommendedItem: ShoppingListSuccess
                                  .shoppingListResponse
                                  ?.recommendations?[index] ?? '',);
                          }),
                    ],
                  );
                }
                else if (state is ShoppingListError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: Text(ShoppingListError.error)),
                  );
                } else {
                  return Column(
                    children: [

                      SizedBox(height: 75),
                      CircleAvatar(
                        radius: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Icon(Icons.smart_toy_outlined, size: 60,),

                            Icon(Icons.fastfood_outlined, size: 40,),


                          ],
                        ),
                      ),
                      SizedBox(height: 30,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Text(
                          "This ai assistant will help you find the items you could realy want or need in the future ",
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 100,),

                    ],
                  );
                }
              }
          )


        ],
      ),
    );
  }
}
