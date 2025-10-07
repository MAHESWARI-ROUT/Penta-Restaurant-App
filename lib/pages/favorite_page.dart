import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final FavoriteController favoriteController = Get.put(FavoriteController());
  final CartController cartController = Get.find<CartController>();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Wishlist', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: AppColors.darkGreen),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Obx(() {
        final profile = profileController.userProfile.value;

        // Restriction: show login/signup prompt if user not verified
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
                    'You need to sign up and verify your account to access your wishlist.',
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

        // Normal wishlist rendering
        if (favoriteController.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: AppColors.darkGreen, size: 60),
                  const SizedBox(height: 24),
                  Text(
                    'No items in your Wishlist',
                    style: TextStyle(
                      color: AppColors.darkGreen,
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

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 3 / 4.3,
          ),
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final product = favoriteController.favorites[index];
            return Hero(
              tag: 'favorite_${product.productId}',
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                elevation: 7,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailsPage(product: product, cartController: cartController));
                  },
                  child: ProductGridItem(
                    product: product,
                    cartController: cartController,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
