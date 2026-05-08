import 'package:cropbio/LandingPage/Widgets/StatCard.dart';
import 'package:cropbio/Models/Crop_Summary.dart';
import 'package:cropbio/Providers/LandingPage.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Selector<LandingProvider, CropSummary?>(
      selector: (_, provider) => provider.summaryData,
      builder: (_, summaryData, __) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: layout.verticalPadding * 2,
          ),
          color: const Color(0xFFF4F6F1),
          child: Center(
            child: SizedBox(
              width: layout.contentWidth,
              child: Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  StatCard(
                    number: summaryData?.totalAccessions ?? 0,
                    suffix: "+",
                    label: "Crop Accessions",
                    icon: Icons.eco,
                    description:
                        "Documented plant varieties preserved for research.",
                  ),
                  StatCard(
                    number: summaryData?.totalCropTypes ?? 0,
                    suffix: "",
                    label: "Crop Species",
                    icon: Icons.grass,
                    description:
                        "Crop groups studied across biodiversity programs.",
                  ),
                  StatCard(
                    number: summaryData?.totalFields ?? 0,
                    suffix: "",
                    label: "Experimental Fields",
                    icon: Icons.science,
                    description: "Active research sites supporting monitoring.",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
