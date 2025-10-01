import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();

  // Observable cart items list
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // User ID (you might get this from a user controller or shared preferences)
  // This is a placeholder - implement proper user auth in your app
  String get userId => '1'; // Replace with actual user ID logic

  // Calculate total price of all items in cart
  double get totalPrice => cartItems.fold(
    0, (sum, item) => sum + item.totalPrice
  );

  // Calculate total number of items in cart
  int get itemCount => cartItems.fold(
    0, (sum, item) => sum + item.quantity
  );

  @override
  void onInit() {
    super.onInit();
    getCartItems();
  }

  // Fetch cart items for the current user
  Future<void> getCartItems() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final items = await _cartService.getCartItems(userId);
      cartItems.value = items.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load cart items: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Add a product to cart
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

    try {
      // Check if item already exists in cart
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.productId == productId && item.variantId == variantId
      );

      if (existingItemIndex >= 0) {
        // Item exists, update quantity
        final updatedQuantity = cartItems[existingItemIndex].quantity + quantity;

        // Call API to update
        final success = await _cartService.addToCart(
          productId: productId,
          userId: userId,
          variantId: variantId,
          variantQuantity: updatedQuantity.toString(),
          variantName: variantName,
          variantPrice: variantPrice,
          productName: productName,
        );

        if (success) {
          // Update local cart
          cartItems[existingItemIndex].quantity = updatedQuantity;
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
      } else {
        // New item
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
          // Add to local cart
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
      }
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Remove item from cart
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
        // Remove from local cart
        cartItems.removeWhere(
          (item) => item.productId == productId && item.variantId == variantId
        );
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update item quantity
  Future<bool> updateQuantity(String productId, String variantId, int newQuantity) async {
    if (newQuantity <= 0) {
      return removeFromCart(productId, variantId);
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final index = cartItems.indexWhere(
        (item) => item.productId == productId && item.variantId == variantId
      );

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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear entire cart
  void clearCart() {
    cartItems.clear();
  }
}
