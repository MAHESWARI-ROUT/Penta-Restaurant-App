
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/pages/favorite_page.dart';
import 'package:penta_restaurant/pages/search_page.dart';
import 'package:penta_restaurant/widgets/category_card.dart';
import 'package:penta_restaurant/widgets/main_drawer.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';
import 'package:penta_restaurant/widgets/promo_carousal.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';
import 'package:penta_restaurant/widgets/recommended_section.dart'; 

class HomeTab extends StatefulWidget {
  final ProductController productController;
  final CartController cartController;

  const HomeTab({
    super.key,
    required this.productController,
    required this.cartController,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth / 2) - 24;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary1,
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
            onPressed: () => Get.to(() => FavoritePage()),
            tooltip: 'Wishlist',
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () => Get.to(() => SearchPage()),
            tooltip: 'Search',
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: (String identifier) {}),
      body: Obx(() {
        if (widget.productController.isLoading.value && widget.productController.categories.isEmpty) {
          return const HomeTabSkeleton();
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SizedBox(
                  height: 180,
                  child: PromoCarousel(),
                ),
              ),
              CategorySelector(
                selectedCategoryIndex: selectedCategoryIndex,
                controller: widget.productController,
              ),

              const RecommendedSection(),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'All Products',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
                ),
                child: Obx(() {
                  List products;
                  if (selectedCategoryIndex.value == 0) {
                    products = widget.productController.categories.expand((cat) => cat.products).toList();
                  } else if (widget.productController.categories.length > selectedCategoryIndex.value - 1) {
                    products = widget.productController.categories[selectedCategoryIndex.value - 1].products;
                  } else {
                    products = [];
                  }

                  if (products.isEmpty) {
                    return Center(
                      child: ErrorStateWidget( 
                        message: 'No products found',
                        onRetry: () => widget.productController.fetchDataAndLink(),
                        icon: Icons.inventory_2_outlined,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: products.map((product) {
                        return SizedBox(
                          width: itemWidth,
                          child: ProductGridItem(
                            product: product,
                            cartController: widget.cartController,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}