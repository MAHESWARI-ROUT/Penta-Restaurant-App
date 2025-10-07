import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';

import '../controller/profile_controller.dart';
import '../pages/verification_error_page.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductGridItem({
    Key? key,
    required this.product,
    required this.cartController,
  }) : super(key: key);

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final ProfileController profileController = Get.find<ProfileController>();

  void toggleFavorite() {
    // Assuming you pass userId via cartController or elsewhere for API calls
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

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Variant & Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Variant dropdown takes 2/3 width
                      Expanded(
                        flex: 1,
                        child: DropdownButton<int>(
                          value: selectedVariantIndex,
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: AppColors.darkGreen.withOpacity(0.6),
                          ),
                          iconEnabledColor: AppColors.darkGreen,
                          items: List.generate(variants.length, (index) {
                            final v = variants[index];
                            return DropdownMenuItem(
                              value: index,
                              child: Text(
                                '${v.variantName} - ₹${v.varPrice}',
                                style: const TextStyle(fontSize: 16),
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
                      const SizedBox(width: 16),
                      // Quantity selector takes 1/3 width
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                                backgroundColor: AppColors.grey5,
                                foregroundColor: AppColors.darkGreen,
                                elevation: 0,
                              ),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              child: const Icon(Icons.remove, size: 24),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                                backgroundColor: AppColors.darkGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                              onPressed: () => setState(() => quantity++),
                              child: const Icon(Icons.add, size: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
    final cleanDescription = product.description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(
          () => ProductDetailsPage(
            product: widget.product,
            cartController: widget.cartController,
          ),
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Important: Allows column to shrink-wrap
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with fixed height
            Stack(
              children: [
                Image.network(
                  product.primaryImage,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: AppColors.grey5,
                    child: const Icon(
                      Icons.fastfood,
                      color: Colors.grey,
                      size: 32,
                    ),
                  ),
                ),
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
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Content section - no Expanded or Spacer needed
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1, // Allow for longer names
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (cleanDescription.isNotEmpty)
                    Text(
                      cleanDescription,
                      style: TextStyle(color: AppColors.grey2, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  _buildPriceAndAddRow(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndAddRow(Product product) {
    String priceDisplay = product.variants.isNotEmpty
        ? product.variants[0].varPrice
        : product.plimit;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹ $priceDisplay',
          style: const TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(0, 30),
          ),
          onPressed: () {
            if (!profileController.isVerified.value) {
              showDialog(
                context: context,
                builder: (_) => const UnverifiedUserDialog(),
              );
            } else {
              _showVariantSelectionDialog();
            }
          },
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
