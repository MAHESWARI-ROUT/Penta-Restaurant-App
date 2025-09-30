class Product {
  final String productId;
  final String productName;
  final String status;
  final String primaryImage;
  final String description;
  final String plimit;
  final List<String> images;
  final List<VariantModel> variants;
  final List<dynamic> extra;

  Product({
    required this.productId,
    required this.productName,
    required this.status,
    required this.primaryImage,
    required this.description,
    required this.plimit,
    required this.images,
    required this.variants,
    required this.extra,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Debug prints to catch inconsistent types
    print('Parsing product ID: ${json['productId']}');
    print('Images type: ${json['images']?.runtimeType}');
    print('Variants type: ${json['variants']?.runtimeType}');
    print('Extra type: ${json['extra']?.runtimeType}');

    List<String> images = [];
    if (json['images'] is List) {
      images = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['images'] is String && json['images'].trim().isNotEmpty) {
      images = [json['images']];
    }

    List<VariantModel> variants = [];
    if (json['variants'] is List) {
      variants = (json['variants'] as List)
          .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<dynamic> extra = [];
    if (json['extra'] is List) {
      extra = json['extra'];
    } else if (json['extra'] is String && (json['extra'] as String).trim().isNotEmpty) {
      extra = [json['extra']];
    }

    return Product(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      status: json['status'] ?? '',
      primaryImage: json['primaryimage'] ?? '',
      description: json['description'] ?? '',
      plimit: json['plimit'] ?? '',
      images: images,
      variants: variants,
      extra: extra,
    );
  }
}
class VariantModel {
  final String variantId;
  final String variantName;
  final String varPrice;

  VariantModel({
    required this.variantId,
    required this.variantName,
    required this.varPrice,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      variantId: json['varientid'] ?? '',
      variantName: json['variantname'] ?? '',
      varPrice: json['varprice'] ?? '',
    );
  }
}
