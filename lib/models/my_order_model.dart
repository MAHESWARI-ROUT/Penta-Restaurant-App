class MyOrder {
  final String orderId;
  final String cartId;
  final String status;
  final String paymentStatus;
  final String totalAmount;
  final String createdAt;
  final String address;
  final String phone;
  final String paymentMode;
  final String orderRemark;
  final List<OrderProduct> products;

  MyOrder({
    required this.orderId,
    required this.cartId,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.createdAt,
    required this.address,
    required this.phone,
    required this.paymentMode,
    required this.orderRemark,
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
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      paymentMode: json['paymentmode']?.toString() ?? 'Cash on Delivery',
      orderRemark: json['orderremark']?.toString() ?? '',
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
