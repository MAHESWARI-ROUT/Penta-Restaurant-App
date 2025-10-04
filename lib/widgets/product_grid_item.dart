import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    final variant = widget.product.variants.isNotEmpty
        ? widget.product.variants[0]
        : null;

    return Card(
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
            Expanded(
              flex: 2,
              child: Image.network(
                widget.product.primaryImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.product.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                                ? '₹${variant.varPrice}'
                                : '₹${widget.product.plimit}',
                          ),
                          qty == 0
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (variant != null) {
                                      await widget.cartController.addToCart(
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkGreen,
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                )
                              : Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: () =>
                                          widget.cartController.updateQuantity(
                                            widget.product.productId,
                                            variant!.varId,
                                            qty - 1,
                                          ),
                                    ),
                                    Text('$qty'),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () =>
                                          widget.cartController.updateQuantity(
                                            widget.product.productId,
                                            variant!.varId,
                                            qty + 1,
                                          ),
                                    ),
                                  ],
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
