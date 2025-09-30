import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
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
                                onPressed: () {},
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
                            Icon(Icons.account_circle, size: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left:
                      MediaQuery.of(context).size.width / 2 -
                      50, // center horizontally
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey3, // contrast color so it’s visible
                      border: Border.all(
                        color: AppColors.backgroundPrimary,
                        width: 3,
                      ), // outline
                    ),
                    child: Icon(Icons.person, size: 60, color: AppColors.grey1),
                  ),
                ),
                Positioned(
                  top: 209,
                  left: 202,
                  child: Icon(
                    Icons.add_circle,
                    size: 40,
                    color: AppColors.yellow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Full Name'),
                  ),
                  CtextformField(text: 'e.g: Jhon doe'),
                  SizedBox(height: 10),
                  Align(alignment: Alignment.bottomLeft, child: Text('E-mail')),
                  CtextformField(text: 'e.g: Jhonblack@domain.com'),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Mobile phone'),
                  ),
                  CtextformField(text: '(63)1234567892'),
                  SizedBox(height: 10),
                  Align(alignment: Alignment.bottomLeft, child: Text('Gender')),
                  CtextformField(text: 'male'),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                      ),
                      child: Text('Update Profile'),
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
