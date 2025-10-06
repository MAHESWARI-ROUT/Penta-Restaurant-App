import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';

import '../pages/favorite_page.dart';
import '../pages/my_order_page.dart';
import '../pages/profile/edit_profile_page.dart';
import '../pages/tabs/cart_page.dart';
import '../pages/tabs/profile_page.dart';
import '../pages/tabs/profile_page_new.dart';


class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, required this.onSelectScreen});
  final void Function(String identifier) onSelectScreen;

  final List<Map<String, dynamic>> drawerItems = [
    {
      'title': 'My Cart',
      'icon': Icons.shopping_cart_outlined,
      'action': () => Get.to(() => const CartPage()),
    },
    {
      'title': 'Wishlist',
      'icon': Icons.favorite,
      'action': () => Get.to(() =>  FavoritePage()),
    },
    {
      'title': 'Orders',
      'icon': Icons.receipt_long,
      'action': () => Get.to(() => const MyOrdersPage()),
    },
    // {
    //   'title': 'Coupons',
    //   'icon': Icons.card_giftcard_outlined,
    //   'action': () => Get.to(() => const CouponsPage()),
    // },
    {
      'title': 'Notifications',
      'icon': Icons.notification_add_outlined,
      'action': () => Get.to(() => const NotificationsPage()),
    },
    {
      'title': 'Profile',
      'icon': Icons.account_circle_outlined,
      'action': () => Get.to(() => const ProfilePage()),
    },
    {
      'title': 'Edit Profile',
      'icon': Icons.edit,
      'action': () => Get.to(() => const EditProfilePage()),
    },
    {
      'title': 'Faq',
      'icon': Icons.question_answer_outlined,
      'action':null,
    },
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'action': () {
        Get.snackbar(
          'About Us',
          'This is a sample restaurant app for demonstration purposes.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.yellow,
          colorText: AppColors.black,
        );
      }
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'action': () {
        // Replace with your settings page navigation
        Get.snackbar(
          'Settings',
          'Settings screen coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.yellow,
          colorText: AppColors.black,
        );
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: const Color.fromARGB(100, 0, 0, 0),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 42),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.backgroundPrimary,
                  size: 26,
                ),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close Drawer',
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hey,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Foodie!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              ...drawerItems.map((item) {
                return ListTile(
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
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

              SizedBox(height: 50,),
              ListTile(
                title: Text(
                  'SignOut',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                leading: const Icon(Icons.logout, color: Colors.red),
                onTap: () {
                  Get.to(LoginPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationsPage {
  const NotificationsPage();
}