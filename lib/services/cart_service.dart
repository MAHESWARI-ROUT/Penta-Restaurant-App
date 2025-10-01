import 'dart:convert';
import 'package:dio/dio.dart';
import '../services/dio_client.dart';

class CartService {
  final Dio _dio = DioClient().dio;

  // Add item to cart
  Future<bool> addToCart({
    required String productId,
    required String userId,
    required String variantId,
    required String variantQuantity,
    required String variantName,
    required String variantPrice,
    required String productName,
    String jsonParam = '', // Optional parameter
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/add-cart.php',
        data: FormData.fromMap({
          'product_id': productId,
          'userid': userId,
          'varient_id': variantId,
          'varient_quantity': variantQuantity,
          'json_param': jsonParam,
          'varient_name': variantName,
          'varient_price': variantPrice,
          'product_name': productName,
        }),
      );

      final responseData = json.decode(response.data.toString());
      return responseData['status'] == 'success';
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart({
    required String userId,
    required String variantId,
    required String productId,
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/deletecart.php',
        data: FormData.fromMap({
          'user_id': userId,
          'varient_id': variantId,
          'product_id': productId,
        }),
      );

      final responseData = json.decode(response.data.toString());
      return responseData['status'] == 'success';
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Get user's cart items
  Future<List<dynamic>> getCartItems(String userId) async {
    try {
      final response = await _dio.get(
        '/JSON/cart.php',
        queryParameters: {'user_id': userId}
      );

      final responseData = json.decode(response.data.toString());
      if (responseData['status'] == 'success') {
        return responseData['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }
}
