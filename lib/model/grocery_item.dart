import 'package:naturix/model/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;
  bool isSelected; // New property for selection

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isSelected = false, // Default value for isSelected
  });
}
