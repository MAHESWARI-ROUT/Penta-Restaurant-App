import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  // Observables
  var products = <Product>[].obs;
  var categories = <Category>[].obs;
  var isLoadingProducts = false.obs;
  var isLoadingCategories = false.obs;
  var productError = ''.obs;
  var categoryError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchCategories();
    fetchProducts();
  }

  // void fetchCategories() async {
  //   isLoadingCategories.value = true;
  //   categoryError.value = '';
  //   try {
  //     final result = await _productService.getCategoryList();
  //     categories.assignAll(result);
  //   } catch (e) {
  //     categoryError.value = e.toString();
  //   } finally {
  //     isLoadingCategories.value = false;
  //   }
  // }

  void fetchProducts() async {
    isLoadingProducts.value = true;
    productError.value = '';
    try {
      final result = await _productService.getAllProducts();
      products.assignAll(result);
    } catch (e) {
      productError.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }
}

