import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import 'package:penta_restaurant/pages/favorite_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final product = widget.product;
    final variant = product.variants.isNotEmpty
        ? product.variants[selectedVariantIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.productBackground,
      body: Stack(
        children: [
          // Main content - header and image section
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.productBackground,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              product.primaryImage,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.grey5,
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: AppColors.grey3,
                                      size: 32,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            // Add button logic if needed
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (_) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.fillQuaternary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Info panel positioned at the bottom half with scroll and buttons
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
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Spacer(),
                        Text(
                          product.plimit,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Text('Description'),
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
                    const SizedBox(height: 12),
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
                          setState(() {
                            selectedVariantIndex = index ?? 0;
                          });
                        },
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => Wishlistpage());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.favorite_border),
                                SizedBox(width: 4),
                                Text(
                                  'Wishlist',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (variant == null) return;
                              bool success = await cartController.addToCart(
                                productId: product.productId,
                                variantId: variant.varId,
                                productName: product.productName,
                                variantName: variant.variantName,
                                variantPrice: variant.varPrice,
                                imageUrl: product.primaryImage,
                                quantity: 1,
                              );
                              print("AddToCart result: $success"); 
                              if (success) {
                                Get.to(() => CartPage());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                            ),
                            child: const Text(
                              'CheckOut Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
