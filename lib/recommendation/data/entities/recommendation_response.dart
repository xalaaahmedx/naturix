class RecommendationResponse {
  String? recipeImage;
  String? recipeName;
  List<String>? ingredients;
  num? protein;
  num? fat;
  num? calories;
  num? sugar;
  num? carbohydrates;
  num? fiber;
  String? instructions;
  String? recipeVideo;

  RecommendationResponse(
      {this.recipeImage,
        this.recipeName,
        this.ingredients,
        this.protein,
        this.fat,
        this.calories,
        this.sugar,
        this.carbohydrates,
        this.fiber,
        this.instructions,
        this.recipeVideo});

  RecommendationResponse.fromJson(Map<String, dynamic> json) {
    recipeImage = json['recipe_image'];
    recipeName = json['recipe_name'];
    ingredients = json['ingredients'].cast<String>();
    protein = json['protein'];
    fat = json['fat'];
    calories = json['calories'];
    sugar = json['sugar'];
    carbohydrates = json['carbohydrates'];
    fiber = json['fiber'];
    instructions = json['instructions'];
    recipeVideo = json['recipe_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipe_image'] = this.recipeImage;
    data['recipe_name'] = this.recipeName;
    data['ingredients'] = this.ingredients;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['calories'] = this.calories;
    data['sugar'] = this.sugar;
    data['carbohydrates'] = this.carbohydrates;
    data['fiber'] = this.fiber;
    data['instructions'] = this.instructions;
    data['recipe_video'] = this.recipeVideo;
    return data;
  }
}