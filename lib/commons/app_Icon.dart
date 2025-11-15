import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: 100,
          // height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondary1,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ClipOval(
              child: Image.asset(
                'lib/images/logo_otdc.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // SizedBox(height: 16),
        // Text(
        //   'The Big Plate',
        //   style: TextStyle(
        //     decoration: TextDecoration.none,
        //     color: AppColors.secondary1,
        //     fontSize: 32,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // SizedBox(height: 4),
        // Text(
        //   'Serving Happiness',
        //   style: TextStyle(color: Colors.white, fontSize: 14,decoration: TextDecoration.none,),
        // ),
      ],
    );
  }
}
