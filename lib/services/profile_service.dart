import 'package:dio/dio.dart';
import 'dio_client.dart';

class ProfileService {
  final Dio _dio = DioClient().dio;

  Future<Response> getUserProfile(String userId) async {
    return _dio.post('/JSON/userprofile.php', data: {
      'user_id': userId,
    }, options: Options(contentType: 'application/x-www-form-urlencoded'));
  }

  Future<Response> updateProfile(Map<String, dynamic> profileData) async {
    return _dio.post('/JSON/updateprofile.php', data: profileData,
        options: Options(contentType: 'application/x-www-form-urlencoded'));
  }
}
