import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/controller/password_controller.dart';

class CtextformField extends StatefulWidget {
  const CtextformField({
    super.key,
    required this.text,
    this.isPassword = false,
    this.icon1,
    this.passwordController,
    this.controller,
    this.validator,
  });

  final String text;
  final bool isPassword;
  final Icon? icon1;
  final PasswordController? passwordController;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<CtextformField> createState() => _CtextformFieldState();
}

class _CtextformFieldState extends State<CtextformField> {
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.025;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: widget.isPassword
          ? Obx(() {
              final passwordCtrl = widget.passwordController;
              if (passwordCtrl == null) {
                throw Exception(
                  "PasswordController is required when isPassword is true.",
                );
              }

              return TextFormField(
                controller: _internalController,
                obscureText: passwordCtrl.isHidden.value,
                validator: widget.validator,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: horizontalPadding,
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
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              );
            })
          : TextFormField(
              controller: _internalController,
              validator: widget.validator,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: horizontalPadding,
                ),
                prefixIcon: widget.icon1,
                labelText: widget.text,
                labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }
}
