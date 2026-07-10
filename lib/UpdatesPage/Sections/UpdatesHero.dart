import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatesHero extends StatelessWidget {
  const UpdatesHero({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 54 : 82,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1712),
            Color(0xFF162216),
            Color(0xFF1E2E1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -42,
                right: -42,
                child: _glowCircle(
                  size: layout.isMobile ? 120 : 190,
                  color: primaryGreen.withOpacity(0.20),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -38,
                child: _glowCircle(
                  size: layout.isMobile ? 110 : 170,
                  color: goldAccent.withOpacity(0.12),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(layout.isMobile ? 22 : 42),
                decoration: BoxDecoration(
                  color: darkSurface.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(
                    layout.isMobile ? 24 : 34,
                  ),
                  border: Border.all(
                    color: darkBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 34,
                      offset: const Offset(0, 18),
                      color: Colors.black.withOpacity(0.34),
                    ),
                  ],
                ),
                child: layout.isMobile
                    ? _mobileContent(layout)
                    : _desktopContent(layout),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopContent(LayoutProvider layout) {
    return Row(
      children: [
        _logoPanel(layout),
        const SizedBox(width: 38),
        Expanded(
          child: _textContent(
            layout: layout,
            center: false,
          ),
        ),
      ],
    );
  }

  Widget _mobileContent(LayoutProvider layout) {
    return Column(
      children: [
        _logoPanel(layout),
        const SizedBox(height: 24),
        _textContent(
          layout: layout,
          center: true,
        ),
      ],
    );
  }

  Widget _logoPanel(LayoutProvider layout) {
    return Container(
      width: layout.isMobile ? 118 : 150,
      height: layout.isMobile ? 118 : 150,
      padding: EdgeInsets.all(layout.isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(layout.isMobile ? 28 : 34),
        border: Border.all(
          color: primaryGreen.withOpacity(0.30),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 26,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: SvgPicture.asset(
        "lib/Assets/Cropbio_clean.svg",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _textContent({
    required LayoutProvider layout,
    required bool center,
  }) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _heroBadge(),
        const SizedBox(height: 16),
        Text(
          "Updates & Research News",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 32 : 52,
            fontWeight: FontWeight.w900,
            color: lightText,
            height: 1.05,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            "Stay informed about CropBio field activities, research milestones, data releases, capacity-building initiatives, and institutional collaborations.",
            textAlign: center ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 15 : 18,
              fontWeight: FontWeight.w600,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          children: const [
            _HeroChip(
              icon: Icons.campaign_rounded,
              label: "Project Updates",
            ),
            _HeroChip(
              icon: Icons.science_rounded,
              label: "Research Notes",
            ),
            _HeroChip(
              icon: Icons.groups_rounded,
              label: "Collaborations",
            ),
            _HeroChip(
              icon: Icons.event_available_rounded,
              label: "Field Activities",
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "Latest CropBio developments",
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

  static Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({
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
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: accentGreen,
          ),
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