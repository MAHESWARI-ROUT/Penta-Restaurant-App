import 'product_model.dart';

class Category {
  final String catId;
  final String categoryName;
  final String categoryImage;
  final List<Product> products;

  Category({
    required this.catId,
    required this.categoryName,
    required this.categoryImage,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catId: json['cat_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      products: (json['products'] is List)
          ? (json['products'] as List)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
