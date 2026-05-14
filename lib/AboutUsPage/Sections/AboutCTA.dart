import 'package:flutter/material.dart';

class AboutCTA extends StatelessWidget {
  const AboutCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Join Our Research Network",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Collaborate with us in advancing crop biodiversity and agricultural innovation.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6A432),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 18,
            ),
          ),
          onPressed: () {},
          child: Text(
            "Contact Us",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }
}
