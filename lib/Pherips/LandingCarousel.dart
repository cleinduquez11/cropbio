import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

class LandingCarousel extends StatelessWidget {
  final List<String> images;

  const LandingCarousel({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    // Responsive height based on screen size
    double carouselHeight;
    if (layout.isMobile) {
      carouselHeight = 120;
    } else if (layout.isTablet) {
      carouselHeight = 350;
    } else if (layout.isDesktop) {
      carouselHeight = 425;
    } else {
      // Large desktop
      carouselHeight = 500;
    }

    if (images.isEmpty) {
      return SizedBox(
        height: carouselHeight,
        child: Center(
          child: Text(
            'No images available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return SizedBox(
      height: carouselHeight,
      width: double.infinity,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.asset(
            images[index],
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
