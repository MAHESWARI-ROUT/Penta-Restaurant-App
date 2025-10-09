import 'my_order_model.dart';

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