
import 'package:flutter/foundation.dart' as debug ;
import 'package:get/get.dart';
import 'package:penta_restaurant/models/category_model.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  var categories = <Category>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var recommendedProducts = <Product>[].obs;
  var isRecLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataAndLink();
    fetchRecommendedProducts();
  }

  void fetchRecommendedProducts() async {
    try {
      isRecLoading.value = true;
      final products = await _productService.getRecommendedProducts();
      recommendedProducts.assignAll(products);
    } catch (e) {
      if (debug.kDebugMode) {
        print("Error in controller fetching recommendations: $e");
      }
      recommendedProducts.assignAll([]);
    } finally {
      isRecLoading.value = false;
    }
  }

  void fetchDataAndLink() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final results = await Future.wait([
        _productService.getCategoryList(),
        _productService.getAllProducts(),
      ]);
      final allCategories = results[0] as List<Category>;
      final allProducts = results[1] as List<Product>;
      final linkedCategories = _linkProductsToCategories(allCategories, allProducts);
      categories.assignAll(linkedCategories);
    } catch (e) {
      errorMessage.value = "Failed to load data: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  List<Category> _linkProductsToCategories(List<Category> cats, List<Product> prods) {
    final categoryMap = {for (var cat in cats) cat.catId: cat};
    for (final product in prods) {
      if (product.extra.isNotEmpty) {
        final categoryId = product.extra.first;
        if (categoryMap.containsKey(categoryId)) {
          categoryMap[categoryId]?.products.add(product);
        }
      }
    }
    return cats;
  }
}