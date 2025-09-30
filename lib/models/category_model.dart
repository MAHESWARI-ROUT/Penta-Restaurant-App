import 'package:penta_restaurant/models/product_model.dart';

class Category {
  final String catId;
  final String categoryName;
  final String categoryImage;
  final List<Product> products; // This list will now be populated by the controller

  Category({
    required this.catId,
    required this.categoryName,
    required this.categoryImage,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'];
    List<Product> productList = [];

    if (productsJson != null && productsJson is List) {
      productList = productsJson.map((p) => Product.fromJson(p)).toList();
    }

    return Category(
      catId: json['cat_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      products: productList,
    );
  }
}