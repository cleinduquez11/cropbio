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
          title: "Earth Observation Monitoring",
          description:
              "Utilizing satellite imagery and geospatial technologies to monitor crop conditions, biodiversity patterns, and agricultural landscapes across Southeast Asia.",
        ),
        ResearchCard(
          title: "Crop Diversity Assessment",
          description:
              "Evaluating crop and cropping diversity through standardized field surveys to support sustainable agriculture, genetic conservation, and food security initiatives.",
        ),
        ResearchCard(
          title: "UAV & Remote Sensing",
          description:
              "Integrating UAV-based multispectral imaging and remote sensing applications for high-resolution monitoring of crop health, resilience, and environmental conditions.",
        ),
        ResearchCard(
          title: "Food Security Analytics",
          description:
              "Analyzing agricultural and biodiversity data to understand the relationship between crop diversity, nutrition, yield stability, and sustainable food systems.",
        ),
        ResearchCard(
          title: "Climate Resilience Research",
          description:
              "Investigating resilient agricultural practices and adaptive crop systems to address climate change, environmental stress, and ecosystem sustainability.",
        ),
        ResearchCard(
          title: "Geospatial Data Integration",
          description:
              "Combining field survey information, Earth observation datasets, and GIS technologies into scalable platforms for research, monitoring, and policy support.",
        ),
      ],
    );
  }
}
