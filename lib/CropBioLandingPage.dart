import 'package:cropbio/API/fetchAll.dart';
import 'package:cropbio/Models/Crop_Summary.dart';
import 'package:cropbio/Pherips/LandingCarouselVid.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  CropSummary? summaryData;
  bool isLoading = true;
  String? errorMessage;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  Future<void> loadSummary() async {
    try {
      final result = await fetchCropSummary();

      if (!mounted) return;

      setState(() {
        summaryData = result;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        summaryData = null;
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        backgroundColor: darkBg,
        body: Column(
          children: [
            const ResponsiveTitleBar(title: "Crop Biodiversity"),
            const ResponsiveNavBar(),
            Expanded(
              child: Container(
                color: darkBg,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ScrollReveal(
                        delay: const Duration(milliseconds: 120),
                        child: LandingVideo(
                          videoPath: 'lib/Assets/final.mp4',
                        ),
                      ),
                      _darkDivider(),

                      /// ================= IMPACT STATS =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 250),
                        child: _SectionShell(
                          layout: layout,
                          badge: "CropBio Impact",
                          title: "Crop Biodiversity at a Glance",
                          subtitle:
                              "A live summary of CropBio records, crop groups, and field-based research sites supporting biodiversity monitoring and agricultural decision-making.",
                          icon: Icons.insights_rounded,
                          child: _ImpactStatsSection(
                            summaryData: summaryData,
                            isLoading: isLoading,
                            errorMessage: errorMessage,
                            onRetry: loadSummary,
                          ),
                        ),
                      ),

                      /// ================= MISSION SECTION =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 380),
                        child: _SectionShell(
                          layout: layout,
                          badge: "Mission",
                          title: "Science, Data, and Crop Diversity",
                          subtitle:
                              "CropBio connects field research, laboratory measurements, geospatial technologies, and data systems to support sustainable farming and crop biodiversity conservation.",
                          icon: Icons.eco_rounded,
                          child: layout.isMobile
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _VisionText(),
                                    SizedBox(height: 24),
                                    _VisionImage(),
                                  ],
                                )
                              : const Row(
                                  children: [
                                    Expanded(child: _VisionText()),
                                    SizedBox(width: 32),
                                    Expanded(child: _VisionImage()),
                                  ],
                                ),
                        ),
                      ),

                      /// ================= RESEARCH FOCUS =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 500),
                        child: _SectionShell(
                          layout: layout,
                          badge: "Research Areas",
                          title: "Research Focus Areas",
                          subtitle:
                              "CropBio supports research in crop biodiversity, resilience, sustainable agriculture, field monitoring, and digital agricultural systems.",
                          icon: Icons.science_rounded,
                          child: const _ResearchGrid(),
                        ),
                      ),

                      /// ================= ANALYTICS =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 620),
                        child: _SectionShell(
                          layout: layout,
                          badge: "Analytics",
                          title: "Research Data Insights",
                          subtitle:
                              "An overview of biodiversity distribution, crop monitoring indicators, and resilience-oriented research themes across CropBio activities.",
                          icon: Icons.pie_chart_rounded,
                          child: const _ResearchAnalyticsSection(),
                        ),
                      ),

                      /// ================= CTA =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 740),
                        child: _SignupSection(layout: layout),
                      ),

                      /// ================= PARTNERS =================
                      ScrollReveal(
                        delay: const Duration(milliseconds: 860),
                        child: _PartnersSection(layout: layout),
                      ),

                      /// ================= FOOTER =================
                      _FooterSection(layout: layout),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _darkDivider() {
    return Divider(
      thickness: 1,
      height: 1,
      color: darkBorder.withOpacity(0.9),
    );
  }
}

class _SectionShell extends StatelessWidget {
  final LayoutProvider layout;
  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SectionShell({
    required this.layout,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: darkBg,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile
            ? layout.verticalPadding
            : layout.verticalPadding * 1.6,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 16 : 28),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
              border: Border.all(color: darkBorder),
              boxShadow: [
                BoxShadow(
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                  color: Colors.black.withOpacity(0.28),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                SizedBox(height: layout.isMobile ? 22 : 34),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _badge(),
          const SizedBox(height: 12),
          _titleBlock(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _titleBlock()),
        const SizedBox(width: 20),
        _badge(),
      ],
    );
  }

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Text(
            subtitle,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 13.5 : 15,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
          Icon(icon, size: 17, color: accentGreen),
          const SizedBox(width: 8),
          Text(
            badge,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactStatsSection extends StatelessWidget {
  final CropSummary? summaryData;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRetry;

  const _ImpactStatsSection({
    required this.summaryData,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  static const Color goldAccent = Color(0xFFC6A432);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    if (isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          children: [
            const CircularProgressIndicator(color: goldAccent),
            const SizedBox(height: 16),
            Text(
              "Loading CropBio summary...",
              style: GoogleFonts.nunito(
                color: mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.red.withOpacity(0.30),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Unable to load summary data. Please try again.",
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: goldAccent,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: Text(
                "Retry",
                style: GoogleFonts.nunito(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      _StatItem(
        number: summaryData?.totalAccessions ?? 0,
        suffix: "+",
        label: "Crop Accessions",
        icon: Icons.eco_rounded,
        description:
            "Documented plant varieties preserved for research, monitoring, and conservation.",
      ),
      _StatItem(
        number: summaryData?.totalCropTypes ?? 0,
        suffix: "",
        label: "Crop Species",
        icon: Icons.grass_rounded,
        description:
            "Crop groups represented in CropBio biodiversity and field data programs.",
      ),
      _StatItem(
        number: summaryData?.totalFields ?? 0,
        suffix: "",
        label: "Experimental Fields",
        icon: Icons.science_rounded,
        description:
            "Research sites supporting crop sampling, field monitoring, and validation.",
      ),
    ];

    if (layout.isMobile) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _StatCard(item: item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _StatCard(item: item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatItem {
  final int number;
  final String suffix;
  final String label;
  final IconData icon;
  final String description;

  const _StatItem({
    required this.number,
    required this.suffix,
    required this.label,
    required this.icon,
    required this.description,
  });
}

class _StatCard extends StatefulWidget {
  final _StatItem item;

  const _StatCard({
    required this.item,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = IntTween(
      begin: 0,
      end: widget.item.number,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant _StatCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item.number != widget.item.number) {
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        padding: EdgeInsets.all(layout.isMobile ? 18 : 22),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.58) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 28 : 16,
              offset: Offset(0, isHovered ? 14 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.32 : 0.20),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconBox(),
                const SizedBox(height: 18),
                Text(
                  "${_animation.value}${widget.item.suffix}",
                  style: GoogleFonts.nunito(
                    fontSize: layout.isMobile ? 36 : 44,
                    fontWeight: FontWeight.w900,
                    color: goldAccent,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.label,
                  style: GoogleFonts.nunito(
                    color: lightText,
                    fontSize: layout.isMobile ? 16 : 18,
                    fontWeight: FontWeight.w900,
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
            );
          },
        ),
      ),
    );
  }

  Widget _iconBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(isHovered ? 0.26 : 0.18),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: Icon(
        widget.item.icon,
        color: isHovered ? goldAccent : accentGreen,
        size: 28,
      ),
    );
  }
}

class _VisionText extends StatelessWidget {
  const _VisionText();

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);
  static const Color goldAccent = Color(0xFFC6A432);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Mission",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "CropBio is dedicated to preserving crop diversity, supporting research innovation, and empowering sustainable agriculture in the Philippines through field-based evidence, remote sensing, geospatial analytics, and digital data systems.",
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 14.5 : 16,
            fontWeight: FontWeight.w600,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _MiniChip(icon: Icons.satellite_alt_rounded, label: "Space Applications"),
            _MiniChip(icon: Icons.map_rounded, label: "GIS-ready Data"),
            _MiniChip(icon: Icons.science_rounded, label: "Field Research"),
          ],
        ),
      ],
    );
  }
}

class _VisionImage extends StatelessWidget {
  const _VisionImage();

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      height: layout.isMobile ? 260 : 360,
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.24),
          ),
        ],
      ),
      child: SvgPicture.asset(
        "lib/Assets/Cropbio_Logo_Dark.svg",
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ResearchGrid extends StatelessWidget {
  const _ResearchGrid();

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = [
      const _ResearchItem(
        title: "Crop Diversity Conservation",
        description:
            "Documenting crop types, varieties, and field-level biodiversity patterns for research and conservation.",
        icon: Icons.eco_rounded,
      ),
      const _ResearchItem(
        title: "Climate Resilience",
        description:
            "Supporting resilient crop systems through field data, monitoring, and science-based assessment.",
        icon: Icons.thermostat_rounded,
      ),
      const _ResearchItem(
        title: "Sustainable Farming",
        description:
            "Advancing low-impact, data-informed, and biodiversity-friendly agricultural systems.",
        icon: Icons.agriculture_rounded,
      ),
    ];

    if (layout.isMobile) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ResearchCard(item: item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _ResearchCard(item: item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ResearchItem {
  final String title;
  final String description;
  final IconData icon;

  const _ResearchItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _ResearchCard extends StatefulWidget {
  final _ResearchItem item;

  const _ResearchCard({
    required this.item,
  });

  @override
  State<_ResearchCard> createState() => _ResearchCardState();
}

class _ResearchCardState extends State<_ResearchCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.58) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 28 : 16,
              offset: Offset(0, isHovered ? 14 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.32 : 0.20),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconBox(),
            const SizedBox(height: 18),
            Text(
              widget.item.title,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
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
      duration: const Duration(milliseconds: 220),
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(isHovered ? 0.26 : 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        widget.item.icon,
        color: isHovered ? goldAccent : accentGreen,
        size: 28,
      ),
    );
  }
}

class _ResearchAnalyticsSection extends StatefulWidget {
  const _ResearchAnalyticsSection();

  @override
  State<_ResearchAnalyticsSection> createState() =>
      _ResearchAnalyticsSectionState();
}

class _ResearchAnalyticsSectionState extends State<_ResearchAnalyticsSection> {
  final GlobalKey dashboardKey = GlobalKey();

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final cropData = [
      _ChartData("Rice", 40),
      _ChartData("Corn", 25),
      _ChartData("Vegetables", 20),
      _ChartData("Root Crops", 15),
    ];

    final resilienceData = [
      _ChartData("Drought", 30),
      _ChartData("Flood", 20),
      _ChartData("Pest", 35),
      _ChartData("Salinity", 15),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        layout.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _analyticsTextBlock(
                    title: "Crop Distribution Analysis",
                    description:
                        "Rice and corn currently dominate the sample distribution, while vegetables and root crops represent important areas for diversification and climate-adaptive research.",
                  ),
                  const SizedBox(height: 22),
                  _darkPieChart(cropData),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _analyticsTextBlock(
                      title: "Crop Distribution Analysis",
                      description:
                          "Rice and corn currently dominate the sample distribution, while vegetables and root crops represent important areas for diversification and climate-adaptive research.",
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(child: _darkPieChart(cropData)),
                ],
              ),
        SizedBox(height: layout.isMobile ? 36 : 54),
        layout.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _analyticsTextBlock(
                    title: "Resilience Trait Monitoring",
                    description:
                        "CropBio supports the monitoring of stress-related traits and environmental indicators, including drought, flooding, pest pressure, and salinity-related risks.",
                  ),
                  const SizedBox(height: 22),
                  _darkBarChart(resilienceData),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _darkBarChart(resilienceData)),
                  const SizedBox(width: 28),
                  Expanded(
                    child: _analyticsTextBlock(
                      title: "Resilience Trait Monitoring",
                      description:
                          "CropBio supports the monitoring of stress-related traits and environmental indicators, including drought, flooding, pest pressure, and salinity-related risks.",
                    ),
                  ),
                ],
              ),
        SizedBox(height: layout.isMobile ? 36 : 54),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(layout.isMobile ? 18 : 24),
          decoration: BoxDecoration(
            color: darkSurface2,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: darkBorder),
          ),
          child: layout.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _analyticsTextBlock(
                      title: "Explore the Full Dashboard",
                      description:
                          "View detailed CropBio summaries, tabular datasets, raw field measurements, and visualization tools in the full dashboard.",
                    ),
                    const SizedBox(height: 18),
                    _dashboardButton(context),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _analyticsTextBlock(
                        title: "Explore the Full Dashboard",
                        description:
                            "View detailed CropBio summaries, tabular datasets, raw field measurements, and visualization tools in the full dashboard.",
                      ),
                    ),
                    const SizedBox(width: 24),
                    _dashboardButton(context),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _dashboardButton(BuildContext context) {
    return SizedBox(
      key: dashboardKey,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          final buttonContext = dashboardKey.currentContext;

          if (buttonContext == null) {
            Navigator.pushNamed(context, "/dashboard");
            return;
          }

          final RenderBox box = buttonContext.findRenderObject() as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          final screenSize = MediaQuery.of(context).size;

          final direction = RouteTransitionHelper.getDirectionFromPosition(
            position,
            screenSize,
          );

          Navigator.pushNamed(
            context,
            "/dashboard",
            arguments: direction,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Explore Full Dashboard",
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _analyticsTextBlock({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.65,
          ),
        ),
      ],
    );
  }

  Widget _darkPieChart(List<_ChartData> data) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(18),
      decoration: _darkChartDecoration(),
      child: SfCircularChart(
        backgroundColor: darkSurface2,
        title: ChartTitle(
          text: "Crop Distribution",
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        legend: Legend(
          isVisible: true,
          textStyle: GoogleFonts.nunito(
            color: mutedText,
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
          PieSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: GoogleFonts.nunito(
                color: lightText,
                fontWeight: FontWeight.w800,
              ),
            ),
            pointColorMapper: (data, _) {
              switch (data.category) {
                case "Rice":
                  return primaryGreen;
                case "Corn":
                  return goldAccent;
                case "Vegetables":
                  return const Color(0xFF4E7D32);
                default:
                  return const Color(0xFF7A8F3D);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _darkBarChart(List<_ChartData> data) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(18),
      decoration: _darkChartDecoration(),
      child: SfCartesianChart(
        backgroundColor: darkSurface2,
        title: ChartTitle(
          text: "Climate Resilience Traits",
          textStyle: GoogleFonts.nunito(
            color: lightText,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: GoogleFonts.nunito(
            color: mutedText,
            fontWeight: FontWeight.w700,
          ),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: GoogleFonts.nunito(
            color: mutedText,
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
            borderRadius: BorderRadius.circular(8),
            color: goldAccent,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: GoogleFonts.nunito(
                color: lightText,
                fontWeight: FontWeight.w800,
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
      border: Border.all(
        color: darkBorder,
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 24,
          color: Colors.black.withOpacity(0.28),
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}

class _SignupSection extends StatelessWidget {
  final LayoutProvider layout;

  const _SignupSection({
    required this.layout,
  });

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 58 : 96,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF111C14),
            Color(0xFF162216),
            Color(0xFF0F1712),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.isMobile ? layout.contentWidth : 920,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 22 : 34),
            decoration: BoxDecoration(
              color: darkSurface.withOpacity(0.94),
              borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
              border: Border.all(color: darkBorder),
              boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                  color: Colors.black.withOpacity(0.30),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Join the Future of Crop Biodiversity",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: layout.isMobile ? 28 : 40,
                    fontWeight: FontWeight.w900,
                    color: lightText,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Subscribe to receive updates on research activities, data releases, publications, and CropBio biodiversity initiatives.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: layout.isMobile ? 14.5 : 17,
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 30),
                const _SignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _emailController = TextEditingController();

  bool isHovered = false;
  bool isSubmitted = false;
  String? errorText;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      setState(() {
        errorText = "Please enter a valid email address.";
      });
      return;
    }

    setState(() {
      isSubmitted = true;
      errorText = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isSubmitted = false;
        _emailController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSubmitted
              ? Text(
                  "Thank you for subscribing!",
                  key: const ValueKey("success"),
                  style: GoogleFonts.nunito(
                    color: goldAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : layout.isMobile
                  ? _mobileForm()
                  : _desktopForm(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 10),
          Text(
            errorText!,
            style: GoogleFonts.nunito(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 22),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/contact");
          },
          icon: const Icon(
            Icons.mail_outline_rounded,
            color: mutedText,
            size: 19,
          ),
          label: Text(
            "Or Email Us Directly",
            style: GoogleFonts.nunito(
              fontSize: 15,
              height: 1.6,
              color: mutedText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _desktopForm() {
    return Row(
      key: const ValueKey("desktopForm"),
      children: [
        Expanded(child: _emailField()),
        const SizedBox(width: 14),
        _subscribeButton(),
      ],
    );
  }

  Widget _mobileForm() {
    return Column(
      key: const ValueKey("mobileForm"),
      children: [
        _emailField(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _subscribeButton(),
        ),
      ],
    );
  }

  Widget _emailField() {
    return Container(
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: darkBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: _emailController,
        style: GoogleFonts.nunito(
          color: lightText,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: goldAccent,
        decoration: InputDecoration(
          hintText: "Enter your email address",
          hintStyle: GoogleFonts.nunito(
            color: mutedText,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          icon: const Icon(
            Icons.email_rounded,
            color: mutedText,
          ),
        ),
      ),
    );
  }

  Widget _subscribeButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAccent,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: _submit,
          child: Text(
            "Subscribe",
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _PartnersSection extends StatelessWidget {
  final LayoutProvider layout;

  const _PartnersSection({
    required this.layout,
  });

  static const Color darkBg = Color(0xFF0F1712);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: darkBg,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 46 : 70,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: layout.contentWidth),
          child: Column(
            children: [
              Text(
                "In Collaboration With",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: layout.isMobile ? 22 : 26,
                  fontWeight: FontWeight.w900,
                  color: lightText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "CropBio is supported by institutional and technical partners advancing space-enabled agricultural research.",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 34),
              Wrap(
                spacing: layout.isMobile ? 16 : 28,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: const [
                  _PartnerLogo(
                    name: "MMSU",
                    assetPath: "lib/Assets/Agency_Logos/MMSU.png",
                  ),
                  _PartnerLogo(
                    name: "PhilSA",
                    assetPath: "lib/Assets/Agency_Logos/PhilSa.png",
                  ),
                  _PartnerLogo(
                    name: "CHED",
                    assetPath: "lib/Assets/Agency_Logos/CHED.png",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerLogo extends StatefulWidget {
  final String name;
  final String assetPath;

  const _PartnerLogo({
    required this.name,
    required this.assetPath,
  });

  @override
  State<_PartnerLogo> createState() => _PartnerLogoState();
}

class _PartnerLogoState extends State<_PartnerLogo> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        width: layout.isMobile ? 145 : 170,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface2 : darkSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.55) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 24 : 14,
              offset: Offset(0, isHovered ? 12 : 6),
              color: Colors.black.withOpacity(isHovered ? 0.30 : 0.18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.assetPath,
              height: 54,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 14),
            Text(
              widget.name,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final LayoutProvider layout;

  const _FooterSection({
    required this.layout,
  });

  static const Color darkSurface = Color(0xFF111C14);
  static const Color darkBorder = Color(0xFF2E3E31);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: darkSurface,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 44 : 60,
        horizontal: layout.isMobile ? 18 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: layout.contentWidth),
          child: Container(
            padding: EdgeInsets.all(layout.isMobile ? 18 : 26),
            decoration: BoxDecoration(
              color: const Color(0xFF162216),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: darkBorder),
            ),
            child: layout.isMobile
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FooterBrand(),
                      SizedBox(height: 30),
                      _FooterLinks(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FooterBrand(),
                      _FooterLinks(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);
  static const Color goldAccent = Color(0xFFC6A432);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CropBio",
          style: GoogleFonts.nunito(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: lightText,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Mariano Marcos State University\nCity of Batac, Ilocos Norte",
          style: GoogleFonts.nunito(
            color: mutedText,
            height: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Promoting crop biodiversity through innovative space applications.",
          style: GoogleFonts.nunito(
            color: goldAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);
  static const Color goldAccent = Color(0xFFC6A432);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Links",
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 18),
        _footerLink(context, "About Us", "/about"),
        _footerLink(context, "Data Portal", "/data"),
        _footerLink(context, "Services", "/services"),
        _footerLink(context, "Updates", "/updates"),
      ],
    );
  }

  Widget _footerLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: GoogleFonts.nunito(
            color: mutedText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniChip({
    required this.icon,
    required this.label,
  });

  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: darkBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accentGreen),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _offset = Tween(begin: 34.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _offset.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);
}