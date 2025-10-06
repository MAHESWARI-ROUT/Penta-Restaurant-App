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
      return responseData['success'].toString() == 'true';
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
      return responseData['success']?.toString().toLowerCase() == 'true';
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Get user's cart items
  Future<List<dynamic>> getCartItems(String userId) async {
    try {
      final response = await _dio.post(
        '/JSON/viewcart.php',
        data: FormData.fromMap({
          'user_id': userId,
        }),
      );

      final responseData = json.decode(response.data.toString());
      if (responseData['success']?.toString().toLowerCase() == 'true') {
        return responseData['products'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }
}
