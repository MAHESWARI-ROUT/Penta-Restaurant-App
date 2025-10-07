import 'package:flutter/material.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import '../commons/appcolors.dart';
import '../models/product_model.dart';
import '../controller/cart_controller.dart';
import '../controller/auth_controller.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductCard({
    Key? key,
    required this.product,
    required this.cartController,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _selectedVariantIndex = 0;
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // Clean description
    final String cleanDescription =
        RegExp(r'<[^>]*>').hasMatch(product.description)
        ? product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()
        : product.description;

    // Determine price to display (selected variant or plimit)
    String priceDisplay;
    if (product.variants.isNotEmpty) {
      if (_selectedVariantIndex >= product.variants.length) {
        _selectedVariantIndex = 0;
      }
      priceDisplay = product.variants[_selectedVariantIndex].varPrice;
    } else {
      priceDisplay = product.plimit;
    }

    return Card(
      key: Key('product-${product.productId}'),
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.primaryImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.grey5,
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cleanDescription,
                      style: TextStyle(color: AppColors.grey2, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _buildVariantAndAddRow(product, priceDisplay),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantAndAddRow(Product product, String priceDisplay) {
    final hasVariants = product.variants.isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: hasVariants && product.variants.length > 1
              ? _variantDropdown(product)
              : Text(
                  '₹ $priceDisplay',
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          height: 26,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () {
              // Check if user is verified
              if (_authController.currentUser.value == null) {
                Get.snackbar(
                  'Not Verified',
                  'Please login and verify to proceed further.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.darkGreen,
                  colorText: AppColors.white,
                );
                return;
              }

             
              String variantId = '';
              String variantName = '';
              String variantPrice;
              if (product.variants.isNotEmpty) {
                final v = product.variants[_selectedVariantIndex];
                variantId = v.varId;
                variantName = v.variantName;
                variantPrice = v.varPrice;
              } else {
                variantPrice = product.plimit;
              }

              

              widget.cartController.addToCart(
                productId: product.productId,
                variantId: variantId,
                productName: product.productName,
                variantName: variantName,
                variantPrice: variantPrice,
                imageUrl: product.primaryImage,
                quantity: 1,
              );
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _variantDropdown(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.grey5.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey4, width: 0.7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isDense: true,
          value: _selectedVariantIndex,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          style: const TextStyle(fontSize: 11, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          items: [
            for (int i = 0; i < product.variants.length; i++)
              DropdownMenuItem<int>(
                value: i,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.variants[i].variantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹ ${product.variants[i].varPrice}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          onChanged: (val) {
            if (val == null) return;
            setState(() => _selectedVariantIndex = val);
          },
        ),
      ),
    );
  }
}
