import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../models/profile_response.dart';

class ProfileService {
  late final Dio _dio;

  ProfileService() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://adda.lasolution.in/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      responseType: ResponseType.plain,
    );
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      logPrint: (obj) => print(obj),
    ));
  }

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _dio.post(
        '/JSON/userprofile.php',
        data: FormData.fromMap({'user_id': userId}),
      );

      final data = response.data;
      Map<String, dynamic> jsonData;

      if (data is String) {
        // Decode if response is String
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      } else {
        throw Exception('Unexpected response format');
      }

      // Check if the response indicates success
      if (jsonData['success'] == true || jsonData['success'] == 'true') {
        return UserProfile.fromJson(jsonData['user'] ?? jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  Future<bool> updateProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      // Map the profile data to match API field names
      final updateData = <String, dynamic>{
        'user_id': userId,
        'name': profileData['name'] ?? '',
        'city': profileData['city'] ?? '',
        'state': profileData['state'] ?? '',
        'pincode': profileData['pincode'] ?? '',
        'local': profileData['locality'] ?? '', // Map 'locality' to 'local'
        'flat': profileData['flat'] ?? '',
        'gender': profileData['gender'] ?? '',
        'phone': profileData['mobile'] ?? '', // Map 'mobile' to 'phone'
        'landmark': profileData['landmark'] ?? '',
        'referredBy': '', // Add default value if not provided
        'skills': '', // Add default value if not provided
        'workaslasa': '', // Add default value if not provided
      };

      final response = await _dio.post(
        '/JSON/updateprofile.php',
        data: FormData.fromMap(updateData),
      );

      final data = response.data;
      Map<String, dynamic> jsonData;

      if (data is String) {
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      } else {
        throw Exception('Unexpected response format');
      }

      return jsonData['success'] == true || jsonData['success'] == 'true';
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Future<Map<String, dynamic>?> getProfileStats(String userId) async {
  //   try {
  //     final response = await _dio.post(
  //       '/JSON/userordersstats.php', // Assuming this is your stats endpoint
  //       data: FormData.fromMap({'user_id': userId}),
  //     );
  //
  //     final data = response.data;
  //     Map<String, dynamic> jsonData;
  //
  //     if (data is String) {
  //       jsonData = json.decode(data);
  //     } else if (data is Map<String, dynamic>) {
  //       jsonData = data;
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //
  //     if (jsonData['success'] == true || jsonData['success'] == 'true') {
  //       return jsonData['stats'] ?? {
  //         'ongoing': jsonData['ongoing'] ?? 0,
  //         'delivered': jsonData['delivered'] ?? 0,
  //         'completed': jsonData['completed'] ?? 0,
  //       };
  //     } else {
  //       throw Exception(jsonData['message'] ?? 'Failed to fetch profile stats');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching profile stats: $e');
  //     // Return default stats on error
  //     // return {'ongoing': 0, 'delivered': 0, 'completed': 0};
  //   }
  // }
}
