import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/restaurant_detail.dart';
import '../services/restaurant_service.dart';

class RestaurantController extends GetxController {
  final RestaurantService _restaurantService = RestaurantService();

  // Observable variables
  final Rx<RestaurantDetail?> restaurantDetail = Rx<RestaurantDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final restaurant = await _restaurantService.getRestaurantDetails();
      if (restaurant != null) {
        restaurantDetail.value = restaurant;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (Get.isLogEnable) {
        if (kDebugMode) {
          print('Error fetching restaurant details: $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void refreshRestaurantDetails() {
    fetchRestaurantDetails();
  }

  // Getter methods for easy access
  String get restaurantName => restaurantDetail.value?.name ?? 'Restaurant';
  String get restaurantAddress => restaurantDetail.value?.address ?? '';
  String get restaurantDescription => restaurantDetail.value?.description ?? '';
  String get restaurantPhone => restaurantDetail.value?.phone ?? '';
  String get restaurantWeb => restaurantDetail.value?.web ?? '';
  String get restaurantTime => restaurantDetail.value?.time ?? '';
  String get restaurantTax => restaurantDetail.value?.tax ?? '0';
  String get restaurantCurrency => restaurantDetail.value?.currency ?? 'INR';
  String get restaurantMinOrder => restaurantDetail.value?.minorder ?? '0';
  List<String> get restaurantImages => restaurantDetail.value?.images ?? [];
  List<String> get deliveryCities => restaurantDetail.value?.deliverycity ?? [];

  bool get hasRestaurantDetail => restaurantDetail.value != null;

  // Helper method to get cleaned description (remove HTML tags)
  String get cleanDescription {
    String desc = restaurantDescription;
    // Remove HTML tags
    desc = desc.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode HTML entities
    desc = desc.replaceAll('&nbsp;', ' ');
    desc = desc.replaceAll('&amp;', '&');
    desc = desc.replaceAll('&lt;', '<');
    desc = desc.replaceAll('&gt;', '>');
    desc = desc.replaceAll('&quot;', '"');
    desc = desc.replaceAll('&#39;', "'");
    return desc.trim();
  }
}
