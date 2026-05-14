import 'package:cropbio/AboutUsPage/Widgets/InfoBlock.dart';
import 'package:flutter/material.dart';

class MissionVisionSection extends StatelessWidget {
  const MissionVisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return isMobile
            ? Column(
                children: const [
                  InfoBlock(
                    title: "Our Mission",
                    text:
                        "To collect, manage, and disseminate high-quality crop biodiversity data "
                        "that supports scientific research, conservation, and sustainable agriculture.",
                  ),
                  SizedBox(height: 30),
                  InfoBlock(
                    title: "Our Vision",
                    text:
                        "To become a leading digital platform for agricultural biodiversity "
                        "research and innovation in Southeast Asia.",
                  ),
                ],
              )
            : const Row(
                children: [
                  Expanded(
                    child: InfoBlock(
                      title: "Our Mission",
                      text:
                          "To collect, manage, and disseminate high-quality crop biodiversity data "
                          "that supports scientific research, conservation, and sustainable agriculture.",
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: InfoBlock(
                      title: "Our Vision",
                      text:
                          "To become a leading digital platform for agricultural biodiversity "
                          "research and innovation in Southeast Asia.",
                    ),
                  ),
                ],
              );
      },
    );
  }
}
