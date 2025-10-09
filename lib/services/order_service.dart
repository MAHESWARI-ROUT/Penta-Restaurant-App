import 'dart:convert'; 
import 'package:dio/dio.dart';
import 'package:penta_restaurant/models/order_response.dart';
import 'package:penta_restaurant/services/dio_client.dart';

import '../models/my_order_model.dart';

class OrderService {
  final Dio _dio = DioClient().dio;

  Future<OrderResponse?> getMyOrders(String userId) async {
    try {
      final response = await _dio.post(
        '/JSON/vieworders.php',
        data: FormData.fromMap({'user_id': userId}),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data is String
          ? json.decode(response.data)
          : response.data;
      return OrderResponse.fromJson(data);

    } catch (e) {
      print('Error fetching my orders: $e');
      return null;
    }
  }

  Future<OrderResponse?> getMyAssignOrders(String userId) async {
    try {
      final response = await _dio.post(
        '/JSON/viewassignorders.php',
        data: FormData.fromMap({'user_id': userId}),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data is String
          ? json.decode(response.data)
          : response.data;
      return OrderResponse.fromJson(data);

    } catch (e) {
      print('Error fetching assigned orders: $e');
      return null;
    }
  }

  Future<OrderResponse?> addOrder({
    required String userId,
    required String cartId,
    required String address,
    required String phone,
    required String paymentRef,
    required String payStatus,
    required String total,
    required String paymentMode,
    required String orderRemark,
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/addorders.php',
        data: FormData.fromMap({
          'user_id': userId,
          'cart_id': cartId,
          'address': address,
          'phone': phone,
          'paymentref': paymentRef,
          'paystatus': payStatus,
          'total': total,
          'paymentmode': paymentMode,
          'orderremark': orderRemark,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data is String
          ? json.decode(response.data)
          : response.data;
      return OrderResponse.fromJson(data);

    } catch (e) {
      print('Error adding order: $e');
      return null;
    }
  }
}