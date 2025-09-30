import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var promocode = ''.obs;
  var promocodeApplied = false.obs;
  var promocodeError = ''.obs;

  double get subtotal => items.fold(0, (sum, item) => sum + item.price * item.quantity);
  double get total => subtotal; // Add discount logic if needed
  String get delivery => 'Free';

  void addItem(CartItem item) {
    final index = items.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      items.add(item);
    } else {
      items[index].quantity++;
      items.refresh();
    }
  }

  void removeItem(String id) {
    items.removeWhere((e) => e.id == id);
  }

  void increment(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index].quantity++;
      items.refresh();
    }
  }

  void decrement(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1 && items[index].quantity > 1) {
      items[index].quantity--;
      items.refresh();
    }
  }

  void applyPromocode(String code) {
    // Mock logic: accept 'CREDE2023' as valid
    if (code.trim().toUpperCase() == 'CREDE2023') {
      promocode.value = code.trim();
      promocodeApplied.value = true;
      promocodeError.value = '';
    } else {
      promocodeApplied.value = false;
      promocodeError.value = 'Invalid code';
    }
  }

  void clearPromocode() {
    promocode.value = '';
    promocodeApplied.value = false;
    promocodeError.value = '';
  }
}

