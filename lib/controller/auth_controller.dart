import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../commons/appcolors.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isVerified = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserData?> currentUser = Rx<UserData?>(null);

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('AuthController initialized');
    }
    _checkLoginStatus();
  }

  // Check if user is already logged in
  void _checkLoginStatus() {
    if (kDebugMode) {
      print('Checking login status...');
    }
    final userData = _storage.read('user_data');
    final verified = _storage.read('is_verified') ?? false;
    if (kDebugMode) {
      print('Read user_data from storage: $userData, verified: $verified');
    }

    if (userData != null) {
      currentUser.value = UserData.fromJson(userData);
      isLoggedIn.value = true;
      isVerified.value = verified;
      if (kDebugMode) {
        print('User is logged in with ID: ${currentUser.value?.userId}, verified: $verified');
      }
    } else {
      if (kDebugMode) {
        print('No user data found, user is not logged in');
      }
    }
  }

  // Login function
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('Login requested for email: $email');
    }
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      if (kDebugMode) {
        print('Login response success: ${response.success}');
      }
      if (kDebugMode) {
        print('Login response message: ${response.message}');
      }
      if (kDebugMode) {
        print('Login response userId: ${response.userId}');
      }

      if (response.success) {
        final user = UserData(
          userId: response.userId ?? '',
          name: '',
          email: email,
          mobileNum: '',
          profession: '',
          loginType: 'email',
        );

        await _storage.write('user_data', user.toJson());

        // Track verification status
        final verified = (response.message.toLowerCase() == 'verified');
        await _storage.write('is_verified', verified);

        currentUser.value = user;
        isLoggedIn.value = true;
        isVerified.value = verified;

        if (kDebugMode) {
          print('Login successful, user stored in local storage, verified: $verified');
        }

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
        return true;
      } else {
        errorMessage.value = response.message;
        if (kDebugMode) {
          print('Login failed: ${response.message}');
        }
        Get.snackbar(
          'Login Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
      if (kDebugMode) {
        print('Login error: $e');
      }
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print('Login process complete');
      }
    }
  }

  // Signup function
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String mobileNum,
    required String profession,
  }) async {
    if (kDebugMode) {
      print('Signup requested for email: $email, name: $name');
    }
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        mobileNum: mobileNum,
        profession: profession,
      );
      if (kDebugMode) {
        print('Signup response success: ${response.success}');
        print('Signup response message: ${response.message}');
        print('Signup response userId: ${response.userId}');
      }


      if (response.success) {
        final user = UserData(
          userId: response.userId ?? '',
          name: name,
          email: email,
          mobileNum: mobileNum,
          profession: profession,
          loginType: 'email',
        );

        await _storage.write('user_data', user.toJson());

        // Track verification status
        final verified = (response.message.toLowerCase() == 'verified');
        await _storage.write('is_verified', verified);

        currentUser.value = user;
        isLoggedIn.value = true;
        isVerified.value = verified;

        if (kDebugMode) {
          print('Signup successful, user stored in local storage, verified: $verified');
        }

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
        return true;
      } else {
        errorMessage.value = response.message;
        if (kDebugMode) {
          print('Signup failed: ${response.message}');
        }
        Get.snackbar(
          'Registration Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Registration failed: $e';
      if (kDebugMode) {
        print('Signup error: $e');
      }
      Get.snackbar(
        'Error',
        'Registration failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print('Signup process complete');
      }
    }
  }

  // Logout function
  Future<void> logout() async {
    if (kDebugMode) {
      print('Logout requested');
    }
    await _storage.remove('user_data');
    await _storage.remove('is_verified');
    currentUser.value = null;
    isLoggedIn.value = false;
    isVerified.value = false;
    if (kDebugMode) {
      print('User data removed from storage, logged out');
    }

    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
    );
  }

  // Forgot Password function
  Future<bool> forgotPassword({
    required String email,
  }) async {
    if (kDebugMode) {
      print('Forgot password requested for email: $email');
    }
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.forgotPassword(
        email: email,
      );
      if (kDebugMode) {
        print('Forgot password response success: ${response.success}');
        print('Forgot password response message: ${response.message}');
      }

      if (response.success) {
        if (kDebugMode) {
          print('Forgot password successful');
        }

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
          duration: Duration(seconds: 4),
        );
        return true;
      } else {
        errorMessage.value = response.message;
        if (kDebugMode) {
          print('Forgot password failed: ${response.message}');
        }
        Get.snackbar(
          'Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Forgot password failed: $e';
      if (kDebugMode) {
        print('Forgot password error: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print('Forgot password process complete');
      }
    }
  }
  // Get current user ID
  String get userId => currentUser.value?.userId ?? '';
}
