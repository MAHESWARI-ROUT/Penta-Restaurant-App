import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // Login user
  Future<SignUpResponse> login({
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

      return SignUpResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register new user
  Future<SignUpResponse> register({
    required String name,
    required String email,
    required String password,
    required String mobileNum,
    required String profession,
    String loginType = 'email',
  }) async {
    try {
      final response = await _dio.post(
        '/JSON/registernew.php',
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'password': password,
          'logintype': loginType,
          'mobilenum': mobileNum,
          'profession': profession,
        }),
      );

      return SignUpResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
