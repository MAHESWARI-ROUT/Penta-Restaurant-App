import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/pages/main_layout.dart';

import '../commons/app_constants.dart';
import '../commons/appcolors.dart';

class PreloadPage extends StatefulWidget {
  const PreloadPage({super.key});

  @override
  _PreloadPageState createState() => _PreloadPageState();
}

class _PreloadPageState extends State<PreloadPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconOpacity;
  late Animation<double> _iconScale;
  late Animation<Offset> _welcomeSlide;
  late Animation<double> _welcomeOpacity;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _iconOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.5, curve: Curves.easeOut)),
    );

    _iconScale = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    _welcomeSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: Curves.easeOut)),
    );

    _welcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)),
    );

    _controller.forward();

    // Control timed navigation after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final storage = GetStorage();
        final userData = storage.read('user_data');
        final isLoggedIn = userData != null &&
            userData['user_id'] != null &&
            userData['user_id'].toString().isNotEmpty;

        if (isLoggedIn) {
          Get.off(() => const MainLayout());
        } else {
          Get.off(() => const LoginPage());
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 250.0),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _iconOpacity.value,
                    child: Transform.scale(
                      scale: _iconScale.value,
                      child: child,
                    ),
                  );
                },
                child: const AppIcon(),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _welcomeSlide,
                child: FadeTransition(
                  opacity: _welcomeOpacity,
                  child: Column(
                    children: const [
                      Text(
                        'Welcome to',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                            color: AppColors.secondary2,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
