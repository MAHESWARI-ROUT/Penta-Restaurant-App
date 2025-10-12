import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final success = await _authController.forgotPassword(email: email);

      if (success) {
        // Navigate back to login page after successful request
        Future.delayed(Duration(seconds: 2), () {
          Get.back();
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Forget Password',
          style: TextStyle(color: AppColors.backgroundPrimary),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.backgroundPrimary),
        ),
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.18),
                  Text(
                    'Forget password',
                    style: TextStyle(
                      color: AppColors.backgroundPrimary,
                      fontSize: size.width * 0.065, // Scales with screen width
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter your email address. You will receive a link to create a new password via email.',
                    style: TextStyle(
                      color: AppColors.backgroundPrimary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: 20),
                  CtextformField(
                    text: 'Email',
                    icon1: Icon(Icons.person),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : _handleForgotPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary1,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            disabledBackgroundColor: AppColors.secondary1.withOpacity(0.6),
                          ),
                          child: _authController.isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.backgroundPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Send',
                                  style: TextStyle(fontSize: size.width * 0.045),
                                ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
