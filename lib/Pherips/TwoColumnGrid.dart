import 'package:cropbio/Widgets/ArticleCard.dart';
import 'package:flutter/material.dart';

class ResponsiveTwoColumnSection extends StatelessWidget {
  final double width;

  const ResponsiveTwoColumnSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    if (width < 800) {
      return Column(
        children: const [
          ArticleCard(
            title: 'Climate-Resilient Crop Varieties',
            body: 'Identifying resilient crops under stress.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Why Crop Biodiversity Matters',
            body: 'Improves food security and soil health.',
          ),
        ],
      );
    }

    return Row(
      children: const [
        Expanded(
          flex: 2,
          child: ArticleCard(
            title: 'Climate-Resilient Crop Varieties',
            body: 'Identifying resilient crops under stress.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: ArticleCard(
            title: 'Why Crop Biodiversity Matters',
            body: 'Improves food security and soil health.',
          ),
        ),
      ],
    );
  }
}
