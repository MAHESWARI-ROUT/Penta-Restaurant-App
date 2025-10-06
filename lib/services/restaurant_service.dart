import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/restaurant_detail.dart';
import 'dio_client.dart';

class RestaurantService {
  late final Dio _dio;

  RestaurantService() {
    _dio = DioClient().dio;
  }

  Future<RestaurantDetail?> getRestaurantDetails() async {
    try {
      final response = await _dio.get('/JSON/resdetails.php');

      final data = response.data;
      Map<String, dynamic> jsonData;

      if (data is String) {
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      } else {
        throw Exception('Unexpected response format');
      }

      // Since the API directly returns restaurant data, create RestaurantDetail from it
      return RestaurantDetail.fromJson(jsonData);
    } catch (e) {
      throw Exception('Error fetching restaurant details: $e');
    }
  }
}
