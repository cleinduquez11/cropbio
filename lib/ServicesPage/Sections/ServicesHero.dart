import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServicesHero extends StatelessWidget {
  const ServicesHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F4F2F),
            Color(0xFF1E2E1E),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              SizedBox(
                height: 90,
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_clean.svg",
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "CropBio Research & Data Services",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Empowering agriculture through data, remote sensing, and scientific research.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
