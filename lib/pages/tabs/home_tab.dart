import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/widgets/category_card.dart';
import 'package:penta_restaurant/widgets/main_drawer.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';
import '../favorite_page.dart';
import '../search_page.dart';


class HomeTab extends StatefulWidget {
  final ProductController productController;
  final CartController cartController;

  const HomeTab({
    super.key,
    required this.productController,
    required this.cartController,
  }) ;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final RxInt selectedCategoryIndex = 0.obs;
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'categories') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth / 2) - 24;

    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
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
                                Text('Hello! User',
                                    style: TextStyle(
                                        color: AppColors.white, fontSize: 13)),
                                SizedBox(height: 4),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    "Eat gelato like there's no tomorrow!",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage('assets/images/icecreame.jpg'),
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
                              fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '50%',
                          style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
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

          SliverToBoxAdapter(
            child: CategorySelector(
              selectedCategoryIndex: selectedCategoryIndex,
              controller: widget.productController,
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
            if (widget.productController.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            List products;
            if (selectedCategoryIndex.value == 0) {
              products =
                  widget.productController.categories.expand((cat) => cat.products).toList();
            } else if (widget.productController.categories.length >
                selectedCategoryIndex.value - 1) {
              products =
                  widget.productController.categories[selectedCategoryIndex.value - 1].products;
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
                        cartController: widget.cartController,
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
