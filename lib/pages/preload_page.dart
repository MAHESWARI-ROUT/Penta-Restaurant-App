import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/home_page.dart';

class PreloadPage extends StatelessWidget {
  const PreloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        final storage = GetStorage();
        final userData = storage.read('user_data');
        // Check if user_id exists and is not empty
        final isLoggedIn = userData != null &&
            userData['user_id'] != null &&
            userData['user_id'].toString().isNotEmpty;
        if (isLoggedIn) {
          Get.off(() => const HomePage());
        } else {
          Get.off(() => const LoginPage());
        }
      });
    });
    return Container(
      color: const Color(0xFF1a6f6a),
      child: Padding(
        padding: const EdgeInsets.only(top: 250.0),
        child: Column(
          children: [
            const AppIcon(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
