import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.yellow,
        iconTheme: IconThemeData(color: AppColors.black),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 80, color: AppColors.grey3),
            const SizedBox(height: 16),
            Text(
              'Your order has been placed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.grey2),
            ),
             const SizedBox(height: 8),
            Text(
              'Your orders will appear here.',
              style: TextStyle(fontSize: 16, color: AppColors.grey3),
            ),
          ],
        ),
      ),
    );
  }
}