import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/profile_page.dart';

void showPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // prevent closing by tapping outside
    builder: (BuildContext context) {
      // Start the delay as soon as the dialog is shown
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); // close the dialog
        Get.to(() => const ProfilePage()); // navigate to ProfilePage
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
