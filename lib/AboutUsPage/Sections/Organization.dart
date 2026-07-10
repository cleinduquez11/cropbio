import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrganizationSection extends StatelessWidget {
  const OrganizationSection({super.key});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _introPanel(layout),
        SizedBox(height: layout.isMobile ? 18 : 24),
        _organizationHighlights(layout),
      ],
    );
  }

  Widget _introPanel(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(layout.isMobile ? 18 : 24),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: layout.isMobile ? _mobileIntro(layout) : _desktopIntro(layout),
    );
  }

  Widget _desktopIntro(LayoutProvider layout) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconBox(layout),
        const SizedBox(width: 20),
        Expanded(
          child: _introText(layout),
        ),
      ],
    );
  }

  Widget _mobileIntro(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconBox(layout),
        const SizedBox(height: 16),
        _introText(layout),
      ],
    );
  }

  Widget _iconBox(LayoutProvider layout) {
    return Container(
      height: layout.isMobile ? 54 : 64,
      width: layout.isMobile ? 54 : 64,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: const Icon(
        Icons.groups_rounded,
        color: goldAccent,
        size: 32,
      ),
    );
  }

  Widget _introText(LayoutProvider layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Who We Are",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "CropBio is developed and maintained through collaborative efforts among academic institutions, agricultural researchers, geospatial specialists, field survey teams, and technology developers. The platform integrates field research, remote sensing, GIS, and data science to support crop biodiversity monitoring and evidence-based decision-making.",
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 14 : 15.5,
            fontWeight: FontWeight.w600,
            height: 1.65,
          ),
        ),
      ],
    );
  }

  Widget _organizationHighlights(LayoutProvider layout) {
    final items = [
      _OrganizationItem(
        icon: Icons.school_rounded,
        title: "Academic Leadership",
        description:
            "Anchored on university-based research, technical expertise, and scientific training.",
      ),
      _OrganizationItem(
        icon: Icons.agriculture_rounded,
        title: "Field Research Network",
        description:
            "Supported by field teams, crop monitoring protocols, and community-level data collection.",
      ),
      _OrganizationItem(
        icon: Icons.satellite_alt_rounded,
        title: "Geospatial & Data Systems",
        description:
            "Powered by remote sensing, GIS analytics, data processing, and visualization tools.",
      ),
    ];

    if (layout.isMobile) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OrganizationCard(item: item),
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
                child: _OrganizationCard(item: item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _OrganizationItem {
  final IconData icon;
  final String title;
  final String description;

  const _OrganizationItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OrganizationCard extends StatefulWidget {
  final _OrganizationItem item;

  const _OrganizationCard({
    required this.item,
  });

  @override
  State<_OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<_OrganizationCard> {
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
          isHovered ? -5 : 0,
          0,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(isHovered ? 0.26 : 0.18),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: primaryGreen.withOpacity(0.34),
                ),
              ),
              child: Icon(
                widget.item.icon,
                color: isHovered ? goldAccent : accentGreen,
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.item.title,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 16,
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
}