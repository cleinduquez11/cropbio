
import 'package:cropbio/DataPage/Widgets/DataTypeCard.dart';
import 'package:flutter/material.dart';

class DataTypeGrid extends StatelessWidget {
  const DataTypeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      DataType(
        title: "Tabular Data",
        description: "Annual crop summaries, statistics, and reports.",
        icon: Icons.table_chart,
        type: "tabular",
      ),
      DataType(
        title: "Raw Data",
        description: "Crop samples, LAI, ASD, Chlorophyll and laboratoy results",
        icon: Icons.nature,
        type: "raw",
      ),
      DataType(
        title: "Map layers",
        description: "Satellite layers, Vector layers, NDVI, and environmental grids.",
        icon: Icons.layers,
        type: "maplayers",
      ),
      DataType(
        title: "Orthomosaic",
        description: "Drone-stitched high-resolution imagery.",
        icon: Icons.image,
        type: "mosaic",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4; // 💻 large screens
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 4; // 📱 tablet
        } else if (constraints.maxWidth >= 500) {
          crossAxisCount = 2; // 📱 tablet
        } else {
          crossAxisCount = 1; // 📱 mobile
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1, // tweak height/width balance
          ),
          itemBuilder: (context, index) {
            return DataTypeCard(item: items[index]);
          },
        );
      },
    );
  }
}
