import 'dart:ui';

import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/tabs/cart_tab.dart';
import 'package:penta_restaurant/pages/tabs/home_tab.dart';
import 'package:penta_restaurant/pages/tabs/profile_tab.dart';
import '../controller/tab_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabController = Get.put(TabController());
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.put(ProfileController());
  final FavoriteController favoriteController = Get.put(FavoriteController());
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeTab(productController: productController, cartController: cartController),
      CartTab(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: pages[tabController.currentIndex.value],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Blur background layer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ),
            // Nav buttons
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                // transparent to see blur underneath
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
                  _buildNavItem(icon: Icons.shopping_cart, label: 'Cart', index: 1),
                  _buildNavItem(icon: Icons.person, label: 'Profile', index: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    return Obx(() {
      bool isSelected = tabController.currentIndex.value == index;
      return GestureDetector(
        onTap: () => tabController.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary1 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Icon(icon, color: isSelected ? AppColors.darkGrey : AppColors.white, size:isSelected ?28: 24),
                  if (index == 1 && cartController.itemCount > 0) // Cart badge
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartController.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              if (isSelected)
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
