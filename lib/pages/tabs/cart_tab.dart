import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/controller/tab_controller.dart';
import 'package:penta_restaurant/pages/shipping_details_page.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final GetStorage _storage = GetStorage();
  late final CartController cartController;
  late final ProfileController profileController;
  late final AuthController authcontroller;


  final RxBool _showDetailedBill = false.obs;
  final RxList<String> savedAddresses = <String>[
    '123 Main Street, City',
    '456 Park Avenue, City',
  ].obs;
  final RxString selectedAddress = ''.obs;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
    profileController = Get.find<ProfileController>();
     authcontroller = Get.find<AuthController>();
    if (savedAddresses.isNotEmpty) {
      selectedAddress.value = savedAddresses[0];
    }
  }

  void _checkout() {
    if (selectedAddress.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a delivery address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.to(() => const ShippingDetailsPage());
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


  @override
  Widget build(BuildContext context) {
    // if user email is not verified
    if (!profileController.isVerified.value) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary1,
          elevation: 0,
          title: Text(
            'My Cart',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: VerificationErrorPage(
          message: 'Please verify your email to access the cart.',
          userEmail: authcontroller.currentUser.value?.email,
        ),
      );
    }

    // Main cart UI for logged-in users
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary1,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (cartController.errorMessage.value.isNotEmpty) {
                return ErrorStateWidget(
                  message: cartController.errorMessage.value,
                  onRetry: () => cartController.getCartItems(),
                  icon: Icons.shopping_cart_outlined,
                );
              }
              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: AppColors.grey3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey2,
                        ),
                      ),

                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 4,
                        ),
                        onPressed: () {
                          final tabController = Get.find<TabController>();
                          tabController.changeTab(0);
                        },
                        child: const Text('Continue shopping',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.grey5,
                              child: Icon(
                                Icons.fastfood,
                                color: AppColors.grey3,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.variantName,
                                  style: TextStyle(
                                    color: AppColors.grey2,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${item.variantPrice}',
                                  style: TextStyle(
                                    color: AppColors.secondary1,
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
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                                onPressed: () {
                                  if (item.quantity == 1) {
                                    Get.defaultDialog(
                                      title: 'Remove Item?',
                                      middleText:
                                          'Do you want to remove this item from the cart?',
                                      textConfirm: 'Yes',
                                      textCancel: 'No',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        cartController.removeFromCart(
                                          item.productId,
                                          item.variantId,
                                        );
                                        Get.back();
                                      },
                                    );
                                  } else {
                                    cartController.updateQuantity(
                                      item.productId,
                                      item.variantId,
                                      item.quantity - 1,
                                    );
                                  }
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
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
                  );
                },
              );
            }),
          ),
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return InkWell(
              onTap: () => _showDetailedBill.value = !_showDetailedBill.value,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _showDetailedBill.value
                          ? 'Hide Detailed Bill'
                          : 'Show Detailed Bill',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _showDetailedBill.value
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            if (!_showDetailedBill.value) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: cartController.cartItems.map((item) {
                  final itemTotal =
                      (double.tryParse(item.variantPrice) ?? 0) * item.quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.productName} (${item.variantName}) x${item.quantity}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '₹${itemTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
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
                  Obx(
                    () => _buildSummaryRow(
                      'Subtotal',
                      '₹${cartController.totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
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
                  Obx(
                    () => _buildSummaryRow(
                      'Total',
                      '₹${cartController.totalPrice.toStringAsFixed(2)}',
                      valueFontSize: 22,
                      valueFontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _checkout,
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
