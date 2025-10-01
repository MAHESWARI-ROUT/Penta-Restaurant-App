// lib/controller/product_controller.dart

import 'package:get/get.dart';
import 'package:penta_restaurant/models/category_model.dart'; // <-- ADD THIS LINE
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  // Observables
  var categories = <Category>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataAndLink(); // Call the new combined method
  }

  // NEW: Combined fetching and linking logic
  void fetchDataAndLink() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch categories and products in parallel for better performance
      final results = await Future.wait([
        _productService.getCategoryList(),
        _productService.getAllProducts(),
      ]);

      final allCategories = results[0] as List<Category>;
      final allProducts = results[1] as List<Product>;

      // Link products to their categories
      final linkedCategories = _linkProductsToCategories(allCategories, allProducts);

      categories.assignAll(linkedCategories);

    } catch (e) {
      errorMessage.value = "Failed to load data: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Helper method to map products to categories
  List<Category> _linkProductsToCategories(List<Category> cats, List<Product> prods) {
    // This line was causing the error because the Category model wasn't imported
    final categoryMap = {for (var cat in cats) cat.catId: cat};

    // Iterate through products and add them to the correct category
    for (final product in prods) {
      if (product.extra.isNotEmpty) {
        final categoryId = product.extra.first; // Assuming the first item in 'extra' is the category ID
        if (categoryMap.containsKey(categoryId)) {
          // Add the product to the list inside the correct category
          categoryMap[categoryId]?.products.add(product);
        }
      }
    }

    // Return the updated list of categories
    return cats;
  }
}