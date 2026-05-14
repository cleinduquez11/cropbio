import 'package:cropbio/AboutUsPage/Widgets/StrengthCard.dart';
import 'package:flutter/material.dart';

class StrengthSection extends StatelessWidget {
  const StrengthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================= TITLE =================
        const Text(
          "What We Do",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Core strengths that drive CropBio’s research, innovation, and impact in agricultural biodiversity.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white54,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 30),

        /// ================= GRID =================
        const StrengthGrid(),
      ],
    );
  }
}

class StrengthGrid extends StatelessWidget {
  const StrengthGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      Strength("Data-Driven Research", Icons.analytics),
      Strength("GIS Integration", Icons.map),
      Strength("Drone Mapping", Icons.flight),
      Strength("Sustainable Agriculture", Icons.eco),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int cols = constraints.maxWidth > 1000
            ? 4
            : constraints.maxWidth > 700
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, i) {
            return StrengthCard(item: items[i]);
          },
        );
      },
    );
  }
}





