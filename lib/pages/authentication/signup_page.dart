import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
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
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
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
                    child: CtextformField(
                      text: 'Full Name',
                      icon1: Icon(Icons.person),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Email field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: CtextformField(
                      text: 'Email',
                      icon1: Icon(Icons.email),
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
                  // Mobile field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: CtextformField(
                      text: 'Mobile Number',
                      icon1: Icon(Icons.phone),
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Profession field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: CtextformField(
                      text: 'Profession',
                      icon1: Icon(Icons.work),
                      controller: professionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your profession';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password field
                  CtextformField(
                    text: 'Password',
                    isPassword: true,
                    icon1: Icon(Icons.lock, color: Colors.grey),
                    passwordController: passwordController,
                    controller: passwordTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Obx(() => Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.yellow,
                    ),
                    child: TextButton(
                      onPressed: authController.isLoading.value ? null : _handleSignup,
                      child: authController.isLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  )),
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
                      Get.to(() => LoginPage());
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
      ),
    );
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordTextController.text,
        mobileNum: mobileController.text.trim(),
        profession: professionController.text.trim(),
      );

      if (success) {
        Get.offAll(() => const HomePage());
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordTextController.dispose();
    mobileController.dispose();
    professionController.dispose();
    super.dispose();
  }
}
