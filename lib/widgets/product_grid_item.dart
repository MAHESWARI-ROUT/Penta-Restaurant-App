import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  void toggleFavorite() {
    favoriteController.toggleFavorite(widget.product);
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
                              child: Text('${v.variantName} - ₹${v.varPrice}',
                                  style: const TextStyle(fontSize: 16)),
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
                              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      )
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
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
  // void _showVariantQuantityPopup(BuildContext context) {
  //   final overlay = Overlay.of(context);
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final Offset buttonPosition = button.localToGlobal(Offset.zero);
  //   final Size buttonSize = button.size;
  //
  //   int selectedVariantIndex = 0;
  //   int quantity = 1;
  //
  //   late OverlayEntry overlayEntry;
  //
  //   void removeOverlay() {
  //     overlayEntry.remove();
  //   }
  //
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: buttonPosition.dx,
  //       top: buttonPosition.dy + buttonSize.height + 5,
  //       width: 300,
  //       child: Material(
  //         elevation: 8,
  //         borderRadius: BorderRadius.circular(16),
  //         color: Colors.white,
  //         child: StatefulBuilder(
  //           builder: (context, setState) {
  //             return Padding(
  //               padding: const EdgeInsets.all(12),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Variant Dropdown
  //                   DropdownButton<int>(
  //                     value: selectedVariantIndex,
  //                     isExpanded: true,
  //                     items: List.generate(widget.product.variants.length, (index) {
  //                       final v = widget.product.variants[index];
  //                       return DropdownMenuItem(
  //                         value: index,
  //                         child: Text('${v.variantName} - ₹${v.varPrice}'),
  //                       );
  //                     }),
  //                     onChanged: (index) {
  //                       setState(() {
  //                         selectedVariantIndex = index!;
  //                       });
  //                     },
  //                   ),
  //
  //                   const SizedBox(height: 8),
  //
  //                   // Quantity selector horizontal
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.remove_circle_outline),
  //                         onPressed: quantity > 1
  //                             ? () => setState(() => quantity--)
  //                             : null,
  //                       ),
  //                       Text(
  //                         quantity.toString(),
  //                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       IconButton(
  //                         icon: const Icon(Icons.add_circle_outline),
  //                         onPressed: () => setState(() => quantity++),
  //                       ),
  //                     ],
  //                   ),
  //
  //                   const SizedBox(height: 12),
  //
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       final variant = widget.product.variants[selectedVariantIndex];
  //                       await widget.cartController.addToCart(
  //                         productId: widget.product.productId,
  //                         variantId: variant.varId,
  //                         productName: widget.product.productName,
  //                         variantName: variant.variantName,
  //                         variantPrice: variant.varPrice,
  //                         imageUrl: widget.product.primaryImage,
  //                         quantity: quantity,
  //                       );
  //                       removeOverlay();
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppColors.darkGreen,
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                       padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
  //                     ),
  //                     child: const Text('Add to Cart'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   overlay.insert(overlayEntry);
  // }


  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants;
    final variant = variants.isNotEmpty ? variants[0] : null;

    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Get.to(
          () => ProductDetailsPage(
            product: widget.product,
            cartController: widget.cartController,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    widget.product.primaryImage,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.grey5,
                      height: 120,
                      child: Center(
                        child: Icon(
                          Icons.fastfood,
                          color: AppColors.grey3,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final isFav = favoriteController.isFavorite(widget.product);
                    return GestureDetector(
                      onTap: toggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.darkGrey.withAlpha(80),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (variants.length > 1)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
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
                    const SizedBox(height: 4),
                    Text(
                      RegExp(r'<[^>]*>').hasMatch(widget.product.description)
                          ? widget.product.description
                                .replaceAll(RegExp(r'<[^>]*>'), '')
                                .trim()
                          : widget.product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.grey2,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      final qty = variant != null
                          ? widget.cartController.getQuantity(
                              widget.product.productId,
                              variant.varId,
                            )
                          : 0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            variant != null
                                ? '₹ ${variant.varPrice}'
                                : '₹ ${widget.product.plimit}',
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _showVariantSelectionDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 0,
                              ),
                            ),
                            child: const Text(
                              "Add",
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
                      );
                    }),
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
