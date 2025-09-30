import 'package:dio/dio.dart';
import 'dio_client.dart';

class InfoService {
  final Dio _dio = DioClient().dio;

  Future<Response> getFAQ() async {
    return _dio.get('/JSON/faq.php');
  }

  Future<Response> getTerms() async {
    return _dio.get('/JSON/terms.php');
  }
}
