import 'package:get/get.dart';

class PasswordController extends GetxController {
  // For multiple password fields, you could use a map, but here we have only one
  var isHidden = true.obs;

  void toggleVisibility() {
    isHidden.value = !isHidden.value;
  }
}
