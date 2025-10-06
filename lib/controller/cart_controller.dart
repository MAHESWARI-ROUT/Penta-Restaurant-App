import 'dart:convert';

import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/controller/tab_controller.dart';
import '../models/auth_response.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  final Rx<UserData?> currentUser = Rx<UserData?>(null);

  // Observable list of cart items
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Loading and error state observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final GetStorage _storage = GetStorage();

  // User ID getter from stored user data
  String get userId {
    final storedData = _storage.read('user_data');
    if (storedData != null) {
      currentUser.value = UserData.fromJson(storedData);
      final id = currentUser.value?.userId;
      if (id != null && id.isNotEmpty) {
        return id;
      }
    }
    return '';
  }

  double get totalPrice => cartItems.fold(0, (total, item) => total + item.totalPrice);
  int get itemCount => cartItems.fold(0, (total, item) => total + item.quantity);

  @override
  void onInit() {
    super.onInit();
    if (userId.isNotEmpty) {
      getCartItems();
    } else {
      if (Get.isLogEnable) {
        print('CartController init: User ID is empty.');
      }
    }
  }

  Future<void> getCartItems() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final items = await _cartService.getCartItems(userId);
      cartItems.value = items.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load cart items: $e';
      if (Get.isLogEnable) print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart({
    required String productId,
    required String variantId,
    required String productName,
    required String variantName,
    required String variantPrice,
    required String imageUrl,
    int quantity = 1,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    if ([productId, variantId, productName, variantName, variantPrice, userId].any((s) => s.isEmpty)) {
      errorMessage.value = 'One or more required fields are empty';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
      isLoading.value = false;
      return false;
    }

    try {
      final existingIndex = cartItems.indexWhere(
              (item) => item.productId == productId && item.variantId == variantId);

      if (existingIndex >= 0) {
        final updatedQty = cartItems[existingIndex].quantity + quantity;

        final success = await _cartService.addToCart(
          productId: productId,
          userId: userId,
          variantId: variantId,
          variantQuantity: updatedQty.toString(),
          variantName: variantName,
          variantPrice: variantPrice,
          productName: productName,
        );

        if (success) {
          cartItems[existingIndex].quantity = updatedQty;
          cartItems.refresh();
          Get.snackbar(
            'Added to Cart',
            'Item quantity updated in cart',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 2),
          );
        }

        return success;
      }

      // Add new item
      final success = await _cartService.addToCart(
        productId: productId,
        userId: userId,
        variantId: variantId,
        variantQuantity: quantity.toString(),
        variantName: variantName,
        variantPrice: variantPrice,
        productName: productName,
      );

      if (success) {
        cartItems.add(CartItem(
          productId: productId,
          variantId: variantId,
          productName: productName,
          variantName: variantName,
          variantPrice: variantPrice,
          quantity: quantity,
          imageUrl: imageUrl,
        ));
        Get.showSnackbar(GetSnackBar(
          messageText: const Text(
            'Item successfully added.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          animationDuration: const Duration(milliseconds: 300),
          duration: const Duration(seconds: 4),
          barBlur: 20,
          backgroundColor: Colors.green.withAlpha(10),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          borderRadius: 12,
          snackStyle: SnackStyle.FLOATING,
          mainButton: TextButton(
            onPressed: () {
              final tabController = Get.find<TabController>();

              tabController.changeTab(1); // Switch to Cart tab
              Get.back(); // Close snackbar immediately when pressed
            },
            child: const Text(
              'Go to Cart',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to add item to cart: $e';
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
      if (Get.isLogEnable) print(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeFromCart(String productId, String variantId) async {
    print("[DEBUG] removeFromCart called for productId=$productId variantId=$variantId");
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 'response' is boolean success from service method
      final bool success = await _cartService.removeFromCart(
        userId: userId,
        variantId: variantId,
        productId: productId,
      );

      if (success) {
        final index = cartItems.indexWhere(
                (item) => item.productId == productId && item.variantId == variantId);
        if (index != -1) {
          cartItems.removeAt(index);
          cartItems.refresh();
          Get.snackbar('Removed', 'Item removed from cart');
          return true;
        } else {
          return true; // Server confirmed removal so consider success
        }
      } else {
        Get.snackbar('Error', 'Failed to remove item from cart');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      print(errorMessage.value);
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  Future<bool> updateQuantity(String productId, String variantId, int newQuantity) async {
    if (newQuantity <= 0) {
      return await removeFromCart(productId, variantId);
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final index = cartItems.indexWhere(
              (item) => item.productId == productId && item.variantId == variantId);

      if (index >= 0) {
        final item = cartItems[index];

        final success = await _cartService.addToCart(
          productId: productId,
          userId: userId,
          variantId: variantId,
          variantQuantity: newQuantity.toString(),
          variantName: item.variantName,
          variantPrice: item.variantPrice,
          productName: item.productName,
        );

        if (success) {
          cartItems[index].quantity = newQuantity;
          cartItems.refresh();
        }

        return success;
      }

      return false;
    } catch (e) {
      errorMessage.value = 'Failed to update quantity: $e';
      if (Get.isLogEnable) print(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  int getQuantity(String productId, String variantId) {
    try {
      return cartItems.firstWhere((item) =>
      item.productId == productId && item.variantId == variantId).quantity;
    } catch (_) {
      return 0;
    }
  }
 
}
