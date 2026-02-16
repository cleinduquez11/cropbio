import 'package:cropbio/Widgets/ArticleCard.dart';
import 'package:flutter/material.dart';

class ResponsiveThreeColumnSection extends StatelessWidget {
  final double width;

  const ResponsiveThreeColumnSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    if (width < 700) {
      return Column(
        children: const [
          ArticleCard(
            title: 'Indigenous Rice Diversity',
            body: 'Mapping traditional rice varieties for conservation.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Coconut & Agroforestry Systems',
            body: 'Analyzing mixed cropping systems.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Open Crop Data Portal',
            body: 'Public geospatial platform for crop diversity.',
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
            child: ArticleCard(
                title: 'Indigenous Rice Diversity',
                body: 'Mapping traditional rice varieties...')),
        SizedBox(width: 16),
        Expanded(
            child: ArticleCard(
                title: 'Coconut & Agroforestry Systems',
                body: 'Analyzing mixed cropping systems...')),
        SizedBox(width: 16),
        Expanded(
            child: ArticleCard(
                title: 'Open Crop Data Portal',
                body: 'Public geospatial platform...')),
      ],
    );
  }
}
