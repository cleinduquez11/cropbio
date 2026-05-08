import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final int number;
  final String suffix;
  final String label;
  final String description;
  final IconData icon;

  const StatCard({super.key, 
    required this.number,
    required this.suffix,
    required this.label,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: number),
      duration: const Duration(milliseconds: 1200),
      builder: (_, value, __) {
        return SizedBox(
          width: 280,
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: const Color(0xFF3F6B2A),
              ),
              const SizedBox(height: 12),
              Text(
                "$value$suffix",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F6B2A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

