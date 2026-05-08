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
          "Our Mission",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "CropBio is dedicated to preserving genetic diversity, "
          "supporting research innovation, and empowering sustainable "
          "agriculture in the Philippines.",
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
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
        "lib/Assets/Cropbio_Logo_Dark.svg",
        fit: BoxFit.contain,
      ),
    );
  }
}

