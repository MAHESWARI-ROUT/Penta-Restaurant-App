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
    print('AuthController initialized');
    _checkLoginStatus();
  }

  // Check if user is already logged in
  void _checkLoginStatus() {
    print('Checking login status...');
    final userData = _storage.read('user_data');
    final verified = _storage.read('is_verified') ?? false;
    print('Read user_data from storage: $userData, verified: $verified');

    if (userData != null) {
      currentUser.value = UserData.fromJson(userData);
      isLoggedIn.value = true;
      isVerified.value = verified;
      print('User is logged in with ID: ${currentUser.value?.userId}, verified: $verified');
    } else {
      print('No user data found, user is not logged in');
    }
  }

  // Login function
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    print('Login requested for email: $email');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      print('Login response success: ${response.success}');
      print('Login response message: ${response.message}');
      print('Login response userId: ${response.userId}');

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

        print('Login successful, user stored in local storage, verified: $verified');

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkGreen,
          colorText: AppColors.white,
        );
        return true;
      } else {
        errorMessage.value = response.message;
        print('Login failed: ${response.message}');
        Get.snackbar(
          'Login Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkGreen,
          colorText: AppColors.white,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
      print('Login error: $e');
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      print('Login process complete');
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
    print('Signup requested for email: $email, name: $name');
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
      print('Signup response success: ${response.success}');
      print('Signup response message: ${response.message}');
      print('Signup response userId: ${response.userId}');

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

        print('Signup successful, user stored in local storage, verified: $verified');

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkGreen,
          colorText: AppColors.white,
        );
        return true;
      } else {
        errorMessage.value = response.message;
        print('Signup failed: ${response.message}');
        Get.snackbar(
          'Registration Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkGreen,
          colorText: AppColors.white,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Registration failed: $e';
      print('Signup error: $e');
      Get.snackbar(
        'Error',
        'Registration failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      print('Signup process complete');
    }
  }

  // Logout function
  Future<void> logout() async {
    print('Logout requested');
    await _storage.remove('user_data');
    await _storage.remove('is_verified');
    currentUser.value = null;
    isLoggedIn.value = false;
    isVerified.value = false;
    print('User data removed from storage, logged out');

    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.darkGreen,
      colorText: AppColors.white,
    );
  }

  // Get current user ID
  String get userId => currentUser.value?.userId ?? '';
}
