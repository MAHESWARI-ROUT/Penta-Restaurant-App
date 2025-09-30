import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/pages/authentication/forget_password_page.dart';
import 'package:penta_restaurant/pages/authentication/signup_page.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

import '../../commons/appcolors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PasswordController passwordController = Get.put(PasswordController());

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
                AppIcon(),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login with your account to continue.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(height: 24),
                CtextformField(
                  text: 'Username',
                  icon1: Icon(Icons.account_circle, color: Colors.grey),
                ),
                SizedBox(height: 16),
                CtextformField(
                  text: 'Password',
                  passwordController: passwordController,
                  isPassword: true,
                  icon1: Icon(Icons.lock, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgetPasswordPage());
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
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
                      Get.to(HomePage());
                    },
                    child: Text(
                      'Login',
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
                  "Don't have Account?",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(SignupPage());
                  },
                  child: Text(
                    'Register Now',
                    style: TextStyle(color: AppColors.yellow, fontSize: 14),
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
