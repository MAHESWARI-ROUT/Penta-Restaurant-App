import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/auth_response.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import 'package:flutter/material.dart';

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
        Get.snackbar(
          'Added to Cart',
          'Item added to cart successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );
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
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final success = await _cartService.removeFromCart(
        userId: userId,
        variantId: variantId,
        productId: productId,
      );

      if (success) {
        // Remove item from list
        cartItems.removeWhere((item) =>
        item.productId == productId && item.variantId == variantId);

        // Important: refresh the observable list to update UI
        cartItems.refresh();

        Get.snackbar(
          'Removed',
          'Item removed from cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to remove item from cart: $e';
      if (Get.isLogEnable) print(errorMessage.value);
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
