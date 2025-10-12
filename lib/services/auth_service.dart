import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // Login user
  Future<AuthResponse> login({
    required String email,
    required String password,
    String loginType = 'email',
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/login.php',
        data: FormData.fromMap({
          'email': email,
          'password': password,
          'logintype': loginType,
        }),
      );

      // response.data might be String, parse it
      final data = response.data is String ? json.decode(response.data) : response.data;

      return AuthResponse.fromJson(data);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String mobileNum,
    required String profession,
    String loginType = 'email',
  }) async {
    try {
      // Debug print for data sent
      print('Registering user with name=$name, email=$email, mobileNum=$mobileNum, profession=$profession');

      final response = await _dio.post(
        '/JSON/registernew.php',
        data: FormData.fromMap({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'logintype': loginType.trim(),
          'mobilenum': mobileNum.trim(),
          'profession': profession.trim(),
        }),
      );

      // Ensure backend sometimes returns JSON string
      final data = response.data is String ? json.decode(response.data) : response.data;

      print('Register response: $data');

      return AuthResponse.fromJson(data);
    } catch (e) {
      print('Registration failed: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // Forgot password
  Future<AuthResponse> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/forgot.php',
        data: FormData.fromMap({
          'email': email.trim(),
        }),
      );

      // Ensure backend sometimes returns JSON string
      final data = response.data is String ? json.decode(response.data) : response.data;

      print('Forgot password response: $data');

      return AuthResponse.fromJson(data);
    } catch (e) {
      print('Forgot password failed: $e');
      throw Exception('Forgot password failed: $e');
    }
  }
}
