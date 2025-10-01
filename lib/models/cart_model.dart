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

  double get totalPrice => double.tryParse(variantPrice) != null
      ? double.parse(variantPrice) * quantity
      : 0.0;

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
    return CartItem(
      productId: json['product_id'] ?? '',
      variantId: json['varient_id'] ?? '',
      productName: json['product_name'] ?? '',
      variantName: json['varient_name'] ?? '',
      variantPrice: json['varient_price'] ?? '0',
      quantity: int.tryParse(json['varient_quantity'] ?? '1') ?? 1,
      imageUrl: json['image'] ?? '',
    );
  }
}
