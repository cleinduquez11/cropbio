import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResearchGrid extends StatelessWidget {
  const ResearchGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = const [
      _ResearchFocusItem(
        icon: Icons.satellite_alt_rounded,
        title: "Earth Observation Monitoring",
        description:
            "Utilizing satellite imagery and geospatial technologies to monitor crop conditions, biodiversity patterns, and agricultural landscapes across Southeast Asia.",
      ),
      _ResearchFocusItem(
        icon: Icons.eco_rounded,
        title: "Crop Diversity Assessment",
        description:
            "Evaluating crop and cropping diversity through standardized field surveys to support sustainable agriculture, genetic conservation, and food security initiatives.",
      ),
      _ResearchFocusItem(
        icon: Icons.flight_takeoff_rounded,
        title: "UAV & Remote Sensing",
        description:
            "Integrating UAV-based multispectral imaging and remote sensing applications for high-resolution monitoring of crop health, resilience, and environmental conditions.",
      ),
      _ResearchFocusItem(
        icon: Icons.analytics_rounded,
        title: "Food Security Analytics",
        description:
            "Analyzing agricultural and biodiversity data to understand the relationship between crop diversity, nutrition, yield stability, and sustainable food systems.",
      ),
      _ResearchFocusItem(
        icon: Icons.thermostat_rounded,
        title: "Climate Resilience Research",
        description:
            "Investigating resilient agricultural practices and adaptive crop systems to address climate change, environmental stress, and ecosystem sustainability.",
      ),
      _ResearchFocusItem(
        icon: Icons.map_rounded,
        title: "Geospatial Data Integration",
        description:
            "Combining field survey information, Earth observation datasets, and GIS technologies into scalable platforms for research, monitoring, and policy support.",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final int columnCount = width >= 1100
            ? 3
            : width >= 720
                ? 2
                : 1;

        final double spacing = layout.isMobile ? 14 : 18;

        /*
          mainAxisExtent prevents the cards from overflowing.
          It gives every card a fixed safe height instead of forcing
          the card to depend on childAspectRatio.
        */
        final double cardHeight = columnCount == 1
            ? 285
            : columnCount == 2
                ? 305
                : 315;

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
            return _ResearchFocusCard(
              item: items[index],
            );
          },
        );
      },
    );
  }
}

class _ResearchFocusItem {
  final IconData icon;
  final String title;
  final String description;

  const _ResearchFocusItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ResearchFocusCard extends StatefulWidget {
  final _ResearchFocusItem item;

  const _ResearchFocusCard({
    required this.item,
  });

  @override
  State<_ResearchFocusCard> createState() => _ResearchFocusCardState();
}

class _ResearchFocusCardState extends State<_ResearchFocusCard> {
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
          isHovered ? -7 : 0,
          0,
        ),
        padding: EdgeInsets.all(layout.isMobile ? 18 : 22),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.62) : darkBorder,
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 30 : 16,
              offset: Offset(0, isHovered ? 15 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.34 : 0.20),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.20),
              ),
          ],
        ),
        child: AnimatedScale(
          scale: isHovered ? 1.018 : 1.0,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBox(),
              const SizedBox(height: 18),
              Text(
                widget.item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontSize: layout.isMobile ? 17 : 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  widget.item.description,
                  maxLines: layout.isMobile ? 6 : 7,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: mutedText,
                    fontSize: layout.isMobile ? 13.5 : 14,
                    fontWeight: FontWeight.w600,
                    height: 1.52,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _bottomLabel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(isHovered ? 0.28 : 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: Icon(
        widget.item.icon,
        color: isHovered ? goldAccent : accentGreen,
        size: 29,
      ),
    );
  }

  Widget _bottomLabel() {
    return Row(
      children: [
        Text(
          "Research focus",
          style: GoogleFonts.nunito(
            color: isHovered ? goldAccent : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          transform: Matrix4.translationValues(
            isHovered ? 4 : 0,
            0,
            0,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: isHovered ? goldAccent : mutedText,
            size: 16,
          ),
        ),
      ],
    );
  }
}