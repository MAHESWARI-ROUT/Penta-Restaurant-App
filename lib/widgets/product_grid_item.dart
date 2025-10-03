import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commons/appcolors.dart';
import '../controller/cart_controller.dart';
import '../models/product_model.dart';
import '../pages/product_details_page.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final CartController cartController;
  const ProductGridItem({super.key, required this.product, required this.cartController});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  int selectedVariantIndex = 0;

  void _showVariantsPopup() {
    final variants = widget.product.variants;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int tempSelectedIndex = selectedVariantIndex;
        return StatefulBuilder( // Use StatefulBuilder to manage popup's internal state
          builder: (context, setModalState) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Variant:',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: variants.length,
                  separatorBuilder: (_, __) => Divider(color: AppColors.grey4),
                  itemBuilder: (context, index) {
                    final variant = variants[index];
                    final isSelected = tempSelectedIndex == index;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: isSelected ? AppColors.yellow.withOpacity(0.3) : null,
                      selected: isSelected,
                      selectedColor: AppColors.darkGreen,
                      selectedTileColor: AppColors.yellow.withOpacity(0.8),
                      title: Text(
                        variant.variantName,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 15,
                          color: isSelected ? AppColors.darkGreen : Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.darkGreen : AppColors.grey4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '₹ ${variant.varPrice}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      onTap: () {
                        setModalState(() {
                          tempSelectedIndex = index;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedVariantIndex = tempSelectedIndex;
                    });
                    final selectedVariant = variants[selectedVariantIndex];
                    widget.cartController.addToCart(
                      productId: widget.product.productId,
                      variantId: selectedVariant.varId,
                      productName: widget.product.productName,
                      variantName: selectedVariant.variantName,
                      variantPrice: selectedVariant.varPrice,
                      imageUrl: widget.product.primaryImage,
                      quantity: 1,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Add Selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants;
    String displayPrice = '';
    if (variants.isNotEmpty) {
      displayPrice = variants
          .map((v) => double.tryParse(v.varPrice) ?? 0)
          .reduce((a, b) => a < b ? a : b)
          .toStringAsFixed(2);
    } else {
      displayPrice = widget.product.plimit;
    }

    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => ProductDetailsPage(product: widget.product));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with fixed height
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  widget.product.primaryImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        color: AppColors.grey5,
                        child: Icon(
                          Icons.fastfood,
                          color: AppColors.grey3,
                          size: 32,
                        ),
                      ),
                ),
              ),
            ),

            //description
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // product name and description
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        if (variants.length > 1)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orangeAccent),
                            ),
                            child: Text(
                              '${variants.length} variant${variants.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // clean description logic
                      (RegExp(r'<[^>]*>').hasMatch(widget.product.description)
                          ? widget.product.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()
                          : widget.product.description),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.grey2, fontSize: 10),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹ $displayPrice',
                          style: const TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            onPressed: _showVariantsPopup,
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}

