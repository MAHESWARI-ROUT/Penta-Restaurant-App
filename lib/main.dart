import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penta_restaurant/controller/favorite_controller.dart';
import 'package:penta_restaurant/pages/preload_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(FavoriteController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  
      debugShowCheckedModeBanner: false,   
      home: PreloadPage(),
    );
  }
}

