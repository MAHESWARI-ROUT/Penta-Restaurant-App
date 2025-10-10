import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/tabs/profile_page_new.dart';

void showPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); 
          Get.to(() => const ProfilePage());
        }
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        title: const Text(
          "Congratulations!!",
          style: TextStyle(color: AppColors.black, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "You successfully updated your profile",
          style: TextStyle(color: AppColors.grey1, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}
