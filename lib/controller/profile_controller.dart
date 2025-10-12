import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/auth_response.dart';
import '../models/profile_response.dart';
import '../services/profile_service.dart';
import 'order_controller.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final GetStorage _storage = GetStorage();

  // Observable variables
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isVerified = false.obs;

  // Order statistics
  final RxInt ongoingOrders = 0.obs;
  final RxInt deliveredOrders = 0.obs;
  final RxInt completedOrders = 0.obs;




  // User ID getter from stored user data
  String get userId {
    final storedData = _storage.read('user_data');
    if (storedData != null) {
      final userData = UserData.fromJson(storedData);
      return userData.userId;
    }
    return '';
  }

  @override
  void onInit() {
    super.onInit();
    if (userId.isNotEmpty) {
      fetchProfile();
      fetchOrderStatistics();
    } else {
      errorMessage.value = 'User not logged in';
    }
  }

  Future<void> fetchProfile() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final profile = await _profileService.getProfile(userId);

    if (profile != null) {
      // Check verification based on success and message
      if (profile.success && profile.message.toLowerCase().contains('verified')) {
        isVerified.value = true;
        if (kDebugMode) {
          print("[profile]: profile is verified");
        }
        await _storage.write('is_verified', isVerified.value);
      } else {
        isVerified.value = false;
        errorMessage.value = 'Please signup and verify to proceed';
      }

      userProfile.value = profile;
      // Store profile locally
      _storage.write('user_profile', {
        'name': profile.name,
        'email': profile.email,
        'mobile': profile.mobile,
        'gender': profile.gender,
        'city': profile.city,
        'locality': profile.locality,
        'flat': profile.flat,
        'pincode': profile.pincode,
        'state': profile.state,
        'landmark': profile.landmark,
      });
    } else {
      isVerified.value = false;
      errorMessage.value = 'Failed to fetch profile';
    }
  } catch (e) {
    errorMessage.value = e.toString();
    isVerified.value = false;
    if (Get.isLogEnable) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
    }
  } finally {
    isLoading.value = false;
  }
}

  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _profileService.updateProfile(userId, profileData);
      if (success) {
        // Refresh profile after successful update
        await fetchProfile();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      if (Get.isLogEnable) {
        if (kDebugMode) {
          print('Error updating profile: $e');
        }
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void refreshProfile() {
    fetchProfile();
    fetchOrderStatistics();
  }

  Future<void> fetchOrderStatistics() async {
    try {
      if (kDebugMode) {
        print('[DEBUG ProfileController] Fetching order statistics for userId: $userId');
      }

      // Get OrderController instance
      final orderController = Get.put(OrderController());

      // Fetch user's orders
      await orderController.fetchMyOrders(userId);

      // Calculate statistics based on order status
      final orders = orderController.myOrders;
      if (kDebugMode) {
        print('[DEBUG ProfileController] Total orders fetched: ${orders.length}');
      }

      int ongoing = 0;
      int delivered = 0;
      int completed = 0;

      for (var order in orders) {
        final status = order.status.toLowerCase();
        if (kDebugMode) {
          print('[DEBUG ProfileController] Order ${order.orderId} status: $status');
        }

        if (status.contains('pending') || status.contains('processing') || status.contains('confirmed') || status.contains('preparing')) {
          ongoing++;
        } else if (status.contains('delivered') || status.contains('out for delivery')) {
          delivered++;
        } else if (status.contains('completed') || status.contains('complete')) {
          completed++;
        }
      }

      ongoingOrders.value = ongoing;
      deliveredOrders.value = delivered;
      completedOrders.value = completed;

      if (kDebugMode) {
        print('[DEBUG ProfileController] Statistics - Ongoing: $ongoing, Delivered: $delivered, Completed: $completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[DEBUG ProfileController] Error fetching order statistics: $e');
      }
    }
  }

  // Get user display name
  String get displayName {
    return userProfile.value?.name ?? 'User';
  }

  // Get user email
  String get displayEmail {
    return userProfile.value?.email ?? '';
  }

  // Get user mobile
  String get displayMobile {
    return userProfile.value?.mobile ?? '';
  }

  // Get user gender
  String get displayGender {
    return userProfile.value?.gender ?? '';
  }

  // Get user city
  String get displayCity {
    return userProfile.value?.city ?? '';
  }

  // Get user locality
  String get displayLocality {
    return userProfile.value?.locality ?? '';
  }

  // Get user flat
  String get displayFlat {
    return userProfile.value?.flat ?? '';
  }

  // Get user pincode
  String get displayPincode {
    return userProfile.value?.pincode ?? '';
  }

  // Get user state
  String get displayState {
    return userProfile.value?.state ?? '';
  }

  // Get user landmark
  String get displayLandmark {
    return userProfile.value?.landmark ?? '';
  }

  // Check if profile is loaded
  bool get hasProfile {
    return userProfile.value != null;
  }
}
