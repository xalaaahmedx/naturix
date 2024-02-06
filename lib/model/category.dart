
enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  final String title;
  final String iconPath; // Image path for the icon

  const Category(
    this.title,
    this.iconPath,
  );
}
