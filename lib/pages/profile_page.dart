import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                            ),
                            SizedBox(width: 20),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Jhon Doe \n',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Maple Ave ,New York',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.backgroundSecondary),
                              child: IconButton(
                                padding: EdgeInsets.zero, 
                                  constraints: BoxConstraints(),
                                onPressed: () {Get.to(EditProfilePage());},
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
                                  text: '14 \n',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
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
                          ),
                          Spacer(),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '25 \n',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
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
                          ),
                          Spacer(),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '16 \n',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
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
                            onPressed: () {},
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
  }
}
