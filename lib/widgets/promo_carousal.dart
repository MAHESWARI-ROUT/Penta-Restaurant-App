import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        carouselController: _controller,
        itemCount: imageUrls.length,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
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
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
