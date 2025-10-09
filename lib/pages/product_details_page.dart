import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/tabs/cart_page.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';
import '../commons/appcolors.dart';
import '../controller/cart_controller.dart';
import '../controller/favorite_controller.dart';
import '../models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();
    final ProfileController profileController = Get.find<ProfileController>();

    final variant = widget.product.variants.isNotEmpty
        ? widget.product.variants[selectedVariantIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              // Image Section with App Bar
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.45,
                pinned: true,
                backgroundColor: AppColors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: () => Get.to(() => CartPage()),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Obx(() {
                          final itemCount = widget.cartController.itemCount;
                          if (itemCount > 0) {
                            return Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${widget.product.productId}',
                    child: Container(
                      color: AppColors.backgroundSecondary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.product.primaryImage,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 80,
                                color: AppColors.grey2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Product Details Section
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name & Favorite
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.productName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            Obx(() {
                              final isFav = favoriteController.isFavorite(widget.product);
                              return Container(
                                decoration: BoxDecoration(
                                  color: isFav
                                      ? Colors.red.withOpacity(0.1)
                                      : AppColors.backgroundSecondary,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    if (!profileController.isVerified.value) {
                                      Get.snackbar(
                                        'Verification required',
                                        'Please verify your account first.',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        onTap: (_) => Get.to(() =>  VerificationErrorPage(
                                          userName: profileController.displayName,
                                          userEmail: profileController.displayEmail,
                                        )),
                                      );
                                      return;
                                    }

                                    await favoriteController.toggleFavorite(
                                      widget.product,
                                      profileController.userId,
                                    );
                                  },
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : AppColors.grey2,
                                    size: 28,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Price Section
                        if (variant != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  color: AppColors.darkGreen,
                                  size: 24,
                                ),
                                Text(
                                  variant.varPrice,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Variant Selection
                        if (widget.product.variants.isNotEmpty) ...[
                          const Text(
                            'Select Variant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              widget.product.variants.length,
                              (index) {
                                final isSelected = selectedVariantIndex == index;
                                final variantItem = widget.product.variants[index];

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedVariantIndex = index;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.darkGreen
                                          : AppColors.backgroundSecondary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.darkGreen
                                            : AppColors.separatorOpaque,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          variantItem.variantName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${variantItem.varPrice}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.darkGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Description Section
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.product.description.isNotEmpty
                           ? widget.product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()
                              : "No description available",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.grey2,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 100), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final qty = variant != null
                      ? widget.cartController.getQuantity(
                          widget.product.productId,
                          variant.varId,
                        )
                      : 0;

                  return Row(
                    children: [
                      // Add/Quantity Control
                      Expanded(
                        flex: 2,
                        child: qty == 0
                            ? ElevatedButton.icon(
                                onPressed: () async {
                                  if (variant == null) return;
                                  await widget.cartController.addToCart(
                                    productId: widget.product.productId,
                                    variantId: variant.varId,
                                    productName: widget.product.productName,
                                    variantName: variant.variantName,
                                    variantPrice: variant.varPrice,
                                    imageUrl: widget.product.primaryImage,
                                    quantity: 1,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreen,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.darkGreen,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            widget.cartController.updateQuantity(
                                          widget.product.productId,
                                          variant!.varId,
                                          qty - 1,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '$qty',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.darkGreen,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            widget.cartController.updateQuantity(
                                          widget.product.productId,
                                          variant!.varId,
                                          qty + 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),

                      const SizedBox(width: 12),

                      // Checkout Button
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () => Get.to(() => CartPage()),
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors.yellow,
                      //       padding: const EdgeInsets.symmetric(vertical: 16),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(16),
                      //       ),
                      //       elevation: 0,
                      //     ),
                      //     child: const Text(
                      //       "Checkout",
                      //       style: TextStyle(
                      //         color: AppColors.black,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
