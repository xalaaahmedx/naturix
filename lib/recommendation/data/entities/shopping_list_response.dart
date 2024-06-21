class ShoppingListResponse {
  List<String>? recommendations;

  ShoppingListResponse({this.recommendations});

  ShoppingListResponse.fromJson(Map<String, dynamic> json) {
    recommendations = json['recommendations'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommendations'] = this.recommendations;
    return data;
  }
}