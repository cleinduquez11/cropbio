import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResearchAnalyticsSection extends StatelessWidget {
  ResearchAnalyticsSection({super.key});

  static final List<_ChartData> cropData = [
    _ChartData("Rice", 40),
    _ChartData("Corn", 25),
    _ChartData("Vegetables", 20),
    _ChartData("Root Crops", 15),
  ];

final sdgData = [
  _ChartData("Food Security", 90),
  _ChartData("Biodiversity", 85),
  _ChartData("Climate Adaptation", 80),
  _ChartData("Yield Stability", 75),
];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Research Data Insights",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          "An overview of biodiversity distribution and resilience traits "
          "across ongoing institutional research programs.",
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 60),

        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            return Column(
              children: [
                _analyticsSection(
                  isMobile: isMobile,
                  title: "Crop Diversity Monitoring",
                  description:
                     "CropBio integrates field surveys, UAV campaigns, and Earth observation technologies to monitor crop and cropping diversity across Southeast Asia. The initiative supports long-term biodiversity conservation and sustainable agriculture.",
                  chart: _darkPieChart(cropData),
                ),

                const SizedBox(height: 80),

                _analyticsSection(
                  isMobile: isMobile,
                  title: "Sustainable Food Systems",
                  description:
                     "The project supports SDG 2: Zero Hunger by improving understanding of how crop diversity contributes to food security, resilience, nutrition, and sustainable agricultural production systems.",
                  chart: _darkBarChart(sdgData),
                  reverse: true,
                ),

                const SizedBox(height: 80),

                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Want to know more?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "CropBio is a collaborative initiative led by ESCAP and AIRCAS with research partners from the Philippines, Indonesia, and Malaysia. The project develops scalable methodologies and open geospatial datasets for agricultural sustainability.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 35),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F6B2A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          final box =
                              context.findRenderObject() as RenderBox?;

                          if (box == null) return;

                          final position =
                              box.localToGlobal(Offset.zero);

                          final direction =
                              RouteTransitionHelper
                                  .getDirectionFromPosition(
                            position,
                            MediaQuery.of(context).size,
                          );

                          // Navigator.pushNamed(
                          //   context,
                          //   "/dashboard",
                          //   arguments: direction,
                          // );
                        },
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text(
                          "Explore Full Dashboard",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  static Widget _analyticsSection({
    required bool isMobile,
    required String title,
    required String description,
    required Widget chart,
    bool reverse = false,
  }) {
    final textBlock = Expanded(
      child: _analyticsTextBlock(
        title: title,
        description: description,
      ),
    );

    final chartBlock = Expanded(child: chart);

    if (isMobile) {
      return Column(
        children: [
          textBlock,
          const SizedBox(height: 30),
          chartBlock,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: reverse
          ? [
              chartBlock,
              const SizedBox(width: 60),
              textBlock,
            ]
          : [
              textBlock,
              const SizedBox(width: 60),
              chartBlock,
            ],
    );
  }

  static Widget _analyticsTextBlock({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.8,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  static Widget _darkPieChart(List<_ChartData> data) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(25),
      decoration: _darkChartDecoration(),
      child: SfCircularChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: "Crop Diversity Monitoring",
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries>[
          DoughnutSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            radius: "90%",
            innerRadius: "65%",
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            pointColorMapper: (data, _) {
              switch (data.category) {
                case "Rice":
                  return const Color(0xFF3F6B2A);

                case "Corn":
                  return const Color(0xFFC6A432);

                case "Vegetables":
                  return const Color(0xFF4E7D32);

                default:
                  return const Color(0xFF6B8E23);
              }
            },
          ),
        ],
      ),
    );
  }

  static Widget _darkBarChart(List<_ChartData> data) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(25),
      decoration: _darkChartDecoration(),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: "Sustainable Food Systems",
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          majorGridLines: MajorGridLines(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          ColumnSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            borderRadius: BorderRadius.circular(10),
            spacing: 0.2,
            color: const Color(0xFF3F6B2A),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static BoxDecoration _darkChartDecoration() {
    return BoxDecoration(
      color: const Color(0xFF1E2E1E),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.white.withOpacity(0.08),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 30,
          spreadRadius: 2,
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(0, 12),
        ),
      ],
    );
  }


  
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);
}
