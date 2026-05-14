import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VisionText extends StatelessWidget {
  const VisionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Advancing Crop Diversity Through Space Technology",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "CropBio combines Earth observation, UAV monitoring, field surveys, and geospatial analytics to strengthen agricultural resilience, biodiversity conservation, and food security across Southeast Asia.",
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class VisionImage extends StatelessWidget {
  const VisionImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(
        "lib/Assets/Cropbio_clean.svg",
        fit: BoxFit.contain,
      ),
    );
  }
}

