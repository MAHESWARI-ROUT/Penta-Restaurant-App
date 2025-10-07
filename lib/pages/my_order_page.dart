import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/models/my_order_model.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.put(ProfileController());
  final GetStorage _storage = GetStorage();

  String get userId {
    final storedData = _storage.read('user_data');
    if (storedData != null && storedData['userId'] != null) {
      return storedData['userId'] as String;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    await orderController.fetchMyOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => HomePage());
          },
        ),
        title: Text(
          'My Orders',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        final profile = profileController.userProfile.value;

        if (profile == null ||
            !profile.success ||
            !profile.message.toLowerCase().contains('user verified')) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
                  const SizedBox(height: 20),
                  Text(
                    'You need to sign up and verify your account to view your orders.',
                    style: TextStyle(fontSize: 18, color: AppColors.grey2),
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
                    onPressed: () => Get.to(() => LoginPage()),
                    child: const Text(
                      'Sign Up / Verify',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (orderController.isLoadingMyOrders.value &&
            orderController.myOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.errorMessage.value.isNotEmpty &&
            orderController.myOrders.isEmpty) {
          return Center(
            child: Text(
              orderController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (orderController.myOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: AppColors.grey3,
                ),
                const SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your placed orders will appear here.',
                  style: TextStyle(fontSize: 16, color: AppColors.grey3),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _fetchOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderController.myOrders.length,
            itemBuilder: (context, index) {
              final MyOrder order = orderController.myOrders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.orderId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Chip(
                            label: Text(
                              order.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppColors.darkGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.createdAt,
                        style: TextStyle(color: AppColors.grey2, fontSize: 12),
                      ),
                      const Divider(height: 24),
                      ...order.products.map(
                        (product) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            '${product.productName} (${product.variantName}) x ${product.quantity}',
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Total: ', style: TextStyle(fontSize: 16)),
                          Text(
                            '₹${order.totalAmount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
