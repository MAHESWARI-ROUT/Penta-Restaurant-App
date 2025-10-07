import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/info_pages/about_us_page.dart';
import 'package:penta_restaurant/pages/info_pages/faq_page.dart';
import 'package:penta_restaurant/pages/info_pages/terms_conditions_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        if (profileController.isLoading.value) {
          return ShimmerEffect(child: const ProfileShimmer());
        }

        final profile = profileController.userProfile.value;

        if (profile == null ||
            !profile.success ||
            !profile.message.toLowerCase().contains('verified')) {
          print(profile?.message);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    'You need to signup and verify your account to proceed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                    ),
                    onPressed: () {
                      Get.to(() => const LoginPage());
                    },
                    child: const Text(
                      'Signup & Verify',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
                          top: 40.0,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 247, 199, 127),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Profile',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightYellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.shopping_cart),
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                                  child: profileController.hasProfile
                                      ? Center(
                                          child: Text(
                                            profileController.displayName.isNotEmpty
                                                ? profileController.displayName[0].toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkGreen,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 30,
                                          color: AppColors.darkGreen,
                                        ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${profileController.displayName}\n',
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: profileController.displayEmail.isNotEmpty
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
                                      Get.to(() => const EditProfilePage())?.then((_) {
                                        profileController.refreshProfile();
                                      });
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
                      child: Container(
                        height: 100,
                        width: 400,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.ongoingOrders.value}\n',
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Ongoing',
                                      style: TextStyle(
                                        color: AppColors.grey1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.deliveredOrders.value}\n',
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Delivery',
                                      style: TextStyle(
                                        color: AppColors.grey1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.completedOrders.value}\n',
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Complete',
                                      style: TextStyle(
                                        color: AppColors.grey1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                            ],
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.wallet),
                              const SizedBox(width: 5),
                              const Text('Payment Method'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag_outlined),
                              const SizedBox(width: 5),
                              const Text('Order History'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 5),
                              const Text('My Address'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite_border_outlined),
                              const SizedBox(width: 5),
                              const Text('My Favorite'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.card_giftcard_rounded),
                              const SizedBox(width: 5),
                              const Text('About Us'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const AboutUsPage());
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.help_outline),
                              const SizedBox(width: 5),
                              const Text('FAQ'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const FAQPage());
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.gavel),
                              const SizedBox(width: 5),
                              const Text('Terms & Conditions'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const TermsConditionsPage());
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(() => const LoginPage());
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
}
