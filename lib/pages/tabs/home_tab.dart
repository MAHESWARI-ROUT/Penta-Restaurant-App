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
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary1,
                AppColors.secondary1.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),


        //drawer icon button
        leading: Builder(
          builder: (context) => Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
        ),
        title: const Flexible(
          child: Text(
            'Penta Family Restaurant',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        centerTitle: false,

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_rounded, color: Colors.white),
              onPressed: () => Get.to(
                () => const FavoritePage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              ),
              tooltip: 'Wishlist',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8, left: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () => Get.to(
                () => const SearchPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              ),
              tooltip: 'Search',
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
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