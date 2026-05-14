import 'package:flutter/material.dart';

class ServiceCTA extends StatelessWidget {
  const ServiceCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Work With CropBio",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Partner with us for data-driven agricultural research and solutions.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6A432),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          ),
          onPressed: () {},
          child: Text(
            "Request a Service",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }
}
