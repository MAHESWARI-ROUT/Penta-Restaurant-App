import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';

class RecommendedProductCard extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const RecommendedProductCard({
    Key? key,
    required this.product,
    required this.cartController,
  }) : super(key: key);

  @override
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final ProfileController profileController = Get.find<ProfileController>();

  void toggleFavorite() {
    final userId = widget.cartController.userId;
    if (userId.isEmpty) {
      Get.snackbar('Error', 'Please log in to manage favorites');
      return;
    }
    favoriteController.toggleFavorite(widget.product, userId);
  }

  void _showVariantSelectionDialog() {
    final variants = widget.product.variants;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        int selectedVariantIndex = 0;
        int quantity = 1;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Variant & Quantity',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownButton<int>(
                          value: selectedVariantIndex,
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                          iconEnabledColor: AppColors.primary,
                          items: List.generate(variants.length, (index) {
                            final v = variants[index];
                            return DropdownMenuItem(
                              value: index,
                              child: Text(
                                '${v.variantName} - ₹${v.varPrice}',
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            );
                          }),
                          onChanged: (index) {
                            setState(() {
                              selectedVariantIndex = index!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  backgroundColor: AppColors.grey5,
                                  foregroundColor: AppColors.primary,
                                  elevation: 0,
                                ),
                                onPressed: quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
                                child: Icon(Icons.remove, size: screenWidth * 0.06),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                ),
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(screenWidth * 0.025),
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                onPressed: () => setState(() => quantity++),
                                child: Icon(Icons.add, size: screenWidth * 0.06),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedVariant = variants[selectedVariantIndex];
                        await widget.cartController.addToCart(
                          productId: widget.product.productId,
                          variantId: selectedVariant.varId,
                          productName: widget.product.productName,
                          variantName: selectedVariant.variantName,
                          variantPrice: selectedVariant.varPrice,
                          imageUrl: widget.product.primaryImage,
                          quantity: quantity,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cleanDescription = product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    final screenWidth = MediaQuery.of(context).size.width;
    String priceDisplay = product.variants.isNotEmpty ? product.variants[0].varPrice : product.plimit;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary1.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(
            () => ProductDetailsPage(
              product: widget.product,
              cartController: widget.cartController,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.primaryImage,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.grey5,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // Recommended badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary1],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Recommended',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        final isFav = favoriteController.isFavorite(product);
                        return GestureDetector(
                          onTap: toggleFavorite,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : AppColors.grey2,
                              size: 18,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Product name
                Text(
                  product.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Description
                if (cleanDescription.isNotEmpty)
                  Text(
                    cleanDescription,
                    style: TextStyle(
                      color: AppColors.grey2,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Spacer(),
                const SizedBox(height: 8),
                // Price and Add button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              color: AppColors.grey2,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹$priceDisplay',
                            style: TextStyle(
                              color: AppColors.secondary1,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (!profileController.isVerified.value) {
                              showDialog(
                                context: context,
                                builder: (_) => const UnverifiedUserDialog(),
                              );
                            } else {
                              _showVariantSelectionDialog();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}

