import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/faq_model.dart';
import 'dio_client.dart';

class FAQService {
  late final Dio _dio;

  FAQService() {
    _dio = DioClient().dio;
  }

  Future<FAQ?> getFAQ() async {
    try {
      final response = await _dio.get('/JSON/faq.php');

      final data = response.data;
      Map<String, dynamic> jsonData;

      if (data is String) {
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      } else {
        throw Exception('Unexpected response format');
      }

      // Since the API directly returns FAQ data, create FAQ from it
      return FAQ.fromJson(jsonData);
    } catch (e) {
      throw Exception('Error fetching FAQ: $e');
    }
  }
}
