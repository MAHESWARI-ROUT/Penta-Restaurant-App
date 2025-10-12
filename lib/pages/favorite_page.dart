import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';

import '../controller/auth_controller.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final CartController cartController = Get.find<CartController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthController authcontroller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    if (!profileController.isVerified.value) {
      return VerificationErrorPage(
        message: 'Please verify your email to access the cart.',
        userEmail: authcontroller.currentUser.value?.email,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: AppColors.primary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Obx(() {
        if (favoriteController.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: AppColors.primary, size: 60),
                  const SizedBox(height: 24),
                  Text(
                    'No items in your Wishlist',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Try exploring our delicious menu and add your favorites!',
                    style: TextStyle(color: AppColors.labelSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Wrap-based layout instead of GridView.builder
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: favoriteController.favorites.map((product) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 18 * 3) / 2, // 2 columns + spacing
                child: Hero(
                  tag: 'favorite_${product.productId}',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    elevation: 7,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailsPage(
                          product: product,
                          cartController: cartController,
                        ));
                      },
                      child: ProductGridItem(
                        product: product,
                        cartController: cartController,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
