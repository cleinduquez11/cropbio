import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutHero extends StatelessWidget {
  const AboutHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
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
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            children: [
              SizedBox(
                height: 90,
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_clean.svg",
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "About CropBio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "A research-driven platform dedicated to preserving crop biodiversity, "
                "advancing agricultural science, and enabling data-driven decision-making "
                "for sustainable farming systems in the Philippines.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.7,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
