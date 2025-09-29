import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/models/app_colors.dart';
import 'package:penta_restaurant/pages/authentication/signup_page.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

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
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 250),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
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
              alignment: Alignment.topLeft,
              child: Text(
                'Login with your account to continue',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 15),
            CtextformField(
              text: 'Username',
              passwordController: passwordController,
              icon1: Icon(Icons.account_circle, color: Colors.grey),
            ),
            SizedBox(height: 15),
            CtextformField(
              text: 'Password',
              passwordController: passwordController,
              isPassword: true,
              icon1: Icon(Icons.lock, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'Forget Password?',

                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.yellow,
              ),
              child: TextButton(
                onPressed: () {
                  Get.to(HomePage());
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Donot have an account?',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 0),
            ),
            SizedBox(height: 0),
            TextButton(
              onPressed: () {
                Get.to(SignupPage());
              },
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
