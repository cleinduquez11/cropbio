import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VisionText extends StatelessWidget {
  const VisionText({super.key});

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
        _visionBadge(),
        const SizedBox(height: 16),

        Text(
          "Advancing Crop Diversity Through Space-enabled Field Evidence",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 28 : 38,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          "CropBio integrates Earth observation, UAV mapping, GVG field sampling, FieldWatch boundary mapping, plot surveys, spectral measurements, LAI/FVC observations, and geospatial analytics to support crop biodiversity monitoring and sustainable farming systems.",
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 15 : 17,
            fontWeight: FontWeight.w600,
            height: 1.65,
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _VisionChip(
              icon: Icons.satellite_alt_rounded,
              label: "Earth Observation",
            ),
            _VisionChip(
              icon: Icons.flight_takeoff_rounded,
              label: "UAV Mapping",
            ),
            _VisionChip(
              icon: Icons.edit_location_alt_rounded,
              label: "GVG Sampling",
            ),
            _VisionChip(
              icon: Icons.map_rounded,
              label: "FieldWatch Boundaries",
            ),
            _VisionChip(
              icon: Icons.science_rounded,
              label: "In-situ Measurements",
            ),
          ],
        ),
      ],
    );
  }

  Widget _visionBadge() {
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
            Icons.eco_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "CropBio Mission",
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

class VisionImage extends StatefulWidget {
  const VisionImage({super.key});

  @override
  State<VisionImage> createState() => _VisionImageState();
}

class _VisionImageState extends State<VisionImage> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

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
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: layout.isMobile ? 280 : 400,
        width: double.infinity,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -8 : 0,
          0,
        ),
        padding: EdgeInsets.all(layout.isMobile ? 24 : 36),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isHovered
                ? const [
                    Color(0xFF243625),
                    Color(0xFF1D2B20),
                    Color(0xFF162216),
                  ]
                : const [
                    Color(0xFF1D2B20),
                    Color(0xFF162216),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(layout.isMobile ? 24 : 32),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.65) : darkBorder,
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 34 : 20,
              offset: Offset(0, isHovered ? 18 : 9),
              color: Colors.black.withOpacity(isHovered ? 0.36 : 0.22),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 30,
                color: primaryGreen.withOpacity(0.24),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: isHovered ? 0.22 : 0.12,
              child: Container(
                height: layout.isMobile ? 190 : 260,
                width: layout.isMobile ? 190 : 260,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: isHovered ? 0.18 : 0.10,
              child: Container(
                height: layout.isMobile ? 135 : 190,
                width: layout.isMobile ? 135 : 190,
                decoration: const BoxDecoration(
                  color: goldAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            AnimatedRotation(
              turns: isHovered ? 0.015 : 0.0,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: AnimatedScale(
                scale: isHovered ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.all(layout.isMobile ? 20 : 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(layout.isMobile ? 26 : 34),
                    border: Border.all(
                      color: isHovered
                          ? goldAccent.withOpacity(0.70)
                          : primaryGreen.withOpacity(0.22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: isHovered ? 26 : 16,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.24),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    "lib/Assets/Cropbio_clean.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Positioned(
              right: layout.isMobile ? 12 : 18,
              bottom: layout.isMobile ? 12 : 18,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isHovered
                      ? goldAccent.withOpacity(0.95)
                      : darkSurface3.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isHovered ? goldAccent : darkBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: isHovered ? Colors.black : accentGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Space-enabled",
                      style: GoogleFonts.nunito(
                        color: isHovered ? Colors.black : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _VisionChip({
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