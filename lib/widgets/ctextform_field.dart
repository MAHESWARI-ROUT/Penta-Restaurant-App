import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';

class CtextformField extends StatefulWidget {
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

  @override
  State<CtextformField> createState() => _CtextformFieldState();
}

class _CtextformFieldState extends State<CtextformField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: widget.isPassword
          ? Obx(() => TextFormField(
        controller: controller,
        obscureText: widget.passwordController.isHidden.value,
        decoration: InputDecoration(
          prefixIcon: widget.icon1,
          suffixIcon: IconButton(
            icon: Icon(
              widget.passwordController.isHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: widget.passwordController.toggleVisibility,
          ),
          labelText: widget.text,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          border: InputBorder.none,
        ),
      ))
          : TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: widget.icon1,
          labelText: widget.text,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
