import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/product_controller.dart';
import 'package:penta_restaurant/widgets/product_card.dart';


class CategoryCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryCard({
    super.key,
    required this.label,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 5).clamp(70.0, 120.0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary1 : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey4,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.darkGrey.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.grey5,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        imageUrl!,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(
                          icon ?? Icons.fastfood,
                          color: isSelected ? AppColors.primary : AppColors.grey2,
                        ),
                      ),
                    )
                  : Icon(
                      icon ?? Icons.fastfood,
                      size: 20,
                      color: isSelected ? AppColors.secondary1 : AppColors.grey2,
                    ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.grey2,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final RxInt selectedCategoryIndex;
  final ProductController controller;

  const CategorySelector({
    super.key,
    required this.selectedCategoryIndex,
    required this.controller,
  }) ;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final listHeight = (screenHeight * 0.12).clamp(80.0, 120.0);

    return Obx(() => SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Obx(() {
                if (index == 0) {
                  return CategoryCard(
                    label: 'All',
                    imageUrl: null,
                    isSelected: selectedCategoryIndex.value == 0,
                    onTap: () => selectedCategoryIndex.value = 0,
                    icon: Icons.star,
                  );
                } else {
                  final category = controller.categories[index - 1];
                  return CategoryCard(
                    label: category.categoryName,
                    imageUrl: category.categoryImage,
                    isSelected: selectedCategoryIndex.value == index,
                    onTap: () => selectedCategoryIndex.value = index,
                    icon: Icons.fastfood,
                  );
                }
              });
            },
          ),
        ));
  }
}
