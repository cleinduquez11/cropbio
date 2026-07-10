import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StrengthSection extends StatelessWidget {
  const StrengthSection({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(layout),
        SizedBox(height: layout.isMobile ? 22 : 32),
        const StrengthGrid(),
      ],
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
          "What We Do",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            "Core strengths that drive CropBio’s research, innovation, and impact in agricultural biodiversity monitoring, field data systems, and sustainable farming.",
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

  Widget _sectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
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
          const Icon(
            Icons.workspace_premium_rounded,
            size: 17,
            color: accentGreen,
          ),
          const SizedBox(width: 8),
          Text(
            "Research Capabilities",
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

class StrengthGrid extends StatelessWidget {
  const StrengthGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = [
      const _StrengthItem(
        title: "Data-Driven Research",
        description:
            "Transforms field, laboratory, and survey data into actionable insights for crop biodiversity and agricultural decision-making.",
        icon: Icons.analytics_rounded,
      ),
      const _StrengthItem(
        title: "GIS Integration",
        description:
            "Combines spatial databases, field boundaries, crop records, and geospatial layers for accurate mapping and monitoring.",
        icon: Icons.map_rounded,
      ),
      const _StrengthItem(
        title: "Drone Mapping",
        description:
            "Uses high-resolution UAV imagery and vegetation indices to support crop monitoring, validation, and spatial analysis.",
        icon: Icons.flight_takeoff_rounded,
      ),
      const _StrengthItem(
        title: "Sustainable Agriculture",
        description:
            "Supports resilient farming systems through crop diversity, field-based evidence, and science-based resource management.",
        icon: Icons.eco_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final int cols = width > 1050
            ? 4
            : width > 720
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: layout.isMobile ? 14 : 18,
            mainAxisSpacing: layout.isMobile ? 14 : 18,
            childAspectRatio: cols == 1
                ? 1.85
                : cols == 2
                    ? 1.45
                    : 1.10,
          ),
          itemBuilder: (_, index) {
            return _StrengthCard(
              item: items[index],
            );
          },
        );
      },
    );
  }
}

class _StrengthItem {
  final String title;
  final String description;
  final IconData icon;

  const _StrengthItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _StrengthCard extends StatefulWidget {
  final _StrengthItem item;

  const _StrengthCard({
    required this.item,
  });

  @override
  State<_StrengthCard> createState() => _StrengthCardState();
}

class _StrengthCardState extends State<_StrengthCard> {
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
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        padding: EdgeInsets.all(layout.isMobile ? 16 : 20),
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
            if (isHovered)
              BoxShadow(
                blurRadius: 24,
                color: primaryGreen.withOpacity(0.18),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: layout.isMobile ? 16 : 17,
                fontWeight: FontWeight.w900,
                height: 1.2,
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
                  fontSize: layout.isMobile ? 13 : 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.48,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _learnMoreIndicator(),
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

  Widget _learnMoreIndicator() {
    return Row(
      children: [
        Text(
          "CropBio capability",
          style: GoogleFonts.nunito(
            color: isHovered ? goldAccent : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
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