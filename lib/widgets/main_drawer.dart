import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/info_pages/about_us_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import 'package:penta_restaurant/pages/favorite_page.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, required this.onSelectScreen});
  final void Function(String identifier) onSelectScreen;

  final List<Map<String, dynamic>> drawerItems = [
    {
      'title': 'Login',
      'icon': Icons.login,
      'action': () => Get.to(() => LoginPage()),
    },
    {
      'title': 'My Cart',
      'icon': Icons.shopping_cart_outlined,
      'action': () => Get.to(() => CartPage()),
    },
    {
      'title': 'Wishlist',
      'icon': Icons.favorite_border,
      'action': () => Get.to(() => FavoritePage()),
    },
    {
      'title': 'Edit Profile',
      'icon': Icons.edit,
      'action': () => Get.to(() => EditProfilePage()),
    },
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'action': () => Get.to(() => AboutUsPage()),
    },
    {
      'title': 'Notification',
      'icon': Icons.notification_add_outlined,
      'action': null,
    },
    {'title': 'Help', 'icon': Icons.help_outline_rounded, 'action': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.yellow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.darkGreen,
                    child: Icon(Icons.person, size: 36, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Hello, User",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "user@email.com",
                    style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
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
                    color: AppColors.black,
                  ),
                ),
                leading: Icon(item['icon'], color: AppColors.black),
                onTap: () {
                  Navigator.of(context).pop();
                  final action = item['action'] as VoidCallback?;
                  if (action != null) action();
                },
              );
            }),

            Spacer(),
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
      ),
    );
  }
}
