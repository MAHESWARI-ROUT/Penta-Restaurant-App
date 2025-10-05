class MyOrder {
  final String orderId;
  final String cartId;
  final String status;
  final String paymentStatus;
  final String totalAmount;
  final String createdAt;
  final List<OrderProduct> products;

  MyOrder({
    required this.orderId,
    required this.cartId,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.createdAt,
    required this.products,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    var productList = <OrderProduct>[];
    if (json['products'] != null) {
      productList = (json['products'] as List)
          .map((item) => OrderProduct.fromJson(item))
          .toList();
    }

    return MyOrder(
      orderId: json['order_id']?.toString() ?? '',
      cartId: json['cart_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      totalAmount: json['total']?.toString() ?? '0',
      createdAt: json['created_at']?.toString() ?? '',
      products: productList,
    );
  }
}

class OrderProduct {
  final String productId;
  final String productName;
  final String variantName;
  final int quantity;
  final String price;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.variantName,
    required this.quantity,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      variantName: json['variant_name']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: json['price']?.toString() ?? '0',
    );
  }
}
