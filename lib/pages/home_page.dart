import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import 'package:penta_restaurant/pages/tabs/home_tab.dart';
import 'package:penta_restaurant/pages/tabs/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // The CartPage is removed from the list of main tabs.
    pages = [
      HomeTab(productController: productController, cartController: cartController),
      const ProfilePage(),
    ];
  }

  // Helper widget for standard nav items (Home, Profile) that switch tabs
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.darkGrey, size: 24),
            const SizedBox(width: 8),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper widget specifically for the cart button, which navigates to a new page
  Widget _buildCartNavItem() {
    return GestureDetector(
      // This now navigates to the CartPage as a separate screen
      onTap: () => Get.to(() => const CartPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        color: Colors.transparent,
        child: Obx(() {
          final itemCount = cartController.itemCount;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(Icons.shopping_cart, color: AppColors.darkGrey, size: 26),
              if (itemCount > 0)
                Positioned(
                  top: -4,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: pages[currentIndex], // Shows either HomeTab or ProfilePage
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: AppColors.white,
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
              // Home Tab (index 0)
              _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
              
              // Cart Button (navigates, does not have an index)
              _buildCartNavItem(),

              // Profile Tab (now index 1)
              _buildNavItem(icon: Icons.person, label: 'Profile', index: 1),
            ],
          ),
        ),
      ),
    );
  }
}