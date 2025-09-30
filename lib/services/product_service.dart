// lib/services/product_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'dio_client.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<Category>> getCategoryList() async {
    try {
      final response = await _dio.get('/JSON/pbyc.php');

      // THIS IS THE FIX: Manually decode the plain text response
      final List<dynamic> decodedData = json.decode(response.data.toString());

      return decodedData.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      throw Exception('Failed to load categories.');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/JSON/allitem.php');

      // THIS IS THE FIX: Manually decode the plain text response
      final List<dynamic> decodedData = json.decode(response.data.toString());

      return decodedData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception('Failed to load products.');
    }
  }
}