import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/widgets/recommended_product_card.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'Recommended Products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Obx(() {
          if (productController.isRecLoading.value) {
            return const ProductRowShimmer();
          }

          if (productController.recommendedProducts.isEmpty) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: productController.recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = productController.recommendedProducts[index];
                return Container(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  margin: const EdgeInsets.only(right: 12),
                  child: RecommendedProductCard(
                    product: product,
                    cartController: cartController,
                  ),
                );
              },
            ),
          );

        }),
      ],
    );
  }
}