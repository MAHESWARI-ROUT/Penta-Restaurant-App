import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.yellow,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.restaurant_menu,
              size: 60,
              color: AppColors.darkGreen,
            ),
          ),
        ),

        SizedBox(height: 16),
        Text(
          'Penta',
          style: TextStyle(
            decoration: TextDecoration.none,
            color: AppColors.yellow,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Family Restaurant',
          style: TextStyle(color: Colors.white, fontSize: 14,decoration: TextDecoration.none,),
        ),
      ],
    );
  }
}
