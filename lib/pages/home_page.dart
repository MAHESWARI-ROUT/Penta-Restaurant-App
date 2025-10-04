import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import 'package:penta_restaurant/pages/tabs/home_tab.dart';
import 'package:penta_restaurant/widgets/main_drawer.dart';
import '../controller/product_controller.dart';
import '../commons/appcolors.dart';
import '../widgets/category_card.dart';
import '../widgets/product_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // Hold your controllers as before
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  // Define the pages/tabs exactly as widgets here
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize tabs/pages
    pages.addAll([
      // Home tab content — extracted from your current build body for home
      HomeTab(productController: productController, cartController: cartController),
      // Cart tab content
      CartPage(),
      // Profile tab content (could be home profile or EditProfilePage based on your app)
      EditProfilePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: pages[currentIndex], // Show selected tab
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10), // Adjust margin as needed
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
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Tab
            GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? AppColors.yellow : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.home, color: currentIndex == 0 ? Colors.white : AppColors.darkGrey, size: 24),
                    const SizedBox(width: 8),
                    if (currentIndex == 0)
                      const Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Cart Tab
            GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: currentIndex == 1 ? AppColors.yellow : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: currentIndex == 1 ? Colors.white : AppColors.darkGrey, size: 26),
                    const SizedBox(width: 8),
                    if (currentIndex == 1)
                      const Text(
                        'Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Profile Tab
            GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? AppColors.yellow : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: currentIndex == 2 ? Colors.white : AppColors.darkGrey, size: 26),
                    const SizedBox(width: 8),
                    if (currentIndex == 2)
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
      ),
    );
  }
}
