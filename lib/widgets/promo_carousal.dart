import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/commons/app_constants.dart';
import '../../widgets/shimmer_widgets.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});
  @override
  _PromoCarouselState createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  // Use centralized baseUrl from AppConstants
  final String baseUrl = AppConstants.baseUrl;

  final List<String> imagePaths = [
    'img/1.jpeg',
    'img/2.jpeg',
    'img/3.jpeg',
  ];

  int _currentIndex = 0;
  late List<bool> _isLoadingList;

  @override
  void initState() {
    super.initState();
    _isLoadingList = List<bool>.filled(imagePaths.length, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: imagePaths.length,
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enlargeCenterPage: true,
              viewportFraction: 0.95,
              aspectRatio: screenWidth / (screenHeight * 0.25),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIdx) {
              // Use Uri.resolve to safely combine baseUrl and image path
              final imageUrl = Uri.parse(baseUrl).resolve(imagePaths[index]).toString();

              return ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Visibility(
                      visible: _isLoadingList[index],
                      child: ShimmerEffect(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.grey5,
                            borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.025)),
                          ),
                        ),
                      ),
                    ),
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          if (_isLoadingList[index]) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _isLoadingList[index] = false;
                              });
                            });
                          }
                          return child;
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (_isLoadingList[index]) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _isLoadingList[index] = false;
                            });
                          });
                        }
                        return Container(
                          color: AppColors.grey5,
                          child: Icon(
                            Icons.broken_image,
                            size: screenWidth * 0.12,
                            color: AppColors.grey3,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagePaths.asMap().entries.map((entry) {
              final idx = entry.key;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == idx ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == idx ? AppColors.secondary1 : AppColors.fillSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
