import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/pages/my_order_page.dart';

class ShippingDetailsPage extends StatefulWidget {
  const ShippingDetailsPage({Key? key}) : super(key: key);

  @override
  State<ShippingDetailsPage> createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  final CartController cartController = Get.find<CartController>();

  // Sample saved addresses - replace with actual data source
  final RxList<Map<String, String>> savedAddresses = <Map<String, String>>[
    {
      'type': 'Home',
      'address': '123 Main Street, Apartment 4B',
      'city': 'New York, NY 10001',
      'phone': '+1 (555) 123-4567'
    },
    {
      'type': 'Office',
      'address': '456 Business Park, Suite 100',
      'city': 'Manhattan, NY 10005',
      'phone': '+1 (555) 987-6543'
    },
  ].obs;

  final RxInt selectedAddressIndex = (-1).obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Select first address by default if available
    if (savedAddresses.isNotEmpty) {
      selectedAddressIndex.value = 0;
    }
  }

  void _showAddAddressBottomSheet() {
    final TextEditingController typeController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
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
                    'Add New Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.darkGreen,
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
                    borderSide: const BorderSide(color: AppColors.separatorOpaque),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Street Address
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.separatorOpaque),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // City & Postal Code
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City, State, Postal Code',
                  labelStyle: const TextStyle(color: AppColors.grey2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.separatorOpaque),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
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
                    borderSide: const BorderSide(color: AppColors.separatorOpaque),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
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
                    backgroundColor: AppColors.darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    final type = typeController.text.trim();
                    final address = addressController.text.trim();
                    final city = cityController.text.trim();
                    final phone = phoneController.text.trim();

                    if (type.isNotEmpty && address.isNotEmpty && city.isNotEmpty && phone.isNotEmpty) {
                      savedAddresses.add({
                        'type': type,
                        'address': address,
                        'city': city,
                        'phone': phone,
                      });
                      selectedAddressIndex.value = savedAddresses.length - 1;
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Address added successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill all fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    'Save Address',
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

  void _confirmOrder() {
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

    isLoading.value = true;

    // Simulate order processing delay
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      _showOrderSuccessDialog();
    });
  }

  void _showOrderSuccessDialog() {
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
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been confirmed and will be delivered to:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.fillSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                savedAddresses[selectedAddressIndex.value]['address']!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Get.back(); // Close dialog
                  cartController.clearCart(); // Clear cart
                  Get.offAll(() => const MyOrdersPage()); // Navigate to orders page
                },
                child: const Text(
                  'View Orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Shipping Details',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address Cards
                  Obx(() => Column(
                    children: [
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
                                  color: isSelected ? AppColors.darkGreen : AppColors.separatorOpaque,
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
                                        color: isSelected ? AppColors.darkGreen : AppColors.grey3,
                                        width: 2,
                                      ),
                                      color: isSelected ? AppColors.darkGreen : Colors.transparent,
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
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.darkGreen.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                address['type']!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.darkGreen,
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
                                        Text(
                                          address['city']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grey2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
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

                                  // Edit Button
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Implement edit address functionality
                                      Get.snackbar(
                                        'Info',
                                        'Edit address feature coming soon',
                                        backgroundColor: AppColors.yellow,
                                        colorText: AppColors.darkGreen,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.grey2,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

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
                                color: AppColors.darkGreen,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGreen.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.darkGreen,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Add New Address',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
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
                        color: AppColors.darkGreen,
                      ),
                    ),
                    Obx(() => Text(
                      '₹${cartController.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),

                // Confirm Order Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
