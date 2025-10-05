import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/pages/cart_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/pages/product_details_page.dart';
import 'package:penta_restaurant/pages/profile/profile_page.dart';
import 'package:penta_restaurant/widgets/main_drawer.dart';
import '../controller/product_controller.dart';
import '../commons/appcolors.dart';
import '../widgets/category_card.dart';
import '../widgets/product_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'categories') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const HomePage()));
    }
  }
  final RxInt selectedCategoryIndex = 0.obs;
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.symmetric( vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:20.0,left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            color: AppColors.black,
                            icon: Icon(Icons.menu),
                          ),
                        ),
                      ),
                      
                      Text(
                        'Explore the taste of Asian Food',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.search, color: AppColors.grey2),
                              const SizedBox(width: 8),
                              const Expanded(
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
                ],
              ),
            ),
          ),
          // Promo Section
          Padding(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                              const SizedBox(height: 4),
                              Expanded(
                                child: const SizedBox(
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
                              ),
                            ],
                          ),
                        ),
                        //const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(
                              'assets/images/icecreame.jpg',
                            ), // Ensure this asset exists
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
      
          // Category Selector
          CategorySelector(
            selectedCategoryIndex: selectedCategoryIndex,
            controller: productController,
          ),
      
          // Recommendations Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      
          // Product Grid
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(productController.errorMessage.value),
                );
              }
              if (productController.categories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }
      
              List products;
              if (selectedCategoryIndex.value == 0) {
                products = productController.categories
                    .expand((cat) => cat.products)
                    .toList();
              } else {
                products = productController
                    .categories[selectedCategoryIndex.value - 1]
                    .products;
              }
      
              if (products.isEmpty) {
                return const Center(child: Text('No products found'));
              }
      
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3/4,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductGridItem(
                    product: product,
                    cartController: cartController,
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.grey3,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Get.to(() => CartPage());
          if (index == 2) Get.to(() => EditProfilePage());
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
