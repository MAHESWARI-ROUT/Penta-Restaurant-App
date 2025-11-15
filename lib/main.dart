import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/commons/app_theme.dart';
import 'package:penta_restaurant/controller/auth_controller.dart';
import 'package:penta_restaurant/commons/app_constants.dart';

import 'package:penta_restaurant/pages/preload_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // You can make this dynamic based on user preference
      home: PreloadPage(),
    );
  }
}
