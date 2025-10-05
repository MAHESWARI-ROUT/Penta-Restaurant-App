import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/models/my_order_model.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    await orderController.fetchMyOrders('123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (orderController.isLoadingMyOrders.value && orderController.myOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.errorMessage.value.isNotEmpty && orderController.myOrders.isEmpty) {
          return Center(child: Text(orderController.errorMessage.value, style: const TextStyle(color: Colors.red)));
        }
        if (orderController.myOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: AppColors.grey3),
                const SizedBox(height: 16),
                Text('No orders yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.grey2)),
                const SizedBox(height: 8),
                Text('Your placed orders will appear here.', style: TextStyle(fontSize: 16, color: AppColors.grey3)),
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
                          Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Chip(
                            label: Text(
                              order.status,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: AppColors.darkGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(order.createdAt, style: TextStyle(color: AppColors.grey2, fontSize: 12)),
                      const Divider(height: 24),
                      
                      // Use the 'products' list from your model
                      ...order.products.map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        // Use 'productName', 'variantName', and 'quantity' from your OrderProduct model
                        child: Text('${product.productName} (${product.variantName}) x ${product.quantity}'),
                      )),
                      
                      const Divider(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Total: ', style: TextStyle(fontSize: 16)),
                          // Use the 'totalAmount' property from your model
                          Text('₹${order.totalAmount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      )
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