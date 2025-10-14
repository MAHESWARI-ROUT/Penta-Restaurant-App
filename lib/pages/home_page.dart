import 'dart:ui';

import 'package:flutter/material.dart' hide TabController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/controller/order_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/pages/tabs/cart_tab.dart';
import 'package:penta_restaurant/pages/tabs/home_tab.dart';
import 'package:penta_restaurant/pages/tabs/profile_tab.dart';
import '../controller/tab_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final tabController = Get.put(TabController());
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.put(ProfileController());
  final FavoriteController favoriteController = Get.put(FavoriteController());
  late final List<Widget> pages;
  late AnimationController _badgeAnimationController;
  late Animation<double> _badgeScaleAnimation;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeTab(productController: productController, cartController: cartController),
      CartTab(),
      const ProfilePage(),
    ];

    _badgeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _badgeScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _badgeAnimationController, curve: Curves.elasticOut),
    );

    // Listen to cart changes to animate badge
    cartController.cartItems.listen((_) {
      if (mounted) {
        _badgeAnimationController.forward().then((_) {
          _badgeAnimationController.reverse();
        });
      }
    });
  }

  @override
  void dispose() {
    _badgeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: pages[tabController.currentIndex.value],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Enhanced glassmorphism background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                     height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey.withAlpha(50),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Nav buttons container
            Container(
              // height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
                  _buildNavItem(icon: Icons.shopping_bag_rounded, label: 'Cart', index: 1),
                  _buildNavItem(icon: Icons.person_rounded, label: 'Profile', index: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    return Obx(() {
      bool isSelected = tabController.currentIndex.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            tabController.changeTab(index);
            // Add haptic feedback
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 16 : 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                colors: [
                  AppColors.secondary1,
                  AppColors.secondary1.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.secondary1.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    if (index == 1 && cartController.itemCount > 0)
                      Positioned(
                        right: -8,
                        top: -6,
                        child: ScaleTransition(
                          scale: _badgeScaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.red, Color(0xFFE53935)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              cartController.itemCount > 99 ? '99+' : cartController.itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isSelected
                      ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

//
// import 'dart:ui';
//
// import 'package:flutter/material.dart' hide TabController;
// import 'package:get/get.dart';
// import 'package:penta_restaurant/commons/appcolors.dart';
// import 'package:penta_restaurant/controller/cart_controller.dart';
// import 'package:penta_restaurant/controller/favorite_controller.dart';
// import 'package:penta_restaurant/controller/order_controller.dart';
// import 'package:penta_restaurant/controller/product_controller.dart';
// import 'package:penta_restaurant/controller/profile_controller.dart';
// import 'package:penta_restaurant/pages/tabs/cart_tab.dart';
// import 'package:penta_restaurant/pages/tabs/home_tab.dart';
// import 'package:penta_restaurant/pages/tabs/profile_tab.dart';
// import '../controller/tab_controller.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final tabController = Get.put(TabController());
//   final ProductController productController = Get.put(ProductController());
//   final CartController cartController = Get.put(CartController());
//   final OrderController orderController = Get.put(OrderController());
//   final ProfileController profileController = Get.put(ProfileController());
//   final FavoriteController favoriteController = Get.put(FavoriteController());
//   late final List<Widget> pages;
//
//   @override
//   void initState() {
//     super.initState();
//     pages = [
//       HomeTab(productController: productController, cartController: cartController),
//       CartTab(),
//       const ProfilePage(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       backgroundColor: AppColors.backgroundSecondary,
//       body: pages[tabController.currentIndex.value],
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Blur background layer
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 45),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(32),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                   child: Container(
//                     height: 45,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(32),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Nav buttons
//             Container(
//               height: 45,
//               margin: const EdgeInsets.symmetric(horizontal: 40),
//               decoration: BoxDecoration(
//                 // transparent to see blur underneath
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(32),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.07),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
//                   _buildNavItem(icon: Icons.shopping_cart, label: 'Cart', index: 1),
//                   _buildNavItem(icon: Icons.person, label: 'Profile', index: 2),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
//
//   Widget _buildNavItem({required IconData icon, required String label, required int index}) {
//     return Obx(() {
//       bool isSelected = tabController.currentIndex.value == index;
//       return GestureDetector(
//         onTap: () => tabController.changeTab(index),
//         child: Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//             decoration: BoxDecoration(
//               color: isSelected ? AppColors.secondary1 : Colors.transparent,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Stack(
//                   children: [
//                     Icon(icon, color: isSelected ? AppColors.darkGrey : AppColors.white, size:isSelected ?28: 24),
//                     if (index == 1 && cartController.itemCount > 0) // Cart badge
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(0.5),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 16,
//                             minHeight: 16,
//                           ),
//                           child: Text(
//                             cartController.itemCount.toString(),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(width: 8),
//                 if (isSelected)
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       color: AppColors.darkGrey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
