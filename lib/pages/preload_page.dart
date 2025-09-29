import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/home_page.dart';

class PreloadPage extends StatelessWidget {
  const PreloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Get.off(() => LoginPage());
      });
    });
    return Container(
      color: Color(0xFF1a6f6a),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          '  PENTA\nRESTAURANT',
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      /*child: SizedBox(
        child: Image.asset('assets/images/front_screen.png', fit: BoxFit.cover),
      ),*/
    );
  }
}
