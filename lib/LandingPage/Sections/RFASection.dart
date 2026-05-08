import 'package:cropbio/LandingPage/Widgets/ResearchCard.dart';
import 'package:flutter/material.dart';

class ResearchGrid extends StatelessWidget {
  const ResearchGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      children: const [
        ResearchCard(
          title: "Genetic Conservation",
          description:
              "Preserving native crop varieties and traditional cultivars.",
        ),
        ResearchCard(
          title: "Climate Resilience",
          description:
              "Developing adaptive crop systems for changing environments.",
        ),
        ResearchCard(
          title: "Sustainable Farming",
          description:
              "Supporting low-impact and high-yield agricultural systems.",
        ),
      ],
    );
  }
}
