import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: Text(
          'Forget Password',
          style: TextStyle(color: AppColors.backgroundPrimary),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.backgroundPrimary),
        ),
      ),
      backgroundColor: AppColors.darkGreen,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
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
                CtextformField(text: 'Email', icon1: Icon(Icons.person)),
                SizedBox(height: 20),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(fontSize: size.width * 0.045),
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
