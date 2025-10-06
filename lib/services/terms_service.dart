import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/terms_model.dart';
import 'dio_client.dart';

class TermsService {
  late final Dio _dio;

  TermsService() {
    _dio = DioClient().dio;
  }

  Future<Terms?> getTerms() async {
    try {
      final response = await _dio.get('/JSON/terms.php');

      final data = response.data;
      Map<String, dynamic> jsonData;

      if (data is String) {
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      } else {
        throw Exception('Unexpected response format');
      }

      return Terms.fromJson(jsonData);
    } catch (e) {
      throw Exception('Error fetching terms: $e');
    }
  }
}
