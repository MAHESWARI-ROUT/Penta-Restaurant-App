import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import '../commons/appcolors.dart';
import '../controller/cart_controller.dart';
import '../controller/favorite_controller.dart';
import '../models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final CartController cartController;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController =
        Get.find<FavoriteController>();
    final ProfileController profileController = Get.find<ProfileController>();
    int selectedVariantIndex = 0;
    final variant = product.variants.isNotEmpty
        ? product.variants[selectedVariantIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.productBackground,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.to(() => CartPage()),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.productBackground,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.primaryImage,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.fastfood),
                          ),
                        ),
                      ),

                      Obx(() {
                        final qty = variant != null
                            ? cartController.getQuantity(
                                product.productId,
                                variant.varId,
                              )
                            : 0;

                        return SizedBox(
                          width: double.infinity,
                          child: qty == 0
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (variant == null) return;
                                    await cartController.addToCart(
                                      productId: product.productId,
                                      variantId: variant.varId,
                                      productName: product.productName,
                                      variantName: variant.variantName,
                                      variantPrice: variant.varPrice,
                                      imageUrl: product.primaryImage,
                                      quantity: 1,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkGreen,
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          cartController.updateQuantity(
                                            product.productId,
                                            variant!.varId,
                                            qty - 1,
                                          ),
                                    ),
                                    Text(
                                      '$qty',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          cartController.updateQuantity(
                                            product.productId,
                                            variant!.varId,
                                            qty + 1,
                                          ),
                                    ),
                                  ],
                                ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          product.description.isNotEmpty
                              ? product.description
                              : "No description available",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey2,
                          ),
                        ),
                      ),
                    ),
                    if (product.variants.isNotEmpty)
                      DropdownButton<int>(
                        value: selectedVariantIndex,
                        items: List.generate(
                          product.variants.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(product.variants[index].variantName),
                          ),
                        ),
                        onChanged: (index) {
                          selectedVariantIndex = index ?? 0;
                        },
                      ),
                    const SizedBox(height: 12),

                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final isFav = favoriteController.isFavorite(
                              product,
                            );
                            return ElevatedButton(
                              onPressed: () async {
                                if (!profileController.isVerified.value) {
                                  Get.snackbar(
                                    'Verification required',
                                    'Please verify your account first.',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    onTap: (_) {
                                      Get.to(() => LoginPage());
                                    },
                                  );
                                  return;
                                }

                                await favoriteController.toggleFavorite(
                                  product,
                                  profileController.userId,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkGreen,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Wishlist",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => CartPage()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                            ),
                            child: const Text(
                              "Checkout Now",
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
