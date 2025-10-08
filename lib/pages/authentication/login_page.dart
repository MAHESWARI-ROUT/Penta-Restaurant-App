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
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 390; // scales fonts relative to width

    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.03,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.04),
                AppIcon(),
                SizedBox(height: size.height * 0.06),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 * textScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login with your account to continue.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14 * textScale,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: CtextformField(
                    text: 'Email',
                    icon1: const Icon(Icons.email, color: Colors.grey),
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
                SizedBox(height: size.height * 0.02),
                CtextformField(
                  text: 'Password',
                  passwordController: passwordController,
                  isPassword: true,
                  icon1: const Icon(Icons.lock, color: Colors.grey),
                  controller: passwordTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordPage()),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12 * textScale,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Obx(
                  () => Container(
                    width: double.infinity,
                    height: size.height * 0.065,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.yellow,
                    ),
                    child: TextButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : _handleLogin,
                      child: authController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Text(
                  "Don't have an Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14 * textScale,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const SignupPage()),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 14 * textScale,
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
