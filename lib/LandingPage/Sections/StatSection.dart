import 'package:cropbio/Models/Crop_Summary.dart';
import 'package:cropbio/Providers/LandingPage.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F9F4);
  static const Color lightSurface2 = Color(0xFFF1F5EC);
  static const Color lightBorder = Color(0xFFE1E8DA);

  static const Color darkText = Color(0xFF162216);
  static const Color mutedText = Color(0xFF60705A);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Selector<LandingProvider, CropSummary?>(
      selector: (_, provider) => provider.summaryData,
      builder: (_, summaryData, __) {
        final items = [
          _StatItem(
            number: summaryData?.totalAccessions ?? 0,
            suffix: "+",
            label: "GVG / Crop Observations",
            icon: Icons.edit_location_alt_rounded,
            description:
                "Sampling records for crop type, species or variety, location, field photo, and field remarks.",
          ),
          _StatItem(
            number: summaryData?.totalCropTypes ?? 0,
            suffix: "",
            label: "Crop Types & Species",
            icon: Icons.eco_rounded,
            description:
                "Crop diversity records describing crop types, species, varieties, and cropping patterns.",
          ),
          _StatItem(
            number: summaryData?.totalFields ?? 0,
            suffix: "",
            label: "Field Parcels / Plots",
            icon: Icons.crop_square_rounded,
            description:
                "FieldWatch boundaries and plot survey units for validation and crop monitoring.",
          ),
          const _StatItem(
            number: 6,
            suffix: "",
            label: "In-situ Data Modules",
            icon: Icons.fact_check_rounded,
            description:
                "GVG, FieldWatch, plot survey, crop traits, UAV imagery, and household-level data.",
          ),
        ];

        return Container(
          width: double.infinity,
          color: lightBg,
          padding: EdgeInsets.symmetric(
            vertical: layout.isMobile
                ? layout.verticalPadding
                : layout.verticalPadding * 1.6,
            horizontal: layout.isMobile ? 14 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    layout.contentWidth > 1200 ? 1200 : layout.contentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _sectionHeader(layout),
                  // SizedBox(height: layout.isMobile ? 20 : 28),
                  // _protocolNote(layout),
                  // SizedBox(height: layout.isMobile ? 18 : 24),
                  _statsGrid(layout, items),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionHeader(LayoutProvider layout) {
    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionBadge(),
          const SizedBox(height: 12),
          _titleBlock(layout),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _titleBlock(layout),
        ),
        const SizedBox(width: 20),
        _sectionBadge(),
      ],
    );
  }

  Widget _titleBlock(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Protocol-based Field Indicators",
          style: GoogleFonts.nunito(
            color: darkText,
            fontSize: layout.isMobile ? 24 : 32,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Text(
            "A summary of CropBio’s in-situ data workflow, including mobile field sampling, crop type documentation, parcel mapping, plot surveys, UAV support, and standardized field data integration.",
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 13.5 : 15.5,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assignment_turned_in_rounded,
            color: primaryGreen,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "In-situ Protocol",
            style: GoogleFonts.nunito(
              color: primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _protocolNote(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: lightSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 18 : 22),
        border: Border.all(
          color: lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: layout.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _noteIcon(),
                const SizedBox(height: 14),
                _noteText(layout),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _noteIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: _noteText(layout),
                ),
              ],
            ),
    );
  }

  Widget _noteIcon() {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.10),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: primaryGreen.withOpacity(0.22),
        ),
      ),
      child: const Icon(
        Icons.dataset_rounded,
        color: primaryGreen,
        size: 28,
      ),
    );
  }

  Widget _noteText(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "From field observations to dashboard-ready evidence",
          style: GoogleFonts.nunito(
            color: darkText,
            fontSize: layout.isMobile ? 18 : 20,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "These indicators summarize how CropBio organizes field observations, crop records, plot boundaries, and measurement modules into a structured biodiversity data system.",
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 13.5 : 14.5,
            fontWeight: FontWeight.w600,
            height: 1.55,
          ),
        ),
      ],
    );
  }


  Widget _statsGrid(
    LayoutProvider layout,
    List<_StatItem> items,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final int columnCount = width >= 1120
            ? 4
            : width >= 760
                ? 2
                : 1;

        final double spacing = layout.isMobile ? 14 : 18;

        final double cardHeight = columnCount == 1
            ? 220
            : columnCount == 2
                ? 240
                : 255;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            return _ProtocolStatCard(
              item: items[index],
            );
          },
        );
      },
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

class _ProtocolStatCard extends StatefulWidget {
  final _StatItem item;

  const _ProtocolStatCard({
    required this.item,
  });

  @override
  State<_ProtocolStatCard> createState() => _ProtocolStatCardState();
}


   class _ProtocolStatCardState extends State<_ProtocolStatCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color deepGreen = Color(0xFF243625);
  static const Color hoverGreen = Color(0xFF2F4F2F);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFD6E0D1);

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
  void didUpdateWidget(covariant _ProtocolStatCard oldWidget) {
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
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        padding: EdgeInsets.all(layout.isMobile ? 18 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isHovered
                ? const [
                    Color(0xFF3F6B2A),
                    Color(0xFF2F4F2F),
                  ]
                : const [
                    Color(0xFF2F4F2F),
                    Color(0xFF243625),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.80) : accentGreen.withOpacity(0.35),
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 30 : 16,
              offset: Offset(0, isHovered ? 14 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.26 : 0.14),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.28),
              ),
          ],
        ),
        child: AnimatedScale(
          scale: isHovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topRow(),
                  const SizedBox(height: 16),
                  Text(
                    "${_animation.value}${widget.item.suffix}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: goldAccent,
                      fontSize: layout.isMobile ? 34 : 40,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: lightText,
                      fontSize: layout.isMobile ? 16 : 17,
                      fontWeight: FontWeight.w900,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      widget.item.description,
                      maxLines: layout.isMobile ? 4 : 5,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: mutedText,
                        fontSize: layout.isMobile ? 12.8 : 13.2,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHovered ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
            ),
          ),
          child: Icon(
            widget.item.icon,
            color: isHovered ? goldAccent : lightText,
            size: 28,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
            ),
          ),
          child: Text(
            "In-situ",
            style: GoogleFonts.nunito(
              color: isHovered ? goldAccent : lightText,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}