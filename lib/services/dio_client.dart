// lib/services/dio_client.dart

import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio dio;

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://adda.lasolution.in/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      // THIS IS THE FIX: Change ResponseType.json to ResponseType.plain
      responseType: ResponseType.plain, 
    );
    dio = Dio(options);
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      logPrint: (obj) => print(obj),
    ));
  }
}