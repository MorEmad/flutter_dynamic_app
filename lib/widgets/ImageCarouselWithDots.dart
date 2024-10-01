
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageCarouselWithDots extends StatefulWidget {
  final List<String> images;
  final double height;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final double viewportFraction;

  const ImageCarouselWithDots({
    required this.images,
    required this.height,
    required this.autoPlay,
    required this.enlargeCenterPage,
    required this.viewportFraction,
  });

  @override
  _ImageCarouselWithDotsState createState() => _ImageCarouselWithDotsState();
}

class _ImageCarouselWithDotsState extends State<ImageCarouselWithDots> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: widget.enlargeCenterPage,
            viewportFraction: widget.viewportFraction,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10), // Space between carousel and dots
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.images.length,
          effect: const ScrollingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
          ),
          onDotClicked: (index) {
            _controller.animateToPage(index);
          },
        ),
      ],
    );
  }
}
