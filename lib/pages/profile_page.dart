import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
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
                      Positioned(
                        top: 150,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
