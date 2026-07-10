import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResearchAnalyticsSection extends StatelessWidget {
  const ResearchAnalyticsSection({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  static const List<_ChartData> protocolComponents = [
    _ChartData("Crop Type & Species", 22),
    _ChartData("Field Boundary", 16),
    _ChartData("Canopy / Leaf Traits", 24),
    _ChartData("LAI & FVC", 16),
    _ChartData("Yield & Agronomy", 14),
    _ChartData("Household Survey", 8),
  ];

  static const List<_ChartData> fieldOutputs = [
    _ChartData("GVG Records", 90),
    _ChartData("Field Boundaries", 85),
    _ChartData("Plot Sheets", 88),
    _ChartData("Trait Data", 82),
    _ChartData("UAV Layers", 78),
    _ChartData("Data Templates", 92),
  ];

  static const List<_ProtocolStep> protocolSteps = [
    _ProtocolStep(
      number: "01",
      title: "GVG Point Sampling",
      description:
          "Record land cover, crop type, species or variety, GPS location, remarks, and field photos using the GVG mobile application.",
      icon: Icons.phone_android_rounded,
    ),
    _ProtocolStep(
      number: "02",
      title: "FieldWatch Boundary Survey",
      description:
          "Map target-field boundaries manually or by walking around the parcel, then attach basic field information and photos.",
      icon: Icons.map_rounded,
    ),
    _ProtocolStep(
      number: "03",
      title: "Plot Establishment",
      description:
          "Set representative plots in uniform crop areas, preferably recognizable from satellite or UAV images, for repeated ground validation.",
      icon: Icons.crop_square_rounded,
    ),
    _ProtocolStep(
      number: "04",
      title: "Crop Trait Measurements",
      description:
          "Collect canopy spectra, leaf spectra, chlorophyll/SPAD, LAI, FVC, crop height, planting density, biomass, and other agronomic indicators.",
      icon: Icons.science_rounded,
    ),
    _ProtocolStep(
      number: "05",
      title: "Yield Observation",
      description:
          "Generate field yield information through crop-cut measurement or FieldWatch-supported yield estimation where applicable.",
      icon: Icons.agriculture_rounded,
    ),
    _ProtocolStep(
      number: "06",
      title: "Standard Data Submission",
      description:
          "Export and organize field records, KML/CSV outputs, plot sheets, and measurement templates for integration into the shared CropBio repository.",
      icon: Icons.dataset_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mainTitle(layout),
        SizedBox(height: layout.isMobile ? 24 : 34),
        _overviewCards(layout),
        SizedBox(height: layout.isMobile ? 34 : 54),
        _analyticsSection(
          layout: layout,
          title: "In-situ Protocol Coverage",
          description:
              "The CropBio field workflow combines point-based GVG sampling, parcel-scale FieldWatch boundary mapping, plot survey measurements, canopy and leaf trait observations, yield documentation, and household-level information. This section summarizes the main components of the in-situ protocol as a dashboard-ready view.",
          chart: _protocolDoughnutChart(protocolComponents),
        ),
        SizedBox(height: layout.isMobile ? 38 : 60),
        _analyticsSection(
          layout: layout,
          title: "Field Data Readiness",
          description:
              "The in-situ protocol is designed to generate standardized and reusable field products: sampling points, field boundaries, plot sheets, trait measurements, UAV-ready validation layers, and data templates for submission and sharing.",
          chart: _fieldOutputBarChart(fieldOutputs),
          reverse: true,
        ),
        SizedBox(height: layout.isMobile ? 38 : 60),
        _protocolWorkflow(layout),
        SizedBox(height: layout.isMobile ? 36 : 56),
        _learnMorePanel(context, layout),
      ],
    );
  }

  Widget _mainTitle(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _smallBadge(
          icon: Icons.analytics_rounded,
          label: "Research Analytics",
        ),
        const SizedBox(height: 14),
        Text(
          "CropBio In-situ Data Analytics",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 26 : 34,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Text(
            "Dashboard-ready summaries based on the CropBio in-situ protocol, covering GVG sampling, FieldWatch boundary mapping, plot surveys, spectral measurements, LAI/FVC observations, agronomic traits, and yield-related field data.",
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _overviewCards(LayoutProvider layout) {
    final cards = const [
      _OverviewItem(
        icon: Icons.edit_location_alt_rounded,
        title: "Point and Parcel Survey",
        description:
            "GVG captures sampling points, while FieldWatch records target-field boundaries and field-level observations.",
      ),
      _OverviewItem(
        icon: Icons.biotech_rounded,
        title: "Crop Trait Measurement",
        description:
            "The protocol includes spectral, physiological, morphological, agronomic, LAI, FVC, and yield-related measurements.",
      ),
      _OverviewItem(
        icon: Icons.hub_rounded,
        title: "Data Integration",
        description:
            "In-situ observations support UAV, satellite, GIS, and database products for crop biodiversity monitoring.",
      ),
    ];

    if (layout.isMobile) {
      return Column(
        children: cards
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _OverviewCard(item: item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _OverviewCard(item: item),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _analyticsSection({
    required LayoutProvider layout,
    required String title,
    required String description,
    required Widget chart,
    bool reverse = false,
  }) {
    final textBlock = _analyticsTextBlock(
      layout: layout,
      title: title,
      description: description,
    );

    final chartBlock = chart;

    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBlock,
          const SizedBox(height: 22),
          chartBlock,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: reverse
          ? [
              Expanded(child: chartBlock),
              const SizedBox(width: 34),
              Expanded(child: textBlock),
            ]
          : [
              Expanded(child: textBlock),
              const SizedBox(width: 34),
              Expanded(child: chartBlock),
            ],
    );
  }

  Widget _analyticsTextBlock({
    required LayoutProvider layout,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallBadge(
            icon: Icons.fact_check_rounded,
            label: "Protocol-based analytics",
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: layout.isMobile ? 22 : 26,
              fontWeight: FontWeight.w900,
              color: lightText,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.nunito(
              fontSize: layout.isMobile ? 14 : 15,
              height: 1.65,
              color: mutedText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _protocolDoughnutChart(List<_ChartData> data) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(18),
      decoration: _darkChartDecoration(),
      child: SfCircularChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: "In-situ Components",
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: primaryGreen,
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
        series: <CircularSeries>[
          DoughnutSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            radius: "90%",
            innerRadius: "64%",
            dataLabelMapper: (d, _) => "${d.value.toInt()}%",
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: GoogleFonts.nunito(
                color: lightText,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            pointColorMapper: (data, _) {
              switch (data.category) {
                case "Crop Type & Species":
                  return primaryGreen;
                case "Field Boundary":
                  return goldAccent;
                case "Canopy / Leaf Traits":
                  return const Color(0xFF4E7D32);
                case "LAI & FVC":
                  return accentGreen;
                case "Yield & Agronomy":
                  return const Color(0xFF8F7A3D);
                default:
                  return const Color(0xFF6B8E23);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _fieldOutputBarChart(List<_ChartData> data) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(18),
      decoration: _darkChartDecoration(),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: "Field Output Readiness",
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelRotation: -35,
          labelStyle: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 20,
          labelFormat: "{value}%",
          labelStyle: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          majorGridLines: MajorGridLines(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: primaryGreen,
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
        series: <CartesianSeries>[
          ColumnSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            borderRadius: BorderRadius.circular(9),
            spacing: 0.25,
            color: goldAccent,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: GoogleFonts.nunito(
                color: lightText,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _darkChartDecoration() {
    return BoxDecoration(
      color: darkSurface2,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: darkBorder),
      boxShadow: [
        BoxShadow(
          blurRadius: 28,
          spreadRadius: 1,
          color: Colors.black.withOpacity(0.28),
          offset: const Offset(0, 14),
        ),
      ],
    );
  }

  Widget _protocolWorkflow(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 18 : 26),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallBadge(
            icon: Icons.route_rounded,
            label: "In-situ field workflow",
          ),
          const SizedBox(height: 16),
          Text(
            "From field observations to geospatial evidence",
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: layout.isMobile ? 22 : 26,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "The dashboard workflow below follows the major field activities in the in-situ protocol and translates them into user-facing data products for the CropBio platform.",
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 14 : 15,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
          SizedBox(height: layout.isMobile ? 18 : 24),
          _workflowGrid(layout),
        ],
      ),
    );
  }

  Widget _workflowGrid(LayoutProvider layout) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final int columnCount = width >= 1050
            ? 3
            : width >= 700
                ? 2
                : 1;

        final double cardHeight = columnCount == 1
            ? 210
            : columnCount == 2
                ? 230
                : 250;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: protocolSteps.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            return _ProtocolStepCard(
              step: protocolSteps[index],
            );
          },
        );
      },
    );
  }

  Widget _learnMorePanel(BuildContext context, LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 20 : 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryGreen.withOpacity(0.22),
            darkSurface2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: primaryGreen.withOpacity(0.32),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 26,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.26),
          ),
        ],
      ),
      child: layout.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _learnMoreText(layout),
                const SizedBox(height: 22),
                _learnMoreButton(context),
              ],
            )
          : Row(
              children: [
                Expanded(child: _learnMoreText(layout)),
                const SizedBox(width: 28),
                _learnMoreButton(context),
              ],
            ),
    );
  }

  Widget _learnMoreText(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _smallBadge(
          icon: Icons.travel_explore_rounded,
          label: "Protocol to platform",
        ),
        const SizedBox(height: 16),
        Text(
          "Want to know more about the CropBio protocol?",
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 24 : 28,
            fontWeight: FontWeight.w900,
            color: lightText,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Explore how standardized field surveys, mobile apps, UAV campaigns, spectral measurements, and field databases are connected into one CropBio evidence system.",
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 14 : 15.5,
            height: 1.65,
            color: mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _learnMoreButton(BuildContext context) {
    return _HoverButton(
      onPressed: () {
        final box = context.findRenderObject() as RenderBox?;

        if (box == null) {
          Navigator.pushNamed(context, "/aboutus");
          return;
        }

        final position = box.localToGlobal(Offset.zero);

        final direction = RouteTransitionHelper.getDirectionFromPosition(
          position,
          MediaQuery.of(context).size,
        );

        Navigator.pushNamed(
          context,
          "/aboutus",
          arguments: direction,
        );
      },
    );
  }

  Widget _smallBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.32),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: goldAccent),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem {
  final IconData icon;
  final String title;
  final String description;

  const _OverviewItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OverviewCard extends StatefulWidget {
  final _OverviewItem item;

  const _OverviewCard({
    required this.item,
  });

  @override
  State<_OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<_OverviewCard> {
  bool isHovered = false;

  static const Color primaryGreen = ResearchAnalyticsSection.primaryGreen;
  static const Color accentGreen = ResearchAnalyticsSection.accentGreen;
  static const Color goldAccent = ResearchAnalyticsSection.goldAccent;
  static const Color darkSurface2 = ResearchAnalyticsSection.darkSurface2;
  static const Color darkSurface3 = ResearchAnalyticsSection.darkSurface3;
  static const Color darkBorder = ResearchAnalyticsSection.darkBorder;
  static const Color lightText = ResearchAnalyticsSection.lightText;
  static const Color mutedText = ResearchAnalyticsSection.mutedText;

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        padding: EdgeInsets.all(layout.isMobile ? 18 : 20),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.60) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 26 : 14,
              offset: Offset(0, isHovered ? 13 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.30 : 0.18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconBox(),
            const SizedBox(height: 16),
            Text(
              widget.item.title,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.description,
              style: GoogleFonts.nunito(
                color: mutedText,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(isHovered ? 0.27 : 0.18),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: Icon(
        widget.item.icon,
        color: isHovered ? goldAccent : accentGreen,
        size: 27,
      ),
    );
  }
}

class _ProtocolStep {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _ProtocolStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _ProtocolStepCard extends StatefulWidget {
  final _ProtocolStep step;

  const _ProtocolStepCard({
    required this.step,
  });

  @override
  State<_ProtocolStepCard> createState() => _ProtocolStepCardState();
}

class _ProtocolStepCardState extends State<_ProtocolStepCard> {
  bool isHovered = false;

  static const Color primaryGreen = ResearchAnalyticsSection.primaryGreen;
  static const Color accentGreen = ResearchAnalyticsSection.accentGreen;
  static const Color goldAccent = ResearchAnalyticsSection.goldAccent;
  static const Color darkSurface = ResearchAnalyticsSection.darkSurface;
  static const Color darkSurface3 = ResearchAnalyticsSection.darkSurface3;
  static const Color darkBorder = ResearchAnalyticsSection.darkBorder;
  static const Color lightText = ResearchAnalyticsSection.lightText;
  static const Color mutedText = ResearchAnalyticsSection.mutedText;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.60) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 26 : 14,
              offset: Offset(0, isHovered ? 13 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.30 : 0.18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepHeader(),
            const SizedBox(height: 14),
            Text(
              widget.step.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                widget.step.description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepHeader() {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(isHovered ? 0.27 : 0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryGreen.withOpacity(0.34),
            ),
          ),
          child: Icon(
            widget.step.icon,
            color: isHovered ? goldAccent : accentGreen,
            size: 25,
          ),
        ),
        const Spacer(),
        Text(
          widget.step.number,
          style: GoogleFonts.nunito(
            color: isHovered ? goldAccent : mutedText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _HoverButton({
    required this.onPressed,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool isHovered = false;

  static const Color primaryGreen = ResearchAnalyticsSection.primaryGreen;
  static const Color goldAccent = ResearchAnalyticsSection.goldAccent;
  static const Color darkBorder = ResearchAnalyticsSection.darkBorder;
  static const Color lightText = ResearchAnalyticsSection.lightText;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovered ? goldAccent : primaryGreen,
            foregroundColor: isHovered ? Colors.black : lightText,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isHovered ? goldAccent : darkBorder,
              ),
            ),
          ),
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: isHovered ? Colors.black : lightText,
          ),
          label: Text(
            "Explore further",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w900,
              color: isHovered ? Colors.black : lightText,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;

  const _ChartData(this.category, this.value);
}
