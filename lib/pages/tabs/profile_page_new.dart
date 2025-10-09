import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/info_pages/about_us_page.dart';
import 'package:penta_restaurant/pages/info_pages/faq_page.dart';
import 'package:penta_restaurant/pages/info_pages/terms_conditions_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:penta_restaurant/pages/favorite_page.dart';
import 'package:penta_restaurant/pages/my_order_page.dart';
import 'package:penta_restaurant/pages/my_address_page.dart';
import 'package:penta_restaurant/pages/payment_method_page.dart';

import '../authentication/verification_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        // Show shimmer while loading
        if (profileController.isLoading.value) {
          return ShimmerEffect(child: const ProfileShimmer());
        }

        final isLoggedIn = profileController.userProfile.value != null;
        final profile = profileController.userProfile.value;

        // User not logged in or not verified
        if (!profileController.isVerified.value) {
          return Scaffold(
            backgroundColor: AppColors.backgroundSecondary,
            appBar: AppBar(
              backgroundColor: AppColors.yellow,
              elevation: 0,
              title: Text('My Profile', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
                    const SizedBox(height: 20),
                    Text(
                      'Please verify your email to continue.',
                      style: TextStyle(fontSize: 18, color: AppColors.grey2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        final phone = '916370793232';
                        final message =
                            'Verification Request:\n\nName: ${profileController.displayName}\nEmail: ${profileController.displayEmail}\n\nPlease verify this user.';

                        final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Could not open WhatsApp.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text(
                        'Verify Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }
        // Logged-in and verified user UI
        return RefreshIndicator(
          onRefresh: () async => profileController.refreshProfile(),
          color: AppColors.darkGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      247,
                                      199,
                                      127,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Profile',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightYellow,
                                  ),
                                  child: Center(
                                    child: Text(
                                      profileController.displayName.isNotEmpty
                                          ? profileController.displayName[0]
                                                .toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${profileController.displayName}\n',
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              profileController
                                                  .displayEmail
                                                  .isNotEmpty
                                              ? profileController.displayEmail
                                              : profileController.displayMobile,
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.backgroundSecondary,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Get.to(
                                        () => const EditProfilePage(),
                                      )?.then(
                                        (_) =>
                                            profileController.refreshProfile(),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppColors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 190,
                      left: 20,
                      right: 20,
                      child: Obx(
                        () => Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildOrderInfo(
                                  'Ongoing',
                                  profileController.ongoingOrders.value,
                                ),
                                _buildOrderInfo(
                                  'Delivery',
                                  profileController.deliveredOrders.value,
                                ),
                                _buildOrderInfo(
                                  'Complete',
                                  profileController.completedOrders.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _buildMenuCard(Icons.wallet, 'Payment Method', () {
                        Get.to(() => const PaymentMethodPage());
                      }),
                      const SizedBox(height: 10),
                      _buildMenuCard(
                        Icons.shopping_bag_outlined,
                        'Order History',
                        () {
                          Get.to(() => const MyOrdersPage());
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildMenuCard(
                        Icons.location_on_outlined,
                        'My Address',
                        () {
                          Get.to(() => const MyAddressPage());
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildMenuCard(
                        Icons.favorite_border_outlined,
                        'My Favorite',
                        () {
                          Get.to(() => FavoritePage());
                        },
                      ),
                      // const SizedBox(height: 10),
                      // _buildMenuCard(
                      //   Icons.card_giftcard_rounded,
                      //   'About Us',
                      //   () {
                      //     Get.to(() => const AboutUsPage());
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      // _buildMenuCard(Icons.help_outline, 'FAQ', () {
                      //   Get.to(() => const FAQPage());
                      // }),
                      // const SizedBox(height: 10),
                      // _buildMenuCard(Icons.gavel, 'Terms & Conditions', () {
                      //   Get.to(() => const TermsConditionsPage());
                      // }),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final authController = Get.find<AuthController>();
                          await authController.logout();
                          Get.offAll(LoginPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: const [
                              Icon(Icons.logout_outlined, color: Colors.red),
                              SizedBox(width: 5),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderInfo(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.grey1, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMenuCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            Text(title),
            const Spacer(),
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
