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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName'] ?? '',
      status: json['status'] ?? '',
      primaryImage: json['primaryimage'] ?? '',
      description: json['description'] ?? '',
      plimit: json['plimit'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((v) => Variant.fromJson(v))
          .toList(),
      extra: json['extra'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'status': status,
        'primaryimage': primaryImage,
        'description': description,
        'plimit': plimit,
        'images': images,
        'variants': variants.map((v) => v.toJson()).toList(),
        'extra': extra,
      };
}

class Variant {
  final String varientId;
  final String variantName;
  final String varPrice;

  Variant({
    required this.varientId,
    required this.variantName,
    required this.varPrice,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      varientId: json['varientid']?.toString() ?? '',
      variantName: json['variantname'] ?? '',
      varPrice: json['varprice']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'varientid': varientId,
        'variantname': variantName,
        'varprice': varPrice,
      };
}
