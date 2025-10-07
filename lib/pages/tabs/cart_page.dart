import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/shipping_details_page.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.find<CartController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final RxBool _showDetailedBill = false.obs;
  final RxList<String> savedAddresses = <String>[
    '123 Main Street, City',
    '456 Park Avenue, City',
  ].obs;
  final RxString selectedAddress = ''.obs;

  @override
  void initState() {
    super.initState();

    if (savedAddresses.isNotEmpty) {
      selectedAddress.value = savedAddresses[0];
    }
  }

  void _checkout() {
    Get.to(() => const ShippingDetailsPage());
  }

  void _showAddAddressSheet() {
    final TextEditingController _addressController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  String newAddress = _addressController.text.trim();
                  if (newAddress.isNotEmpty) {
                    savedAddresses.add(newAddress);
                    selectedAddress.value = newAddress;
                    Get.back();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter an address',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text(
                  'Save Address',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
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

  Widget _buildAddressSelector() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedAddress.value.isEmpty ? null : selectedAddress.value,
                  hint: const Text('Select delivery address'),
                  items: savedAddresses
                      .map((addr) => DropdownMenuItem(
                            value: addr,
                            child: Text(addr, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedAddress.value = val;
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_location_alt, color: AppColors.darkGreen),
              onPressed: _showAddAddressSheet,
              tooltip: 'Add New Address',
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // if user email is not verified
    if (!profileController.isVerified.value) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        appBar: AppBar(
          backgroundColor: AppColors.yellow,
          elevation: 0,
          title: Text('My Cart', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
                const SizedBox(height: 20),
                Text(
                  'Please verify your email to continue.',
                  style: TextStyle(fontSize: 18, color: AppColors.grey2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    final phone = '916370793232';
                    final message =
                        'Verification Request:\n\nName: ${profileController.displayName}\nEmail: ${profileController.displayEmail}\n\nPlease verify this user.';

                    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    } else {
                      Get.snackbar(
                        'Error',
                        'Could not open WhatsApp.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    'Verify Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }

    // Main cart UI for logged-in users
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        elevation: 0,
        title: Text('My Cart', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
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
                  child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                const SizedBox(height: 4),
                                Text(item.variantName, style: TextStyle(color: AppColors.grey2, fontSize: 15)),
                                const SizedBox(height: 8),
                                Text('₹${item.variantPrice}', style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold, fontSize: 17)),
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
                                  decoration: BoxDecoration(color: AppColors.grey5, shape: BoxShape.circle),
                                  child: Icon(Icons.remove, color: AppColors.darkGreen, size: 18),
                                ),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cartController.updateQuantity(item.productId, item.variantId, item.quantity - 1);
                                  } else {
                                    cartController.removeFromCart(item.productId, item.variantId);
                                  }
                                },
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColors.darkGreen, shape: BoxShape.circle),
                                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                                ),
                                onPressed: () {
                                  cartController.updateQuantity(item.productId, item.variantId, item.quantity + 1);
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
          Obx(
            () => InkWell(
              onTap: () => _showDetailedBill.value = !_showDetailedBill.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_showDetailedBill.value ? 'Hide Detailed Bill' : 'Show Detailed Bill',
                        style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(_showDetailedBill.value ? Icons.expand_less : Icons.expand_more, color: AppColors.darkGreen),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (!_showDetailedBill.value) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: cartController.cartItems.map((item) {
                  final itemTotal = (double.tryParse(item.variantPrice) ?? 0) * item.quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('${item.productName} (${item.variantName}) x${item.quantity}', overflow: TextOverflow.ellipsis)),
                        Text('₹${itemTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -5))],
            ),
            child: Column(
              children: [
                Obx(() => _buildSummaryRow('Subtotal', '₹${cartController.totalPrice.toStringAsFixed(2)}')),
                const SizedBox(height: 8),
                _buildSummaryRow('Delivery', 'Free', valueColor: Colors.green, valueFontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                Obx(() => _buildSummaryRow('Total', '₹${cartController.totalPrice.toStringAsFixed(2)}', valueFontSize: 22, valueFontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: _checkout,
                    child: const Text('Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
