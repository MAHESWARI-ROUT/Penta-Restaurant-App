class OrderResponse {
  final bool success;
  final String message;
  final List<MyOrder> orders;

  OrderResponse({
    required this.success,
    required this.message,
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var ordersList = <MyOrder>[];
    if (json['orderdata'] != null) {
      ordersList = (json['orderdata'] as List)
          .map((item) => MyOrder.fromJson(item))
          .toList();
    }
    return OrderResponse(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['message']?.toString() ?? '',
      orders: ordersList,
    );
  }
}

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
    if (json['varients'] != null) {
      productList = (json['varients'] as List)
          .map((item) => OrderProduct.fromJson(item))
          .toList();
    }

    return MyOrder(
      orderId: json['orderid']?.toString() ?? '',
      cartId: '',  // no cart_id provided in JSON, leave empty if unknown
      status: json['status']?.toString() ?? '',
      paymentStatus: json['paymentstatus']?.toString() ?? '',
      totalAmount: json['total']?.toString() ?? '0',
      createdAt: json['orderdate']?.toString() ?? '',
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
      productName: json['productname']?.toString() ?? '',
      variantName: json['variantname']?.toString() ?? '',
      quantity: int.tryParse(json['varquantity']?.toString() ?? '0') ?? 0,
      price: json['varprice']?.toString() ?? '0',
    );
  }
}
