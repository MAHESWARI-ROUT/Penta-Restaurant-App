import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/widgets/category_card.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/promo_carousal.dart';
import '../favorite_page.dart';
import '../search_page.dart';
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

    return Scaffold(
      drawer: MainDrawer(onSelectScreen: (String identifier) {  },),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: AppColors.yellow,
            elevation: 0,
            title: Text(
              'Penta Family Restaurant',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: AppColors.black),
                onPressed: () {
                  Get.to(() => FavoritePage());
                },
                tooltip: 'Wishlist',
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.black),
                onPressed: () {
                  Get.to(() => SearchPage());
                },
                tooltip: 'Search',
              ),
            ],
          ),

          // Your other slivers including promo, categories, recommendation, products, and bottom padding
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 180,
                child: PromoCarousel(),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: CategorySelector(
              selectedCategoryIndex: selectedCategoryIndex,
              controller: productController,
            ),
          ),

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

          Obx(() {
            if (productController.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            List products;
            if (selectedCategoryIndex.value == 0) {
              products =
                  productController.categories.expand((cat) => cat.products).toList();
            } else if (productController.categories.length >
                selectedCategoryIndex.value - 1) {
              products =
                  productController.categories[selectedCategoryIndex.value - 1].products;
            } else {
              products = [];
            }

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

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
