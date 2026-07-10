import 'package:cropbio/AboutUsPage/Sections/AboutCTA.dart';
import 'package:cropbio/AboutUsPage/Sections/AboutHero.dart';
import 'package:cropbio/AboutUsPage/Sections/AboutMissionVision.dart';
import 'package:cropbio/AboutUsPage/Sections/Organization.dart';
import 'package:cropbio/AboutUsPage/Sections/Strengths.dart';
import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
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
              child: AboutHero(),
            ),

            /// ================= MISSION / VISION =================
            SliverToBoxAdapter(
              child: _AboutSectionShell(
                layout: layout,
                title: "Mission, Vision & Purpose",
                subtitle:
                    "Learn about the purpose, direction, and long-term goals that guide CropBio as a research-driven initiative for crop biodiversity and sustainable agriculture.",
                badge: "Institutional Direction",
                icon: Icons.flag_rounded,
                child: const MissionVisionSection(),
              ),
            ),

            /// ================= ORGANIZATION =================
            SliverToBoxAdapter(
              child: _AboutSectionShell(
                layout: layout,
                title: "Project Organization",
                subtitle:
                    "Understand how CropBio brings together institutions, researchers, technical experts, and partners to support field research, data systems, and project implementation.",
                badge: "Governance & Collaboration",
                icon: Icons.account_tree_rounded,
                child: const OrganizationSection(),
              ),
            ),

            /// ================= STRENGTHS =================
            SliverToBoxAdapter(
              child: _AboutSectionShell(
                layout: layout,
                title: "Core Strengths",
                subtitle:
                    "Explore the scientific, technical, institutional, and field-based strengths that support CropBio’s work in crop monitoring, geospatial analysis, and biodiversity research.",
                badge: "Capabilities",
                icon: Icons.workspace_premium_rounded,
                child: StrengthSection(),
              ),
            ),

            /// ================= CTA =================
            SliverToBoxAdapter(
              child: _AboutCTASection(layout: layout),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSectionShell extends StatelessWidget {
  final LayoutProvider layout;
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Widget child;

  const _AboutSectionShell({
    required this.layout,
    required this.title,
    required this.subtitle,
    required this.badge,
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
                child,
              ],
            ),
          ),
        ),
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
          constraints: const BoxConstraints(maxWidth: 820),
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
          Icon(
            icon,
            size: 17,
            color: accentGreen,
          ),
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

class _AboutCTASection extends StatelessWidget {
  final LayoutProvider layout;

  const _AboutCTASection({
    required this.layout,
  });

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
            child: const AboutCTA(),
          ),
        ),
      ),
    );
  }
}