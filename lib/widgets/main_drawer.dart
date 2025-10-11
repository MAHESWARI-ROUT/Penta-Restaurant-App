import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/favorite_page.dart';
import 'package:penta_restaurant/pages/info_pages/about_us_page.dart';
import 'package:penta_restaurant/pages/info_pages/faq_page.dart';
import 'package:penta_restaurant/pages/info_pages/terms_conditions_page.dart';
import 'package:penta_restaurant/pages/my_order_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/pages/tabs/cart_tab.dart';
import 'package:penta_restaurant/pages/tabs/profile_tab.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, required this.onSelectScreen});
  final void Function(String identifier) onSelectScreen;

  final List<Map<String, dynamic>> drawerItems = [
    {
      'title': 'My Cart',
      'icon': Icons.shopping_cart_outlined,
      'action': () => Get.to(() => const CartTab()),
    },
    {
      'title': 'Wishlist',
      'icon': Icons.favorite,
      'action': () => Get.to(() => FavoritePage()),
    },
    {
      'title': 'Orders',
      'icon': Icons.receipt_long,
      'action': () => Get.to(() => const MyOrdersPage()),
    },
    // {
    //   'title': 'Notifications',
    //   'icon': Icons.notification_add_outlined,
    //   'action': () => Get.to(() => const NotificationsPage()),
    // },
    {
      'title': 'Edit Profile',
      'icon': Icons.edit,
      'action': () => Get.to(() => const EditProfilePage()),
    },
    {
      'title': 'Faq',
      'icon': Icons.question_answer_outlined,
      'action': () => Get.to(() => const FAQPage()),
    },
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'action': () => Get.to(() => const AboutUsPage()),
    },
    {
      'title': 'Terms & Conditions',
      'icon': Icons.settings,
      'action': () => Get.to(() => const TermsConditionsPage()),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      width: 300, 
      backgroundColor: const Color.fromARGB(100, 0, 0, 0),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.backgroundPrimary,
                    size: 26,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close Drawer',
                ),
                SizedBox(height: screenHeight * 0.015),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Hey,',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Foodie!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ...drawerItems.map((item) {
                  return ListTile(
                    tileColor: Colors.transparent,
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    leading: Icon(item['icon'], color: AppColors.white),
                    onTap: () {
                      Navigator.of(context).pop();
                      final action = item['action'] as VoidCallback?;
                      if (action != null) action();
                    },
                  );
                }),
                SizedBox(height: screenHeight * 0.03),
                ListTile(
                  tileColor: Colors.transparent,
                  title: Text(
                    'SignOut',
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  onTap: () async {
                    final authController = Get.find<AuthController>();
                    await authController.logout();
                    Get.offAll(LoginPage());
                  },
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsPage {
  const NotificationsPage();
}
