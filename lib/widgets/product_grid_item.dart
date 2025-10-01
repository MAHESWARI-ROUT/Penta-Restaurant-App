import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commons/appcolors.dart';
import '../controller/cart_controller.dart';
import '../models/product_model.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final CartController cartController;
  const ProductGridItem({super.key, required this.product, required this.cartController});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool isExpanded = false;
  int selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final variants = product.variants;

    // lowest price for collapsed state
    String displayPrice = '';
    if (variants.isNotEmpty) {
      displayPrice = variants
          .map((v) => double.tryParse(v.varPrice) ?? 0)
          .reduce((a, b) => a < b ? a : b)
          .toStringAsFixed(2);
    } else {
      displayPrice = product.plimit;
    }

    final cleanDescription = RegExp(r'<[^>]*>').hasMatch(product.description)
        ? product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()
        : product.description;

    return Card(
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
                      errorBuilder: (c, e, s) => Container(
                        color: AppColors.grey5,
                        child: Icon(Icons.fastfood, color: AppColors.grey3, size: 32),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary.withOpacity(0.6)
                        ),
                          child: Icon(Icons.favorite_border_outlined)),
                    )
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cleanDescription,
                      style: const TextStyle(color: AppColors.grey2, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (!isExpanded) _collapsedRow(displayPrice, variants.isNotEmpty && variants.length > 1, variants),
                    if (isExpanded && variants.isNotEmpty) _expandedVariants(variants),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _collapsedRow(String price, bool showVariantsButton, List variants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('₹ $price', style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold, fontSize: 11)),
        Row(
          children: [
            if (showVariantsButton)
              TextButton(
                onPressed: () => setState(() => isExpanded = true),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Variants', style: TextStyle(color: AppColors.darkGreen, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(width: 4),
            SizedBox(
              height: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: () {
                  final variantsList = widget.product.variants;
                  final variant = variantsList.isNotEmpty
                      ? variantsList.reduce((a, b) => (double.tryParse(a.varPrice) ?? 0) < (double.tryParse(b.varPrice) ?? 0) ? a : b)
                      : null;
                  if (variant != null) {
                    widget.cartController.addToCart(
                      productId: widget.product.productId,
                      variantId: variant.varId,
                      productName: widget.product.productName,
                      variantName: variant.variantName,
                      variantPrice: variant.varPrice,
                      imageUrl: widget.product.primaryImage,
                      quantity: 1,
                    );
                  }
                },
                child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _expandedVariants(List variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(color: AppColors.grey4, height: 8),
        Text('Select Variant:', style: TextStyle(color: AppColors.darkGreen, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: variants.length,
            itemBuilder: (context, index) {
              final variant = variants[index];
              final selected = selectedVariantIndex == index;
              return InkWell(
                onTap: () => setState(() => selectedVariantIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.yellow.withOpacity(0.12) : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey4, width: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          variant.variantName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('₹ ${variant.varPrice}', style: const TextStyle(color: AppColors.yellow, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => isExpanded = false),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Close', style: TextStyle(color: AppColors.grey2, fontSize: 10)),
            ),
            SizedBox(
              height: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: () {
                  final selectedVariant = variants[selectedVariantIndex];
                  widget.cartController.addToCart(
                    productId: widget.product.productId,
                    variantId: selectedVariant.variantId,
                    productName: widget.product.productName,
                    variantName: selectedVariant.variantName,
                    variantPrice: selectedVariant.varPrice,
                    imageUrl: widget.product.primaryImage,
                    quantity: 1,
                  );
                  setState(() => isExpanded = false);
                },
                child: const Text('Add Selected', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

