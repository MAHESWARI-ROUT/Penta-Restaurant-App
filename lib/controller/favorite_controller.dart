import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/models/product_model.dart';
import '../services/dio_client.dart'; // Assuming you have a DioClient

class FavoriteController extends GetxController {
  final RxList<Product> favorites = <Product>[].obs;
  final dio = DioClient().dio;

  // Call backend to add item to wishlist
  Future<bool> addToWishList(String productId, String userId) async {
    try {
      final response = await dio.post(
        '/JSON/addwishlist.php',
        data: {
          'product_id': productId,
          'user_id': userId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      final data = response.data;
      final parsedData = data is String ? json.decode(data) : data;

      return parsedData['success'].toString() == 'true';
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  // Check if product is in wishlist (can be used for sync or verification)
  Future<bool> checkWishList(String productId, String userId) async {
    try {
      final response = await dio.post(
        '/JSON/wishcheck.php',
        data: {
          'product_id': productId,
          'user_id': userId,
        },
      );
      final data = response.data;
      return data['success'].toString() == 'true';
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }

  // Fetch wishlist from backend for the user
  Future<void> fetchWishList(String userId) async {
    try {
      final response = await dio.post(
        '/JSON/wishlist.php',
        data: {
          'user_id': userId,
        },
      );

      final data = response.data;
      if (data['status'] == 'success' && data['products'] != null) {
        // Convert product JSONs in response to Product objects
        final List<Product> loaded = [];
        for (var prodJson in data['products']) {
          loaded.add(Product.fromJson(prodJson));
        }
        favorites.value = loaded;
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    }
  }

  // Toggle favorite status (adds or removes locally and calls backend)
  Future<void> toggleFavorite(Product product, String userId) async {
    final exists = isFavorite(product);

    if (exists) {
      // For remove from favorite, you need to implement appropriate API call if exists,
      // otherwise simply remove locally for now.
      favorites.removeWhere((p) => p.productId == product.productId);
    } else {
      final success = await addToWishList(product.productId, userId);
      if (success) {
        favorites.add(product);
      } else {
        if (Get.isLogEnable) print('Failed to add to wishlist on server');
      }
    }
  }

  bool isFavorite(Product product) {
    return favorites.any((p) => p.productId == product.productId);
  }
}
