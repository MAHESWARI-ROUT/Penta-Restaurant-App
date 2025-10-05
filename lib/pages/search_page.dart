import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/cart_controller.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/models/product_model.dart';
import 'package:penta_restaurant/widgets/product_grid_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  List<Product> searchResults = [];
  bool isSearching = false;
  String selectedCategory = 'All';
  double minPrice = 0;
  double maxPrice = 1000;
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  void _loadAllProducts() {
    List<Product> allProducts = [];
    for (var category in productController.categories) {
      allProducts.addAll(category.products);
    }
    setState(() {
      searchResults = allProducts;
    });
  }

  void _performSearch(String query) {
    setState(() {
      isSearching = true;
    });

    List<Product> allProducts = [];
    for (var category in productController.categories) {
      allProducts.addAll(category.products);
    }

    List<Product> filtered = allProducts.where((product) {
      final nameMatch = product.productName.toLowerCase().contains(query.toLowerCase());
      final descMatch = product.description.toLowerCase().contains(query.toLowerCase());

      // Category filter (compare by productId)
      bool categoryMatch = selectedCategory == 'All' ||
          productController.categories.any((cat) =>
              cat.categoryName == selectedCategory &&
              cat.products.any((p) => p.productId == product.productId));

      // Price filter
      double productPrice = product.variants.isNotEmpty
          ? double.tryParse(product.variants[0].varPrice) ?? 0
          : double.tryParse(product.plimit) ?? 0;
      bool priceMatch = productPrice >= minPrice && productPrice <= maxPrice;

      // If query is empty, ignore name/desc match, but still apply filters
      bool textMatch = query.isEmpty ? true : (nameMatch || descMatch);

      return textMatch && categoryMatch && priceMatch;
    }).toList();

    setState(() {
      searchResults = filtered;
      isSearching = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      selectedCategory = 'All';
      minPrice = 0;
      maxPrice = 1000;
      showFilters = false;
    });
    _loadAllProducts();
  }

  List<String> _getCategories() {
    List<String> categories = ['All'];
    categories.addAll(productController.categories.map((cat) => cat.categoryName));
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: const Text(
          'Search Products',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFilters ? Icons.filter_list : Icons.filter_list_outlined,
              color: AppColors.darkGreen,
            ),
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.fillSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.separatorOpaque),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                        hintText: 'Search for delicious food...',
                        hintStyle: TextStyle(color: AppColors.grey2),
                        prefixIcon: Icon(Icons.search, color: AppColors.darkGreen),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: _clearSearch,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.clear, color: AppColors.white, size: 20),
                    ),
                  ),
              ],
            ),
          ),

          // Filters Section
          if (showFilters)
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Filter
                  const Text('Category:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.separatorOpaque),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _getCategories().map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                        _performSearch(_searchController.text);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price Range Filter
                  const Text('Price Range:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: AppColors.darkGreen,
                    inactiveColor: AppColors.grey4,
                    labels: RangeLabels('₹${minPrice.round()}', '₹${maxPrice.round()}'),
                    onChanged: (values) {
                      setState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                      _performSearch(_searchController.text);
                    },
                  ),
                ],
              ),
            ),

          // Search Results Count
          if (_searchController.text.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.fillTertiary,
              child: Text(
                '${searchResults.length} results found for "${_searchController.text}"',
                style: const TextStyle(
                  color: AppColors.labelSecondary,
                  fontSize: 14,
                ),
              ),
            ),

          // Search Results
          Expanded(
            child: isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkGreen,
                    ),
                  )
                : searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchController.text.isEmpty ? Icons.search : Icons.search_off,
            size: 64,
            color: AppColors.grey3,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Start searching for your favorite food'
                : 'No products found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.labelSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'Use the search bar above to find delicious meals'
                : 'Try different keywords or adjust filters',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey2,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear Search',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ProductGridItem(
            product: searchResults[index],
            cartController: cartController,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
