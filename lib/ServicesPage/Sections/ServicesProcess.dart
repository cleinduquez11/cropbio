

import 'package:cropbio/ServicesPage/Widgets/ProcessCard.dart';
import 'package:flutter/material.dart';

class ServiceProcess extends StatelessWidget {
  const ServiceProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        final steps = [
          ProcessStep(
            title: "Request",
            description: "Submit your data or service request.",
            icon: Icons.send,
          ),
          ProcessStep(
            title: "Collect",
            description: "Field data, drone capture, or dataset gathering.",
            icon: Icons.cloud_download,
          ),
          ProcessStep(
            title: "Analyze",
            description: "Processing, validation, and analytics.",
            icon: Icons.analytics,
          ),
          ProcessStep(
            title: "Deliver",
            description: "Final outputs, reports, and datasets.",
            icon: Icons.check_circle,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How It Works",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "A streamlined workflow from request to delivery of research-grade outputs.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 40),
            isMobile
                ? Column(
                    children: steps
                        .map((step) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ProcessCard(step: step),
                            ))
                        .toList(),
                  )
                : Row(
                    children: List.generate(steps.length * 2 - 1, (index) {
                      if (index.isEven) {
                        return Expanded(
                          child: ProcessCard(
                            step: steps[index ~/ 2],
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF3F6B2A),
                          ),
                        );
                      }
                    }),
                  ),
          ],
        );
      },
    );
  }
}
