import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import '../../widgets/shimmer_widgets.dart'; 

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});
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

  late List<bool> _isLoadingList;

  @override
  void initState() {
    super.initState();
    _isLoadingList = List<bool>.filled(imageUrls.length, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: CarouselSlider.builder(
        carouselController: _controller,
        itemCount: imageUrls.length,
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
                  imageUrls[index],
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
    );
  }
}
