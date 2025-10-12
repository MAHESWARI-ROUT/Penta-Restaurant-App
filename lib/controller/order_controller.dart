import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/order_response.dart';
import '../models/my_order_model.dart';
import '../services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();

  final RxList<MyOrder> myOrders = <MyOrder>[].obs;
  final RxList<MyOrder> myAssignedOrders = <MyOrder>[].obs;

  final RxBool isLoadingMyOrders = false.obs;
  final RxBool isLoadingAssignedOrders = false.obs;
  final RxString errorMessage = ''.obs;

  // Profile statistics
  final RxInt ongoingOrders = 0.obs;
  final RxInt deliveredOrders = 0.obs;
  final RxInt completedOrders = 0.obs;

  Future<void> fetchMyOrders(String userId) async {
    if (kDebugMode) {
      print('[DEBUG OrderController] fetchMyOrders called with userId: $userId');
    }
    isLoadingMyOrders.value = true;
    errorMessage.value = '';
    try {
      if (kDebugMode) {
        print('[DEBUG OrderController] Calling _orderService.getMyOrders...');
      }
      final response = await _orderService.getMyOrders(userId);
      if (kDebugMode) {
        print('[DEBUG OrderController] API response received: success=${response?.success}, message=${response?.message}');
      }
      if (response != null && response.success) {
        myOrders.value = response.orders;
        if (kDebugMode) {
          print('[DEBUG OrderController] Orders loaded successfully: ${myOrders.length} orders');
        }
      } else {
        errorMessage.value = response?.message ?? 'Failed to load orders';
        if (kDebugMode) {
          print('[DEBUG OrderController] Failed to load orders: ${errorMessage.value}');
        }
      }
    } catch (e) {
      errorMessage.value = 'Error fetching orders: $e';
      if (kDebugMode) {
        print('[DEBUG OrderController] Exception in fetchMyOrders: $e');
      }
    } finally {
      isLoadingMyOrders.value = false;
      if (kDebugMode) {
        print('[DEBUG OrderController] fetchMyOrders completed, loading=false');
      }
    }
  }

  Future<void> fetchMyAssignedOrders(String userId) async {
    isLoadingAssignedOrders.value = true;
    errorMessage.value = '';
    try {
      final response = await _orderService.getMyAssignOrders(userId);
      if (response != null && response.success) {
        myAssignedOrders.value = response.orders;
      } else {
        errorMessage.value = response?.message ?? 'Failed to load assigned orders';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching assigned orders: $e';
    } finally {
      isLoadingAssignedOrders.value = false;
    }
  }

  Future<OrderResponse?> placeOrder({
    required String userId,
    required String cartId,
    required String address,
    required String phone,
    required String paymentRef,
    required String payStatus,
    required String total,
    required String paymentMode,
    required String orderRemark,
  }) async {
    errorMessage.value = '';
    try {
      final response = await _orderService.addOrder(
        userId: userId,
        cartId: cartId,
        address: address,
        phone: phone,
        paymentRef: paymentRef,
        payStatus: payStatus,
        total: total,
        paymentMode: paymentMode,
        orderRemark: orderRemark,
      );

      if (response != null && response.success) {
        return response;
      } else {
        errorMessage.value = response?.message ?? 'Order placement failed';
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Error placing order: $e';
      return null;
    }
  }
}
