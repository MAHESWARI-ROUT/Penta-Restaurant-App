import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: Text(
          'Forget Password',
          style: TextStyle(color: AppColors.backgroundPrimary),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.backgroundPrimary),
        ),
      ),
      backgroundColor: AppColors.darkGreen,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 150,),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Forget password',
                style: TextStyle(color: AppColors.backgroundPrimary,fontSize: 26),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please enter your email address.You will receive a link to create a new password via email.',
              style: TextStyle(color: AppColors.backgroundPrimary,fontSize: 18),
            ),
            SizedBox(height: 20),
            CtextformField(text: 'Email', icon1: Icon(Icons.person)),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                ),
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
