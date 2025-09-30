import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/category_model.dart';

import '../models/product_model.dart';
import 'dio_client.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  // Future<List<Category>> getCategoryList() async {
  //   final response = await _dio.get('/JSON/pbyc.php');
  //   if (response.statusCode == 200) {
  //     List data = response.data;
  //     return data.map((json) => Category.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load categories');
  //   }
  // }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/JSON/allitem.php');

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      throw Exception('Network or parsing error: $e');
    }
  }

}
