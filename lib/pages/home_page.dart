import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/pages/cart_page.dart';
import 'package:penta_restaurant/pages/edit_profile_page.dart';
import 'package:penta_restaurant/pages/profile_page.dart';
import '../controller/product_controller.dart';
import '../controller/cart_controller.dart'; // Added this import
import '../commons/appcolors.dart';
import '../widgets/category_card.dart';
import '../widgets/product_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RxInt selectedCategoryIndex = 0.obs;
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController()); // Added cart controller

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Explore the taste of Asian Food',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.grey5,
                        radius: 20,
                        child: Icon(Icons.person, color: AppColors.grey2),
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
              controller: controller,
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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }

                // Display all products if 'All' category is selected
                List products;
                if (selectedCategoryIndex.value == 0) {
                  products =
                      controller.categories.expand((cat) => cat.products).toList();
                } else {
                  // Selected category is 1-based index because 0 is 'All'
                  products = controller.categories[selectedCategoryIndex.value - 1].products;
                }

                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductGridItem(
                      key: ValueKey('product-${product.productId}'),
                      product: product,
                      cartController: cartController,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.grey3,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Get.to(() =>  CartPage());
          if (index == 2) Get.to(() => EditProfilePage());
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
