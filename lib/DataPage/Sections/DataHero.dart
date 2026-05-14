import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DataHero extends StatelessWidget {
  const DataHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 50, // 👈 reduced
        horizontal: 20,
      ),
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
              /// 🌱 SMALLER LOGO
              SizedBox(
                height: 90, // 👈 reduced from 130
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_clean.svg",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Crop Biodiversity Data Portal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // 👈 reduced
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              /// SHORT DESCRIPTION
              const Text(
                "Access research datasets including tabular records, GIS layers, and drone imagery.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              /// MINI CTA
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Select a dataset type below",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
