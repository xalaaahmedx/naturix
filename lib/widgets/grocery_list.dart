
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference _groceryItemsCollection =
      FirebaseFirestore.instance.collection('groceryItems');

  late Stream<List<GroceryItem>> _groceryItemsStream;

  @override
  void initState() {
    super.initState();
    _groceryItemsStream = _groceryItemsCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final category = categories.entries
              .firstWhere(
                (catItem) => catItem.value.title == data['category'],
              )
              .value;

          return GroceryItem(
            id: doc.id,
            name: data['name'],
            quantity: data['quantity'],
            category: category,
            isSelected: data['isSelected'] ?? false,
          );
        }).toList();
      },
    );
  }

  Future<void> _removeItem(String itemId) async {
    await _groceryItemsCollection.doc(itemId).delete();
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (newItem == null) {
      return;
    }

    await _groceryItemsCollection.add({
      'name': newItem.name,
      'quantity': newItem.quantity,
      'category': newItem.category.title,
      'isSelected': newItem.isSelected,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroceryItem>>(
      stream: _groceryItemsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final groceryItems = snapshot.data ?? [];

        Widget content = const Center(
          child: Text(
            'Nothing here',
            style: TextStyle(color: Colors.black, fontFamily: 'anekMalayalam'),
          ),
        );

        if (groceryItems.isNotEmpty) {
          content = ListView.builder(
            itemCount: groceryItems.length,
            itemBuilder: (ctx, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Dismissible(
                key: UniqueKey(),
                onDismissed: (_) {
                  _removeItem(groceryItems[index].id);
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
                        groceryItems[index].name,
                        style: TextStyle(
                          decoration: groceryItems[index].isSelected ?? false
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'anekMalayalam',
                          fontSize: 16.0,
                          decorationThickness: 2,
                          decorationColor:
                              const Color.fromARGB(255, 1, 158, 140),
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
                          getCategoryImagePath(groceryItems[index].category),
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: Checkbox(
                        value: groceryItems[index].isSelected ?? false,
                        onChanged: (value) {
                          _groceryItemsCollection
                              .doc(groceryItems[index].id)
                              .update({'isSelected': value});
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
      },
    );
  }
}

// Rest of your code remains unchanged...

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
