import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _promoController = TextEditingController();
  final CartController cartController = Get.find<CartController>();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final promoCode = _promoController.text.trim();
    if (promoCode.isEmpty) {
      Get.snackbar(
        'Promo Code',
        'Please enter a promo code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Implement actual promo code validation logic here
    Get.snackbar(
      'Promo Code',
      'Promo code "$promoCode" applied (stub implementation)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Optionally clear promo input
    // _promoController.clear();
  }

  void _checkout() {
    // TODO: Implement checkout process
    Get.snackbar(
      'Checkout',
      'Processing your order...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.darkGreen,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        elevation: 0,
        title: Text(
          'My Order',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: AppColors.black),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  final itemCount = cartController.itemCount;
                  return itemCount > 0
                      ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : const SizedBox.shrink();
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.grey5,
              radius: 16,
              child: Icon(Icons.person, color: AppColors.grey2, size: 18),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.grey3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add some items to get started',
                    style: TextStyle(fontSize: 16, color: AppColors.grey3),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Explore Menu',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Dismissible(
                      key: Key(item.variantId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
                      ),
                      onDismissed: (_) {
                        cartController.removeFromCart(item.productId, item.variantId);
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.grey5,
                                child: const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.grey5,
                                child: Icon(Icons.fastfood, color: AppColors.grey3, size: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.variantName,
                                    style: TextStyle(color: AppColors.grey2, fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${item.variantPrice}',
                                    style: TextStyle(
                                      color: AppColors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey5,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.remove, color: AppColors.darkGreen, size: 18),
                                  ),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      cartController.updateQuantity(
                                        item.productId,
                                        item.variantId,
                                        item.quantity - 1,
                                      );
                                    } else {
                                      cartController.removeFromCart(
                                        item.productId,
                                        item.variantId,
                                      );
                                      cartController.getCartItems();
                                    }
                                  },
                                ),

                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
                                  onPressed: () {
                                    cartController.updateQuantity(
                                      item.productId,
                                      item.variantId,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      decoration: InputDecoration(
                        hintText: 'Apply promocode',
                        hintStyle: TextStyle(color: AppColors.grey3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppColors.grey4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppColors.grey4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppColors.darkGreen),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: AppColors.darkGreen),
                    onPressed: () {
                      final promo = _promoController.text.trim();
                      if (promo.isEmpty) {
                        Get.snackbar(
                          'Promo Code',
                          'Please enter a promo code',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      // TODO: Integrate real promocode validation logic
                      Get.snackbar(
                        'Promo Code',
                        'Promo code "$promo" applied (stub)',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    tooltip: 'Apply promocode',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', '₹${cartController.totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Delivery',
                    'Free',
                    valueColor: Colors.green,
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  _buildSummaryRow(
                    'Total',
                    '₹${cartController.totalPrice.toStringAsFixed(2)}',
                    valueFontSize: 22,
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement checkout logic here
                        Get.snackbar(
                          'Checkout',
                          'Processing your order...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.darkGreen,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryRow(
      String label,
      String value, {
        Color valueColor = Colors.black,
        double valueFontSize = 16,
        FontWeight valueFontWeight = FontWeight.normal,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.grey2, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: valueFontSize,
            fontWeight: valueFontWeight,
          ),
        ),
      ],
    );
  }
}
