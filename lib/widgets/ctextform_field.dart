import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';

class CtextformField extends StatefulWidget {
  const CtextformField({
    super.key,
    required this.text,
    this.isPassword = false,
    this.icon1,
    this.passwordController, // optional
  });

  final String text;
  final bool isPassword;
  final Icon? icon1;
  final PasswordController? passwordController;

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
          ? Obx(() {
              // check if passwordController is provided
              final passwordCtrl = widget.passwordController;
              if (passwordCtrl == null) {
                throw Exception(
                  "PasswordController is required when isPassword is true.",
                );
              }

              return TextFormField(
                controller: controller,
                obscureText: passwordCtrl.isHidden.value,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 10.0,
                  ),
                  prefixIcon: widget.icon1,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordCtrl.isHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: passwordCtrl.toggleVisibility,
                  ),
                  labelText: widget.text,
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 16),
                  border: InputBorder.none,
                ),
              );
            })
          : TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 10.0,
                  ),
                prefixIcon: widget.icon1,
                labelText: widget.text,
                labelStyle:
                    const TextStyle(color: Colors.black, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
    );
  }
}
