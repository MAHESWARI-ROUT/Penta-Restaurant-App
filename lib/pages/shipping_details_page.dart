import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/my_order_page.dart';

class ShippingDetailsPage extends StatefulWidget {
  const ShippingDetailsPage({super.key});

  @override
  State<ShippingDetailsPage> createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  final CartController cartController = Get.find<CartController>();
  final ProfileController profileController = Get.put(ProfileController());
  final OrderController orderController = Get.put(OrderController());

  final RxList<Map<String, String>> savedAddresses = <Map<String, String>>[].obs;
  final RxInt selectedAddressIndex = (-1).obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingAddresses = true.obs;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() async {
    isLoadingAddresses.value = true;

    // Wait a moment for profile to load if needed
    await Future.delayed(const Duration(milliseconds: 500));

    // Load default address from user profile
    if (profileController.userProfile.value != null) {
      final profile = profileController.userProfile.value!;

      // Check if profile has address data
      if (profile.flat.isNotEmpty || profile.locality.isNotEmpty) {
        final defaultAddress = {
          'type': 'Default',
          'address': '${profile.flat}${profile.flat.isNotEmpty && profile.locality.isNotEmpty ? ', ' : ''}${profile.locality}',
          'city': '${profile.city}${profile.city.isNotEmpty && profile.state.isNotEmpty ? ', ' : ''}${profile.state}${profile.pincode.isNotEmpty ? ' - ' : ''}${profile.pincode}',
          'phone': profile.mobile,
          'landmark': profile.landmark,
        };

        savedAddresses.add(defaultAddress);
        selectedAddressIndex.value = 0; // Select default address
      }
    }

    isLoadingAddresses.value = false;
  }

  void _showAddAddressBottomSheet() {
    final TextEditingController typeController = TextEditingController();
    final TextEditingController flatController = TextEditingController();
    final TextEditingController localityController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController pincodeController = TextEditingController();
    final TextEditingController landmarkController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Different Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: AppColors.grey2),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Address Type
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  labelText: 'Address Type (Home, Office, etc.)',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Flat/House/Building
              TextField(
                controller: flatController,
                decoration: InputDecoration(
                  labelText: 'Flat/House No./Building',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Locality/Area/Street
              TextField(
                controller: localityController,
                decoration: InputDecoration(
                  labelText: 'Locality/Area/Street',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // City
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // State
              TextField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pincode
              TextField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Landmark (Optional)
              TextField(
                controller: landmarkController,
                decoration: InputDecoration(
                  labelText: 'Landmark (Optional)',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.separatorOpaque,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    final type = typeController.text.trim();
                    final flat = flatController.text.trim();
                    final locality = localityController.text.trim();
                    final city = cityController.text.trim();
                    final state = stateController.text.trim();
                    final pincode = pincodeController.text.trim();
                    final landmark = landmarkController.text.trim();
                    final phone = phoneController.text.trim();

                    if (type.isNotEmpty &&
                        flat.isNotEmpty &&
                        locality.isNotEmpty &&
                        city.isNotEmpty &&
                        state.isNotEmpty &&
                        pincode.isNotEmpty &&
                        phone.isNotEmpty) {
                      // Build address string in same format as default
                      final address = '${flat}${flat.isNotEmpty && locality.isNotEmpty ? ', ' : ''}${locality}';
                      final cityState = '${city}${city.isNotEmpty && state.isNotEmpty ? ', ' : ''}${state}${pincode.isNotEmpty ? ' - ' : ''}${pincode}';
                      final fullAddress = '$address, $cityState';

                      // Close bottom sheet first (before disposing controllers)
                      Get.back();

                      // Wait for the bottom sheet to close, then show confirmation dialog
                      Future.delayed(const Duration(milliseconds: 350), () {
                        _showConfirmAddressDialog(
                          type: type,
                          fullAddress: fullAddress,
                          landmark: landmark,
                          phone: phone,
                        );

                        // Dispose controllers after the dialog is shown
                        typeController.dispose();
                        flatController.dispose();
                        localityController.dispose();
                        cityController.dispose();
                        stateController.dispose();
                        pincodeController.dispose();
                        landmarkController.dispose();
                        phoneController.dispose();
                      });
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill all required fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  void _confirmOrder() async {
    if (selectedAddressIndex.value == -1) {
      Get.snackbar(
        'Error',
        'Please select a delivery address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedAddress = savedAddresses[selectedAddressIndex.value];
    final userId = profileController.userId;

    if (userId.isEmpty) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare order data
      final address = selectedAddress['address']!;
      final phone = selectedAddress['phone']!;
      final total = cartController.totalPrice.toStringAsFixed(2);

      // Place the order
      final orderResponse = await orderController.placeOrder(
        userId: userId,
        cartId: userId, // Using userId as cartId since carts are user-specific
        address: address,
        phone: phone,
        paymentRef: 'NA', // Empty for COD
        payStatus: 'pending', // Pending for COD
        total: total,
        paymentMode: 'Cash on Delivery',
        orderRemark: 'Order placed via app',
      );

      if (orderResponse != null && orderResponse.success) {
        // Order placed successfully
        isLoading.value = false;
        _showOrderSuccessDialog();
      } else {
        // Order placement failed
        isLoading.value = false;
        Get.snackbar(
          'Error',
          orderResponse?.message ?? 'Failed to place order. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred while placing your order. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error placing order: $e');
    }
  }

  void _showOrderSuccessDialog() {
    final selectedAddress = savedAddresses[selectedAddressIndex.value];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been confirmed and will be delivered to:',
              style: TextStyle(fontSize: 14, color: AppColors.grey2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.fillSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    selectedAddress['address']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (selectedAddress['city']!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      selectedAddress['city']!,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      cartController.clearCart(); // Clear cart
                      Get.back(); // Go back to previous page
                      Get.snackbar(
                        'Success',
                        'Cart cleared successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      cartController.clearCart(); // Clear cart
                      Get.off(() => const MyOrdersPage()); // Navigate to orders page
                    },
                    child: const Text(
                      'My Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showConfirmAddressDialog({
    required String type,
    required String fullAddress,
    required String landmark,
    required String phone,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm Delivery Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.fillSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.separatorOpaque,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 18,
                        color: AppColors.grey2,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fullAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (landmark.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.push_pin_outlined,
                          size: 18,
                          color: AppColors.grey2,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Landmark: $landmark',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey2,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: AppColors.grey2,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order will be delivered to this address',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.grey3, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog and allow user to edit
                      _showAddAddressBottomSheet(); // Reopen the form
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.grey2,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      Get.back(); // Close dialog
                      await _placeOrderWithCustomAddress(fullAddress, phone);
                    },
                    child: const Text(
                      'Place Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _placeOrderWithCustomAddress(String address, String phone) async {
    final userId = profileController.userId;

    if (userId.isEmpty) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final total = cartController.totalPrice.toStringAsFixed(2);

      // Place the order
      final orderResponse = await orderController.placeOrder(
        userId: userId,
        cartId: userId,
        address: address,
        phone: phone,
        paymentRef: 'NA',
        payStatus: 'pending',
        total: total,
        paymentMode: 'Cash on Delivery',
        orderRemark: 'Order placed via app',
      );

      if (orderResponse != null && orderResponse.success) {
        isLoading.value = false;
        _showOrderSuccessDialogWithAddress(address, phone);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          orderResponse?.message ?? 'Failed to place order. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred while placing your order. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error placing order: $e');
    }
  }

  void _showOrderSuccessDialogWithAddress(String address, String phone) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been confirmed and will be delivered to:',
              style: TextStyle(fontSize: 14, color: AppColors.grey2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.fillSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone: $phone',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      cartController.clearCart(); // Clear cart
                      Get.back(); // Go back to previous page
                      Get.snackbar(
                        'Success',
                        'Cart cleared successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      cartController.clearCart(); // Clear cart
                      Get.off(() => const MyOrdersPage()); // Navigate to orders page
                    },
                    child: const Text(
                      'My Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Shipping Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (isLoadingAddresses.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    const Text(
                      'Select Delivery Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address Cards
                    Obx(
                      () => Column(
                        children: [
                          if (savedAddresses.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.location_off_outlined,
                                    size: 48,
                                    color: AppColors.grey2,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No saved addresses',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.grey2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add your delivery address to continue',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ...savedAddresses.asMap().entries.map((entry) {
                              final index = entry.key;
                              final address = entry.value;
                              final isSelected = selectedAddressIndex.value == index;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () => selectedAddressIndex.value = index,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.separatorOpaque,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Radio Button
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.grey3,
                                              width: 2,
                                            ),
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.transparent,
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 16),

                                        // Address Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      address['type']!,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                address['address']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (address['city']!.isNotEmpty)
                                                Text(
                                                  address['city']!,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.grey2,
                                                  ),
                                                ),
                                              if (address['landmark']!.isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Landmark: ${address['landmark']!}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors.grey2,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(height: 4),
                                              if (address['phone']!.isNotEmpty)
                                                Text(
                                                  address['phone']!,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.grey2,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        // Delete Button (only for non-default addresses)
                                        if (address['type'] != 'Default')
                                          IconButton(
                                            onPressed: () {
                                              savedAddresses.removeAt(index);
                                              if (selectedAddressIndex.value == index) {
                                                selectedAddressIndex.value =
                                                    savedAddresses.isNotEmpty ? 0 : -1;
                                              } else if (selectedAddressIndex.value > index) {
                                                selectedAddressIndex.value--;
                                              }
                                              Get.snackbar(
                                                'Success',
                                                'Address removed',
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                snackPosition: SnackPosition.BOTTOM,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red[400],
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                          const SizedBox(height: 8),

                          // Add New Address Card
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: _showAddAddressBottomSheet,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    const Text(
                                      'Deliver To Different Address ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Order Summary & Confirm Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Order Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '₹${cartController.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Confirm Order Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                      ),
                      onPressed: isLoading.value ? null : _confirmOrder,
                      child: isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Confirm Order',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
