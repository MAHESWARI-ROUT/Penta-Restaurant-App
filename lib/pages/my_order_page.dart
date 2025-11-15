import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/models/my_order_model.dart';
import 'package:penta_restaurant/pages/main_layout.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';
import 'package:penta_restaurant/pages/order_details_page.dart';

import '../controller/auth_controller.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthController authcontroller = Get.find<AuthController>();

  final GetStorage _storage = GetStorage();

  String get userId {
    Map<String, dynamic>? storedData = _storage.read('user_data');
    final stored = _storage.read('user_data');
    print('[DEBUG MyOrdersPage] Stored user_data: $stored');

    if (storedData != null && storedData['user_id'] != null) {
      final String id  = storedData['user_id'] ?? '';
      print('[DEBUG MyOrdersPage] Retrieved userId: $id');
      return id;
    }
    print('[DEBUG MyOrdersPage] userId not found in storage');
    return '';
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId.isNotEmpty) {
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    print('[DEBUG MyOrdersPage] _fetchOrders called');
    if (userId.isNotEmpty) {
      print('[DEBUG MyOrdersPage] Calling orderController.fetchMyOrders with userId: $userId');
      await orderController.fetchMyOrders(userId);
      print('[DEBUG MyOrdersPage] fetchMyOrders completed. Orders count: ${orderController.myOrders.length}');
    } else {
      print('[DEBUG MyOrdersPage] Skipping fetch - userId is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!profileController.isVerified.value) {
      return VerificationErrorPage(
        message: 'Please verify your email to access the orders.',
        userEmail: authcontroller.currentUser.value?.email,
        isAppBar: true,
        appbarTitle: "My Orders",
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => const MainLayout());
          },
        ),
        title: Text(
          'My Orders',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondary1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        final profile = profileController.userProfile.value;
        final isLoggedIn = profile != null && profile.success;

        print('[DEBUG MyOrdersPage] Build called - isVerified: ${profileController.isVerified.value}, isLoggedIn: $isLoggedIn');
        print('[DEBUG MyOrdersPage] Loading: ${orderController.isLoadingMyOrders.value}, Orders count: ${orderController.myOrders.length}, Error: "${orderController.errorMessage.value}"');

        // Show login/verify prompt for logged-out users
        // if (!isLoggedIn) {
        //   return Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(24.0),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
        //           const SizedBox(height: 20),
        //           Text(
        //             'Please login or verify your account to view your orders.',
        //             style: const TextStyle(fontSize: 18, color: AppColors.grey2),
        //             textAlign: TextAlign.center,
        //           ),
        //           const SizedBox(height: 28),
        //           ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: AppColors.darkGreen,
        //               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(30),
        //               ),
        //               elevation: 4,
        //             ),
        //             onPressed: () => Get.to(() => const LoginPage()),
        //             child: const Text(
        //               'Login / Verify',
        //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }

        // Show loader while fetching orders
        if (orderController.isLoadingMyOrders.value && orderController.myOrders.isEmpty) {
          print('[DEBUG MyOrdersPage] Showing loading state');
          return const Center(child: CircularProgressIndicator());
        }

        // Show error if fetch fails
        if (orderController.errorMessage.value.isNotEmpty && orderController.myOrders.isEmpty) {
          print('[DEBUG MyOrdersPage] Showing error state: ${orderController.errorMessage.value}');
          return Center(
            child: Text(
              orderController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Show empty state if no orders
        if (orderController.myOrders.isEmpty) {
          print('[DEBUG MyOrdersPage] Showing empty state');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: AppColors.grey3),
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

        // Show orders list
        print('[DEBUG MyOrdersPage] Showing orders list with ${orderController.myOrders.length} orders');
        return RefreshIndicator(
          onRefresh: _fetchOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderController.myOrders.length,
            itemBuilder: (context, index) {
              final MyOrder order = orderController.myOrders[index];
              return InkWell(
                onTap: () {
                  Get.to(
                    () => OrderDetailsPage(order: order),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Order #${order.orderId}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Chip(
                              label: Text(
                                order.status,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: AppColors.grey2),
                            const SizedBox(width: 6),
                            Text(order.createdAt, style: TextStyle(color: AppColors.grey2, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 24),
                        ...order.products.take(2).map(
                          (product) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: AppColors.grey3),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${product.productName} (${product.variantName}) x ${product.quantity}',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (order.products.length > 2)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '+ ${order.products.length - 2} more items',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Tap for details',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Total: ', style: TextStyle(fontSize: 15)),
                                Text(
                                  '₹${order.totalAmount}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
