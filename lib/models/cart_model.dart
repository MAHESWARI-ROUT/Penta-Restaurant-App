class CartItem {
  final String productId;
  final String variantId;
  final String productName;
  final String variantName;
  final String variantPrice;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.variantName,
    required this.variantPrice,
    this.quantity = 1,
    required this.imageUrl,
  });

  double get totalPrice =>
      double.tryParse(variantPrice) != null ? double.parse(variantPrice) * quantity : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'varient_id': variantId,
      'product_name': productName,
      'varient_name': variantName,
      'varient_price': variantPrice,
      'varient_quantity': quantity.toString(),
      'image': imageUrl,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variants = json['variants'] ?? {};
    return CartItem(
      productId: json['productId']?.toString() ?? '',
      variantId: variants['varientid']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      variantName: variants['variantname']?.toString() ?? '',
      variantPrice: variants['varprice']?.toString() ?? '0',
      quantity: int.tryParse(variants['varquantity']?.toString() ?? '1') ?? 1,
      imageUrl: json['primaryimage']?.toString() ?? '',
    );
  }
}
