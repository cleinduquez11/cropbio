
import 'package:cropbio/ServicesPage/Widgets/ServicesCard.dart';
import 'package:flutter/material.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      Service(
        title: "Drone Mapping",
        description:
            "High-resolution orthomosaic and field analysis using UAVs.",
        icon: Icons.flight,
        route: "/drone",
      ),
      Service(
        title: "GIS & Spatial Analysis",
        description: "Mapping, shapefiles, and geospatial data processing.",
        icon: Icons.map,
        route: "/gis",
      ),
      Service(
        title: "Crop Monitoring",
        description: "NDVI, vegetation health, and temporal analysis.",
        icon: Icons.eco,
        route: "/monitoring",
      ),
      Service(
        title: "Data Analytics",
        description: "Crop statistics, reports, and predictive insights.",
        icon: Icons.analytics,
        route: "/analytics",
      ),
      Service(
        title: "Research Collaboration",
        description: "Partner with us for academic and institutional studies.",
        icon: Icons.groups,
        route: "/collaboration",
      ),
      Service(
        title: "Data Access & API",
        description:
            "Structured datasets available for integration and research.",
        icon: Icons.storage,
        route: "/data",
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800
                ? 3
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (_, i) {
            return ServiceCard(service: services[i]);
          },
        );
      },
    );
  }
}

