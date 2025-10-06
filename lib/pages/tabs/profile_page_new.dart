import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/profile/edit_profile_page.dart';

import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/shimmer_widgets.dart';

import '../info_pages/about_us_page.dart';
import '../info_pages/faq_page.dart';
import '../info_pages/terms_conditions_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ProfileController
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        if (profileController.isLoading.value) {
          return ShimmerEffect(
            child: const ProfileShimmer(),
          );
        }

        if (profileController.errorMessage.value.isNotEmpty && !profileController.hasProfile) {
          return ErrorStateWidget(
            message: profileController.errorMessage.value,
            onRetry: () => profileController.refreshProfile(),
            icon: Icons.person_outline,
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
                        borderRadius: BorderRadius.only(
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
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Profile', style: TextStyle(fontSize: 16)),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightYellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.shopping_cart),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(height: 20),
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
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${profileController.displayName}\n',
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: profileController.displayEmail.isNotEmpty
                                              ? profileController.displayEmail
                                              : profileController.displayMobile,
                                          style: TextStyle(
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
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      Get.to(() => EditProfilePage())?.then((_) {
                                        // Refresh profile when returning from edit page
                                        profileController.refreshProfile();
                                      });
                                    },
                                    icon: Icon(
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
                              offset: Offset(0, 10),
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
                              Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.ongoingOrders.value}\n',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
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
                              Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.deliveredOrders.value}\n',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
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
                              Spacer(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${profileController.completedOrders.value}\n',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
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
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.wallet),
                              SizedBox(width: 5),
                              Text('Payment Method'),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              SizedBox(width: 5),
                              Text('Order History'),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 5),
                              Text('My Address'),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.favorite_border_outlined),
                              SizedBox(width: 5),
                              Text('My favorite'),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.card_giftcard_rounded),
                              SizedBox(width: 5),
                              Text('About Us'),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const AboutUsPage());
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.help_outline),
                              SizedBox(width: 5),
                              Text('FAQ'),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const FAQPage());
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.gavel),
                              SizedBox(width: 5),
                              Text('Terms & Conditions'),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const TermsConditionsPage());
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(LoginPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
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
