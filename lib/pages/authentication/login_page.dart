import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
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
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: CtextformField(
                      text: 'Email',
                      icon1: Icon(Icons.email, color: Colors.grey),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  CtextformField(
                    text: 'Password',
                    passwordController: passwordController,
                    isPassword: true,
                    icon1: Icon(Icons.lock, color: Colors.grey),
                    controller: passwordTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
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
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.yellow,
                      ),
                      child: TextButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _handleLogin,
                        child: authController.isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Don't have an Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignupPage());
                    },
                    child: Text(
                      'Sign Up',
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
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.login(
        email: emailController.text.trim(),
        password: passwordTextController.text,
      );

      if (success) {
        Get.offAll(() => const HomePage());
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }
}
