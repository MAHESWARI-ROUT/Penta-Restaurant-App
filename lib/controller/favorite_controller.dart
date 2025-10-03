import 'package:get/get.dart';
import 'package:penta_restaurant/models/product_model.dart';

class FavoriteController extends GetxController {
  final RxList<Product> favorites = <Product>[].obs;

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      favorites.removeWhere((p) => p.productId == product.productId);
    } else {
      favorites.add(product);
    }
  }

  bool isFavorite(Product product) {
    return favorites.any((p) => p.productId == product.productId);
  }
}
