import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/tabs/profile_page_new.dart';


void showPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // prevent closing by tapping outside
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); 
        Get.to(() => const ProfilePage()); 
      });

      return AlertDialog(
        title: const Text(
          "Congratulations!!",
          style: TextStyle(color: AppColors.black, fontSize: 20),
        ),
        content: const Text(
          "You successfully updated \n your profile",
          style: TextStyle(color: AppColors.grey1, fontSize: 16),
        ),
      );
    },
  );
}
