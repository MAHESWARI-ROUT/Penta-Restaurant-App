import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/pages/verification_error_page.dart';



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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  product.primaryImage,
                  height: screenWidth * 0.35,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: screenWidth * 0.35,
                    color: AppColors.grey5,
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.grey,
                      size: screenWidth * 0.08,
                    ),
                  ),
                ),
                Positioned(
                  top: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                  child: Obx(() {
                    final isFav = favoriteController.isFavorite(product);
                    return GestureDetector(
                      onTap: toggleFavorite,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          size: screenWidth * 0.05,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.015),
                  if (cleanDescription.isNotEmpty)
                    Text(
                      cleanDescription,
                      style: TextStyle(color: AppColors.grey2, fontSize: screenWidth * 0.035),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: screenWidth * 0.02),
                  _buildPriceAndAddRow(product, screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndAddRow(Product product, double screenWidth) {
    String priceDisplay = product.variants.isNotEmpty ? product.variants[0].varPrice : product.plimit;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '₹ $priceDisplay',
            style: TextStyle(
              color: AppColors.secondary1,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size(0, screenWidth * 0.08),
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
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
