import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';

class CtextformField extends StatelessWidget {
  CtextformField({
    super.key,
    required this.text,
    this.isPassword = false,
    this.icon1,
    required this.passwordController,
  });

  final String text;
  final bool isPassword;
  final Icon? icon1;
  final PasswordController passwordController;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? passwordController.isHidden.value : false,
        decoration: InputDecoration(
          prefixIcon: icon1,
          suffixIcon: isPassword
              ? Obx(() => IconButton(
                    icon: Icon(
                      passwordController.isHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: passwordController.toggleVisibility,
                  ))
              : null,
          labelText: text,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
