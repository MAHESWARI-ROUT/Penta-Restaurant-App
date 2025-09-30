// lib/models/product_model.dart

class Product {
  final String productId;
  final String productName;
  final String status;
  final String primaryImage;
  final String description;
  final String plimit;
  final List<String> images;
  final List<Variant> variants;
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

  // UPDATED: This factory is now more robust against bad API data.
  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesFromJson = json['images'];
    var variantsFromJson = json['variants'];
    var extraFromJson = json['extra'];

    // Safely create lists. If the data is not a list, it will create an empty one.
    List<String> imagesList = (imagesFromJson is List)
        ? List<String>.from(imagesFromJson)
        : [];

    List<Variant> variantsList = (variantsFromJson is List)
        ? variantsFromJson.map((v) => Variant.fromJson(v)).toList()
        : [];

    List<dynamic> extraList = (extraFromJson is List)
        ? List<dynamic>.from(extraFromJson)
        : [];

    return Product(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName'] ?? '',
      status: json['status'] ?? 'available',
      primaryImage: json['primaryimage'] ?? '',
      description: json['description'] ?? '',
      plimit: json['plimit'] ?? '0',
      images: imagesList,
      variants: variantsList,
      extra: extraList,
    );
  }
}

class Variant {
  final String varId;
  final String variantName;
  final String varPrice;

  Variant({
    required this.varId,
    required this.variantName,
    required this.varPrice,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      varId: json['varientid']?.toString() ?? '',
      variantName: json['variantname'] ?? '',
      varPrice: json['varprice']?.toString() ?? '0',
    );
  }
}
