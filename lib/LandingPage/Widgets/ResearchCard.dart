import 'package:flutter/material.dart';

class ResearchCard extends StatelessWidget {
  final String title;
  final String description;

  const ResearchCard({super.key, 
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.eco, color: Color(0xFF3F6B2A), size: 40),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              height: 1.6,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
