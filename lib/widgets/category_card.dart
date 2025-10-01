import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commons/appcolors.dart';
import '../controller/product_controller.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryCard({
    Key? key,
    required this.label,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.darkGreen : AppColors.grey4,
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
                color: isSelected ? AppColors.darkGreen : AppColors.grey5,
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
                          color: isSelected ? AppColors.darkGreen : AppColors.grey2,
                        ),
                      ),
                    )
                  : Icon(
                      icon ?? Icons.fastfood,
                      size: 20,
                      color: isSelected ? AppColors.yellow : AppColors.grey2,
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
    Key? key,
    required this.selectedCategoryIndex,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
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
