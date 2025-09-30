import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PasswordController passwordController = Get.put(PasswordController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                // Logo placeholder
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'MadeFork',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Food Restaurant',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Name field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: CtextformField(text: 'Name',icon1: Icon(Icons.person),)
                ),
                SizedBox(height: 16),
                // Username field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: CtextformField(
                    text: 'Username',
                    icon1: Icon(Icons.person_2),
                  ),
                ),
                SizedBox(height: 16),
                // Password field
                CtextformField(
                  text: 'Password',
                  isPassword: true,
                  icon1: Icon(Icons.lock, color: Colors.grey),
                  passwordController: passwordController,
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.yellow,
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Implement your signup logic here
                      Get.to(HomePage());
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "Already have an Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 14,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
