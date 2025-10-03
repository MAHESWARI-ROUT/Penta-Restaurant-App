import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final CartController cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist', style: TextStyle(color: AppColors.black)),
      ),
      body: Obx(() {
        if (favoriteController.favorites.isEmpty) {
          return const Center(child: Text('No items in Wishlist'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final product = favoriteController.favorites[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailsPage(product: product));
              },
              child: ProductGridItem(
                product: product,
                // You may not need cartController here, but if required:
                cartController: cartController,
              ),
            );
          },
        );
      }),
    );
  }
}
