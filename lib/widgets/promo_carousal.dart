import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import '../../widgets/shimmer_widgets.dart';  // Import shimmer widget

class PromoCarousel extends StatefulWidget {
  @override
  _PromoCarouselState createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> imageUrls = [
    'https://adda.lasolution.in/img/1.jpeg',
    'https://adda.lasolution.in/img/2.jpeg',
    'https://adda.lasolution.in/img/3.jpeg',
  ];

  int _currentIndex = 0;

  // Track loading state of each image
  late List<bool> _isLoadingList;

  @override
  void initState() {
    super.initState();
    _isLoadingList = List<bool>.filled(imageUrls.length, true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        carouselController: _controller,
        itemCount: imageUrls.length,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          viewportFraction: 0.98,
          aspectRatio: 20 / 9,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        itemBuilder: (context, index, realIdx) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Shimmer placeholder shown while loading
                Visibility(
                  visible: _isLoadingList[index],
                  child: const ShimmerEffect(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.grey5,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),

                // Actual image, hidden until loaded
                Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // Image loaded
                      if (_isLoadingList[index]) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isLoadingList[index] = false;
                          });
                        });
                      }
                      return child;
                    } else {
                      // While loading, show nothing (shimmer is already shown)
                      return const SizedBox.shrink();
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Hide shimmer and show error icon if image fails
                    if (_isLoadingList[index]) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _isLoadingList[index] = false;
                        });
                      });
                    }
                    return Container(
                      color: AppColors.grey5,
                      child: const Icon(Icons.broken_image, size: 48, color: AppColors.grey3),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
