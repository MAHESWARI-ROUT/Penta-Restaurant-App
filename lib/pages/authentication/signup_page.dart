import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/pages/authentication/verification_page.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PasswordController passwordController = Get.put(PasswordController());
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 390;

    return Scaffold(
      backgroundColor: AppColors.primary,
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
                const AppIcon(),
                SizedBox(height: size.height * 0.05),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 * textScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                _buildInput('Full Name', Icons.person, nameController),
                SizedBox(height: size.height * 0.02),
                _buildInput('Email', Icons.email, emailController),
                SizedBox(height: size.height * 0.02),
                _buildInput('Mobile Number', Icons.phone, mobileController),
                SizedBox(height: size.height * 0.02),
                // _buildInput('Profession', Icons.work, professionController),
                // SizedBox(height: size.height * 0.02),

                CtextformField(
                  text: 'Password',
                  isPassword: true,
                  icon1: const Icon(Icons.lock, color: Colors.grey),
                  passwordController: passwordController,
                  controller: passwordTextController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter your password' : null,
                ),

                SizedBox(height: size.height * 0.04),

                Obx(
                  () => Container(
                    width: double.infinity,
                    height: size.height * 0.065,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.secondary1,
                    ),
                    child: TextButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : _handleSignup,
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
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                Text(
                  "Already have an Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14 * textScale,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.secondary1,
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

  Widget _buildInput(String label, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: CtextformField(
        text: label,
        icon1: Icon(icon, color: Colors.grey),
        controller: controller,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter your $label' : null,
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordTextController.text,
        mobileNum: mobileController.text.trim(),
        profession: '',
      );

      if (success) {
        // Navigate to verification page after successful signup
        Get.off(() => VerificationPage(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
            ));
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
