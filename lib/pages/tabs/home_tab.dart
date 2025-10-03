import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../commons/appcolors.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_controller.dart';
import '../../widgets/category_card.dart';
import '../../widgets/product_grid_item.dart';
import 'cart_page.dart';
import '../profile/edit_profile_page.dart';
import 'profile_page.dart';

class HomeTab extends StatelessWidget {
  final ProductController productController;
  final CartController cartController;

   HomeTab({
    super.key,
    required this.productController,
    required this.cartController,
  });

  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Sliver for Top Bar
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.yellow,
          expandedHeight: 0,
          toolbarHeight: 120, // Adjust as needed for your design
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Container(
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
                    const SizedBox(height: 12),
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
                        IconButton(
                          icon: Icon(Icons.menu, color: AppColors.darkGrey),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.grey5,
                                        child: Icon(Icons.person, color: AppColors.grey2),
                                      ),
                                      title: Text('Hello, User'),
                                      subtitle: Text('user@email.com'),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text('Profile'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => ProfilePage());
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit Profile'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => EditProfilePage());
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.favorite_border),
                                      title: Text('Wishlist'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Navigate to Wishlist page
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.shopping_cart),
                                      title: Text('Cart'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => CartPage());
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.logout),
                                      title: Text('Logout'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Handle logout logic here
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ...search bar row...
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
          ),
        ),

        // Sliver for Promo Section
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
        ),

        // Product Grid
        Expanded(
          child: Obx(() {
            if (productController.isLoading.value) {
              return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (productController.errorMessage.isNotEmpty) {
              return SliverFillRemaining(
                  child: Center(child: Text(productController.errorMessage.value)));
            }
            if (productController.categories.isEmpty) {
              return SliverFillRemaining(
                  child: Center(child: Text('No categories found')));
            }

            List products;
            if (selectedCategoryIndex.value == 0) {
              products = productController.categories.expand((cat) => cat.products).toList();
            } else {
              products = productController.categories[selectedCategoryIndex.value - 1].products;
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = products[index];
                    return ProductGridItem(
                      product: product,
                      cartController: cartController,
                    );
                  },
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
              ),
            );
          }),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 60,
        child: Container(),))

      ],
    );
  }
}