import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _selectedVariantIndex = 0;
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final String cleanDescription =
        RegExp(r'<[^>]*>').hasMatch(product.description)
            ? product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()
            : product.description;

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
            Expanded(
              flex: 3,
              child: ClipRRect(
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
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.grey,
                      size: screenWidth * 0.08,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      cleanDescription,
                      style: TextStyle(
                        color: AppColors.grey2,
                        fontSize: screenWidth * 0.03,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    _buildVariantAndAddRow(product, priceDisplay, screenWidth, screenHeight),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantAndAddRow(Product product, String priceDisplay, double screenWidth, double screenHeight) {
    final hasVariants = product.variants.isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: hasVariants && product.variants.length > 1
              ? _variantDropdown(product, screenWidth)
              : Text(
                  '₹ $priceDisplay',
                  style: TextStyle(
                    color: AppColors.secondary1,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
        ),
        SizedBox(width: screenWidth * 0.015),
        SizedBox(
          height: screenHeight * 0.035,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            ),
            onPressed: () {
              if (_authController.currentUser.value == null) {
                Get.snackbar(
                  'Not Verified',
                  'Please login and verify to proceed further.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primary,
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
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _variantDropdown(Product product, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
      decoration: BoxDecoration(
        color: AppColors.grey5.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey4, width: 0.7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isDense: true,
          value: _selectedVariantIndex,
          icon: Icon(Icons.keyboard_arrow_down, size: screenWidth * 0.04),
          style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black),
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      '₹ ${product.variants[i].varPrice}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary1,
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
