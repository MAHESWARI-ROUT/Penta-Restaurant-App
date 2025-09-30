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
      catId: json['cat_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => Product.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'cat_id': catId,
        'category_name': categoryName,
        'category_image': categoryImage,
        'products': products.map((p) => p.toJson()).toList(),
      };
}

