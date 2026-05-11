

import 'package:cropbio/LandingPage/Widgets/Partners.dart';
import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 80,
        horizontal: 20,
      ),

      child: Column(
        children: [

          const Text(
            "In Collaboration With",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          Wrap(
            spacing: 50,
            runSpacing: 30,
            alignment: WrapAlignment.center,

            children: const [

            PartnerLogo(
                name: "MMSU",
                assetPath:
                    "lib/Assets/Agency_Logos/MMSU_SMALL.png",
              ),

              PartnerLogo(
                name: "PhilSA",
                assetPath:
                    "lib/Assets/Agency_Logos/PhilSa_SMALL.png",
              ),

              PartnerLogo(
                name: "CHED",
                assetPath:
                    "lib/Assets/Agency_Logos/CHED_SMALL.png",
              ),

              PartnerLogo(
                name: "UNESCAP",
                assetPath:
                    "lib/Assets/Agency_Logos/unescap.png",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
