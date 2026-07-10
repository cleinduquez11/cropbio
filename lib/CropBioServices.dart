import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/ServicesPage/Sections/ServicesProcess.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'ServicesPage/Sections/ServicesCTA.dart';
import 'ServicesPage/Sections/ServicesGrid.dart';
import 'ServicesPage/Sections/ServicesHero.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return AppShell(
      child: Container(
        color: darkBg,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// ================= HERO =================
            const SliverToBoxAdapter(
              child: ServicesHero(),
            ),

            /// ================= SERVICES GRID =================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: layout.isMobile
                      ? layout.verticalPadding
                      : layout.verticalPadding * 1.6,
                  horizontal: layout.isMobile ? 14 : 24,
                ),
                color: darkBg,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: _CapabilitiesSection(layout: layout),
                  ),
                ),
              ),
            ),

            /// ================= PROCESS =================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: layout.isMobile
                      ? layout.verticalPadding
                      : layout.verticalPadding * 1.6,
                  horizontal: layout.isMobile ? 14 : 24,
                ),
                color: darkBg,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: _ProcessSection(layout: layout),
                  ),
                ),
              ),
            ),

            /// ================= CTA =================
            SliverToBoxAdapter(
              child: _ServicesCTASection(layout: layout),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapabilitiesSection extends StatelessWidget {
  final LayoutProvider layout;

  const _CapabilitiesSection({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
        border: Border.all(
          color: darkBorder,
        ),
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
          _sectionHeader(),
          SizedBox(height: layout.isMobile ? 20 : 32),
          const ServicesGrid(),
        ],
      ),
    );
  }

  Widget _sectionHeader() {
    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionBadge(),
          const SizedBox(height: 12),
          _titleBlock(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _titleBlock(),
        ),
        const SizedBox(width: 20),
        _sectionBadge(),
      ],
    );
  }

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Capabilities",
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            color: lightText,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            "Comprehensive solutions for crop research, geospatial analysis, field data collection, biodiversity monitoring, and decision-support systems.",
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
            Icons.engineering_rounded,
            size: 17,
            color: accentGreen,
          ),
          const SizedBox(width: 8),
          Text(
            "CropBio Services",
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

class _ProcessSection extends StatelessWidget {
  final LayoutProvider layout;

  const _ProcessSection({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          SizedBox(height: layout.isMobile ? 20 : 30),
          const ServiceProcess(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: layout.isMobile ? 44 : 50,
          width: layout.isMobile ? 44 : 50,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryGreen.withOpacity(0.32),
            ),
          ),
          child: const Icon(
            Icons.route_rounded,
            color: accentGreen,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Service Process",
                style: GoogleFonts.nunito(
                  fontSize: layout.isMobile ? 22 : 28,
                  fontWeight: FontWeight.w900,
                  color: lightText,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "A structured workflow from consultation and data acquisition to processing, analysis, validation, and delivery.",
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: layout.isMobile ? 13 : 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServicesCTASection extends StatelessWidget {
  final LayoutProvider layout;

  const _ServicesCTASection({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);

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
            maxWidth: layout.isMobile ? layout.contentWidth : 980,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 20 : 34),
            decoration: BoxDecoration(
              color: darkSurface.withOpacity(0.94),
              borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
              border: Border.all(
                color: darkBorder,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                  color: Colors.black.withOpacity(0.30),
                ),
              ],
            ),
            child: const ServiceCTA(),
          ),
        ),
      ),
    );
  }
}