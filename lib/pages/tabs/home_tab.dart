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
import 'package:penta_restaurant/controller/favorite_controller.dart';

import '../../commons/app_constants.dart';

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
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth / 2) - 24;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: MainDrawer(onSelectScreen: (String identifier) {}),
      body: Stack(
        children: [
          // Main content with top padding for floating bar
          Padding(
            padding: const EdgeInsets.only(top:120 ),
            child: Obx(() {
              if (widget.productController.isLoading.value && widget.productController.categories.isEmpty) {
                return const HomeTabSkeleton();
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SizedBox(
                        // height: 180,
                        child: PromoCarousel(),
                      ),
                    ),
                    CategorySelector(
                      selectedCategoryIndex: selectedCategoryIndex,
                      controller: widget.productController,
                    ),

                    //const RecommendedSection(),

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
                        minHeight: MediaQuery.of(context).size.height - 72 - MediaQuery.of(context).padding.top,
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
          ),
          // Floating top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(242), // 0.95 * 255 ≈ 242
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20), // 0.08 * 255 ≈ 20
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu_rounded, color: AppColors.secondary1),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        tooltip: 'Menu',
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary1,
                          fontSize: 20,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Obx(() {
                      int favoriteCount = favoriteController.favorites.length;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_rounded, color: AppColors.secondary1),
                            onPressed: () => Get.to(
                              () => const FavoritePage(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 300),
                            ),
                            tooltip: 'Wishlist',
                          ),
                          if (favoriteCount > 0)
                            Positioned(
                              right: -2,
                              top: -1,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                                child: Container(
                                  key: ValueKey<int>(favoriteCount),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white, width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(38), // 0.15 * 255 ≈ 38
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    favoriteCount > 99 ? '99+' : favoriteCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.search_rounded, color: AppColors.secondary1),
                      onPressed: () => Get.to(
                        () => const SearchPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      ),
                      tooltip: 'Search',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}