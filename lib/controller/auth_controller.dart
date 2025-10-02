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
  final RxString errorMessage = ''.obs;
  final Rx<UserData?> currentUser = Rx<UserData?>(null);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  // Check if user is already logged in
  void _checkLoginStatus() {
    final userData = _storage.read('user_data');
    if (userData != null) {
      currentUser.value = UserData.fromJson(userData);
      isLoggedIn.value = true;
    }
  }

  // Login function
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.success) {
        // Create minimal UserData since backend only returns userid
        final user = UserData(
          userId: response.userId ?? '',
          name: '',
          email: email,
          mobileNum: '',
          profession: '',
          loginType: 'email',
        );

        await _storage.write('user_data', user.toJson());
        currentUser.value = user;
        isLoggedIn.value = true;

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

      if (response.success) {
        // Create minimal UserData
        final user = UserData(
          userId: response.userId ?? '',
          name: name,
          email: email,
          mobileNum: mobileNum,
          profession: profession,
          loginType: 'email',
        );

        await _storage.write('user_data', user.toJson());
        currentUser.value = user;
        isLoggedIn.value = true;

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
    }
  }

  // Logout function
  Future<void> logout() async {
    await _storage.remove('user_data');
    currentUser.value = null;
    isLoggedIn.value = false;

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
