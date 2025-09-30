import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import '../commons/appcolors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    RxInt selectedCategory = 0.obs;

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
                      Expanded(
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
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Find for food or restaurant...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: AppColors.grey3, fontSize: 14),
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
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Hello! Luke Thomp', style: TextStyle(color: AppColors.white, fontSize: 13)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    "Eat gelato like there's no tomorrow!",
                                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage('assets/images/icecream.png'), // Placeholder
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
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.fillPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Discount', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('50%', style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold, fontSize: 22)),
                        const SizedBox(height: 2),
                        Text('All Asian Food', style: TextStyle(color: AppColors.darkGreen, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Category Selector
            Obx(() => SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final isSelected = selectedCategory.value == index;
                  return GestureDetector(
                    onTap: () => selectedCategory.value = index,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.yellow : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.yellow : AppColors.grey4,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          category.categoryImage.isNotEmpty
                              ? Image.network(
                                  category.categoryImage,
                                  height: 28,
                                  width: 28,
                                  errorBuilder: (c, e, s) => Icon(Icons.fastfood, color: isSelected ? AppColors.darkGreen : AppColors.grey2),
                                )
                              : Icon(Icons.fastfood, color: isSelected ? AppColors.darkGreen : AppColors.grey2),
                          const SizedBox(height: 4),
                          Text(
                            category.categoryName,
                            style: TextStyle(
                              color: isSelected ? AppColors.darkGreen : AppColors.grey2,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
            // Recommendations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recommendation', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('See All', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
            // Product Grid and loading/error states
            Expanded(
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.categoryError.isNotEmpty) {
                  return Center(child: Text(controller.categoryError.value));
                }
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }
                // Get products safely
                var productsRaw = controller.categories[selectedCategory.value].products;
                final products = (productsRaw is List) ? productsRaw : [];
                if (products.isEmpty) {
                  return const Center(child: Text('No products found in this category'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    // Get lowest price from variants
                    String price = '';
                    if (product.variants.isNotEmpty) {
                      price = product.variants
                          .map((v) => double.tryParse(v.varPrice) ?? 0)
                          .reduce((a, b) => a < b ? a : b)
                          .toStringAsFixed(2);
                    } else {
                      price = product.plimit;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey5.withValues(alpha: (0.2 * 255)),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.network(
                              product.primaryImage,
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 90,
                                color: AppColors.grey5,
                                child: Icon(Icons.fastfood, color: AppColors.grey3),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.productName, style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(product.description, style: TextStyle(color: AppColors.grey2, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('₱$price', style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.add_shopping_cart, size: 18),
                                label: const Text('Add to cart'),
                              ),
                            ),
                          ),
                        ],
                      ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
