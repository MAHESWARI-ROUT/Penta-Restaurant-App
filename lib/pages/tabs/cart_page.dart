import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/pages/my_order_page.dart';
import 'package:penta_restaurant/pages/shipping_details_page.dart';

// Import the new files you created
import 'package:penta_restaurant/widgets/address_bottom_sheet.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.put(OrderController());
  final RxBool _showDetailedBill = false.obs;
  final RxList<String> savedAddresses = <String>[
    '123 Main Street, City',
    '456 Park Avenue, City',
  ].obs; // Sample addresses, replace with real data source

  final RxString selectedAddress = ''.obs;

  @override
  void initState() {
    super.initState();
    if (savedAddresses.isNotEmpty) {
      selectedAddress.value = savedAddresses[0];
    }
  }


  void _showOrderSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Order Placed!'),
          ],
        ),
        content: const Text('Your order was placed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); 
              cartController.clearCart();
              Get.offAll(() => const MyOrdersPage());
            },
            child: Text('View My Orders', style: TextStyle(color: AppColors.darkGreen, fontSize: 16)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // This method now navigates to the shipping details page
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
            Text('Add New Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.darkGreen)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  String newAddress = _addressController.text.trim();
                  if (newAddress.isNotEmpty) {
                    savedAddresses.add(newAddress);
                    selectedAddress.value = newAddress;
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please enter an address',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: const Text('Save Address', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.yellow,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
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
            //cart items
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
                                      cartController.updateQuantity(item.productId, item.variantId, item.quantity - 1);
                                    } else {
                                      cartController.removeFromCart(item.productId, item.variantId);
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
                                    cartController.updateQuantity(item.productId, item.variantId, item.quantity + 1);
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

            //show detailed bill section
            Obx(() => InkWell(
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
                        Text(
                          _showDetailedBill.value ? 'Hide Detailed Bill' : 'Show Detailed Bill',
                          style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Icon(
                          _showDetailedBill.value ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.darkGreen,
                        ),
                      ],
                    ),
                  ),
                )),

            //detailed bill section
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
                          Expanded(
                            child: Text(
                              '${item.productName} (${item.variantName}) x${item.quantity}',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('₹${itemTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            //summary row
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28), topRight: Radius.circular(28)),
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
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100,)
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
              onPressed: () {
                _showAddAddressSheet();
              },
              tooltip: 'Add New Address',
            ),
          ],
        ),
      );
    });
  }

}