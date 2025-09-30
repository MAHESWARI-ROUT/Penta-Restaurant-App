import 'package:dio/dio.dart';
import '../models/category_model.dart';

import '../models/product_model.dart';
import 'dio_client.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<Category>> getCategoryList() async {
    final response = await _dio.get('/JSON/pbyc.php');
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final response = await _dio.get('/JSON/allitem.php');
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
