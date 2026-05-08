import 'package:flutter/material.dart';

class FooterBrand extends StatelessWidget {
  const FooterBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CropBio",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Mariano Marcos State University\nBatac, Ilocos Norte",
          style: TextStyle(
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Links",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _footerLink("About Us"),
        _footerLink("Research"),
        _footerLink("Publications"),
        _footerLink("Contact"),
      ],
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),
    );
  }
}
