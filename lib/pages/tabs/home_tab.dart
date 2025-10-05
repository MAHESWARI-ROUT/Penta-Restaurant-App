import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/widgets/category_card.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';
import '../favorite_page.dart';
import 'cart_page.dart';
import '../profile/edit_profile_page.dart';
import 'profile_page.dart';

class HomeTab extends StatelessWidget {
  final ProductController productController;
  final CartController cartController;

  HomeTab({
    Key? key,
    required this.productController,
    required this.cartController,
  }) : super(key: key);

  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth / 2) - 24;

    return CustomScrollView(
      slivers: [
        // Your existing SliverAppBar
        SliverAppBar(
          pinned: true,
          floating: true,
          backgroundColor: AppColors.yellow,
          elevation: 0,
          title: Text(
            'Explore Menu',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.darkGrey),
              onPressed: () {
                // Your menu bottom sheet logic
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                           SizedBox(width: 12),
                           Icon(Icons.search, color: AppColors.grey2),
                           SizedBox(width: 8),
                           Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Find for food or restaurant...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.grey3,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.tune, color: AppColors.grey2),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Your Promo / Advertisement Banner Section is restored here
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello! User',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 4),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  "Eat gelato like there's no tomorrow!",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(
                              'assets/images/icecreame.jpg',
                            ),
                            backgroundColor: AppColors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 90,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.fillPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Discount',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '50%',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'All Asian Food',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Sliver for Category Selector
        SliverToBoxAdapter(
          child: CategorySelector(
            selectedCategoryIndex: selectedCategoryIndex,
            controller: productController,
          ),
        ),

        // Sliver for Recommendations Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommendation',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Grid using Wrap for dynamic height
        Obx(() {
          if (productController.isLoading.value) {
            return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // Your product filtering logic
          List products;
          if (selectedCategoryIndex.value == 0) {
            products = productController.categories.expand((cat) => cat.products).toList();
          } else if (productController.categories.length > selectedCategoryIndex.value - 1) {
            products = productController.categories[selectedCategoryIndex.value - 1].products;
          } else {
            products = []; // Handle index out of bounds case
          }

          // Return a SliverToBoxAdapter containing the Wrap widget
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: products.map((product) {
                  return SizedBox(
                    width: itemWidth,
                    child: ProductGridItem(
                      product: product,
                      cartController: cartController,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),

        // Padding at the bottom
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        )
      ],
    );
  }
}