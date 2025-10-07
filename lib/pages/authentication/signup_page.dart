import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/password_controller.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const AppIcon(),
                  const SizedBox(height: 40),
                  const Align(
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
                  const SizedBox(height: 24),
                  
                  _buildInput('Full Name', Icons.person, nameController),
                  const SizedBox(height: 16),
                  _buildInput('Email', Icons.email, emailController),
                  const SizedBox(height: 16),
                  _buildInput('Mobile Number', Icons.phone, mobileController),
                  const SizedBox(height: 16),
                  _buildInput('Profession', Icons.work, professionController),
                  const SizedBox(height: 16),
                  CtextformField(
                    text: 'Password',
                    isPassword: true,
                    icon1: const Icon(Icons.lock, color: Colors.grey),
                    passwordController: passwordController,
                    controller: passwordTextController,
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.yellow,
                    ),
                    child: TextButton(
                      onPressed: _handleSignup,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Already have an Account",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const LoginPage()),
                    child: Text(
                      'Login',
                      style: TextStyle(color: AppColors.yellow, fontSize: 14),
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

  Widget _buildInput(String label, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: CtextformField(
        text: label,
        icon1: Icon(icon),
        controller: controller,
        validator: (value) => (value == null || value.isEmpty) ? 'Please enter your $label' : null,
      ),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      Get.to(() => VerificationPage(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
          ));
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
