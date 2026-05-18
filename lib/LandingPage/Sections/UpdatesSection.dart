import 'package:cropbio/LandingPage/Widgets/UpdateCard.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatesSection extends StatelessWidget {
  const UpdatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutProvider>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: layout.verticalPadding * 2,
        horizontal: 20,
      ),
      color: const Color(0xFF101510),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Latest Updates",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                "Recent activities, field surveys, and research developments from the CropBio initiative.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final mobile = constraints.maxWidth < 900;

                  return GridView.count(
                    crossAxisCount: mobile ? 1 : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: mobile ? 1.15 : 0.9,
                    children: const [
                      UpdateCard(
                        image: "lib/Assets/Sample_Files/Sampless/1.jpg",
                        title:
                            "Field Survey and Crop Diversity Sampling in Dry Season Areas",
                        date: "May 2026",
                      ),

                      UpdateCard(
                        image: "lib/Assets/Sample_Files/Sampless/2.jpg",
                        title:
                            "Hands-on drone training for agricultural monitoring and data collection",
                        date: "April 2026",
                      ),

                      UpdateCard(
                        image: "lib/Assets/Sample_Files/Sampless/3.jpg",
                        title:
                            "Training: Remote Sensing and GIS for Crop Biodiversity Assessment",
                        date: "March 2026",
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 50),

              /// SEE MORE BUTTON
              Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F6B2A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/updates");
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                    label: const Text(
                      "See More Updates",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
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