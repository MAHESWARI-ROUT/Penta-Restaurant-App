
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
      final List<dynamic> decodedData = json.decode(response.data.toString());
      return decodedData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception('Failed to load products.');
    }
  }

  Future<List<Product>> getRecommendedProducts() async {
    try {
      final response = await _dio.get('/JSON/recom.php');
      
      print(response.data.toString());
      

      final Map<String, dynamic> decodedData = json.decode(response.data.toString());

      
      final List<dynamic>? productList = decodedData['rcomitem'];

      if (productList == null) {
        print("'rcomitem' key not found or is null.");
        return [];
      }

      return productList.map((json) => Product.fromJson(json)).toList();

    } catch (e) {
      print("Error fetching or parsing recommended products: $e");
      return []; 
    }
  }
}