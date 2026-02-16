
import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        children: [
          Text(
            'Mariano Marcos State University (MMSU) • Crop Biodiversity Program',
            style: TextStyle(fontSize: 14, letterSpacing: 0.8),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'Integrating Earth Observation for Agricultural Biodiversity',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
