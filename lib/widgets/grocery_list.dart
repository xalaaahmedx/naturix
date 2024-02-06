import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:naturix/data/categories.dart';
import 'package:naturix/model/category.dart';
import 'package:naturix/model/grocery_item.dart';
import 'package:naturix/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'naturix-e6bf7-default-rtdb.firebaseio.com',
      'naturix.json',
    );

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (response.body.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final Map<String, dynamic> listData = json.decode(response.body);
      List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
            isSelected: item.value['isSelected'] ?? false,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error decoding JSON: $error');
    }
  }

  Future<void> _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    final url = Uri.https(
      'naturix-e6bf7-default-rtdb.firebaseio.com',
      'naturix/${item.id}.json',
    );
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        _groceryItems.removeAt(index);
      });
    } else {
      // Handle error, maybe show a snackbar or alert dialog
      print('Error deleting item. Status code: ${response.statusCode}');
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'Nothing here',
        style: TextStyle(color: Colors.black, fontFamily: 'anekMalayalam'),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (_) {
              _removeItem(_groceryItems[index]);
            },
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: InkWell(
              onTap: () {
                // Add your onTap logic here
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(
                    _groceryItems[index].name,
                    style: TextStyle(
                      decoration: _groceryItems[index].isSelected ?? false
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'anekMalayalam',
                      fontSize: 16.0,
                      decorationThickness: 2,
                      decorationColor: const Color.fromARGB(255, 1, 158, 140),
                      color: Colors.black,
                    ),
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      getCategoryImagePath(_groceryItems[index].category),
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing: Checkbox(
                    value: _groceryItems[index].isSelected ?? false,
                    onChanged: (value) {
                      setState(() {
                        _groceryItems[index].isSelected = value ?? false;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 1, 158, 140),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text(
          'My List',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'anekMalayalam',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            color: Colors.black,
          ),
        ],
      ),
      body: content,
    );
  }
}

String getCategoryImagePath(Category category) {
  switch (category.title) {
    case 'Vegetables':
      return 'assets/icons/vegetables.png';
    case 'Fruit':
      return 'assets/icons/healthy-food.png';
    case 'Meat':
      return 'assets/icons/barbecue.png';
    case 'Dairy':
      return 'assets/icons/milk.png';
    case 'Carbs':
      return 'assets/icons/bread.png';
    case 'Sweets':
      return 'assets/icons/cupcake.png';
    case 'Spices':
      return 'assets/icons/spices.png';
    case 'Convenience':
      return 'assets/icons/groceries.png';
    case 'Hygiene':
      return 'assets/icons/shampoo.png';
    case 'Other':
      return 'assets/icons/other.png';
    default:
      return 'assets/icons/other.png';
  }
}
