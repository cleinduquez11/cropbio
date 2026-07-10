import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

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
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      width: double.infinity,
      color: darkBg,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 46 : 72,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth > 1220 ? 1220 : layout.contentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 18 : 30),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
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
              children: [
                _sectionHeader(layout),
                SizedBox(height: layout.isMobile ? 28 : 38),
                _partnersOneLine(layout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(LayoutProvider layout) {
    return Column(
      children: [
        _sectionBadge(),
        const SizedBox(height: 14),
        Text(
          "In Collaboration With",
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 26 : 34,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            "CropBio is implemented through partnerships among academic, space, policy, and research institutions working together to advance crop biodiversity, geospatial innovation, and sustainable agriculture.",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 14 : 15.5,
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
            Icons.handshake_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "Strategic Partners",
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

  Widget _partnersOneLine(LayoutProvider layout) {
    final partners = const [
      _PartnerItem(
        name: "MMSU",
        assetPath: "lib/Assets/Agency_Logos/MMSU_SMALL.png",
        type: "Host Institution",
      ),
      _PartnerItem(
        name: "PhilSA",
        assetPath: "lib/Assets/Agency_Logos/PhilSa_SMALL.png",
        type: "Space Agency",
      ),
      _PartnerItem(
        name: "CHED",
        assetPath: "lib/Assets/Agency_Logos/CHED_SMALL.png",
        type: "Higher Education",
      ),
      _PartnerItem(
        name: "UNESCAP",
        assetPath: "lib/Assets/Agency_Logos/unescap.png",
        type: "Regional Partner",
      ),
      _PartnerItem(
        name: "AIRCAS",
        assetPath: "lib/Assets/Agency_Logos/AIRCAS_SMALL.png",
        type: "Research Partner",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final spacing = layout.isMobile ? 12.0 : 14.0;
        final totalSpacing = spacing * (partners.length - 1);

        final preferredCardWidth = layout.isMobile ? 160.0 : 200.0;
        final fittedCardWidth =
            ((availableWidth - totalSpacing) / partners.length)
                .clamp(145.0, preferredCardWidth);

        final needsHorizontalScroll =
            availableWidth < (145 * partners.length + totalSpacing);

        final row = Row(
          mainAxisSize:
              needsHorizontalScroll ? MainAxisSize.min : MainAxisSize.max,
          children: partners.asMap().entries.map((entry) {
            final index = entry.key;
            final partner = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                right: index == partners.length - 1 ? 0 : spacing,
              ),
              child: SizedBox(
                width: needsHorizontalScroll ? 160 : fittedCardWidth,
                child: _PartnerCard(partner: partner),
              ),
            );
          }).toList(),
        );

        if (needsHorizontalScroll) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: row,
          );
        }

        return row;
      },
    );
  }
}

class _PartnerItem {
  final String name;
  final String assetPath;
  final String type;

  const _PartnerItem({
    required this.name,
    required this.assetPath,
    required this.type,
  });
}

class _PartnerCard extends StatefulWidget {
  final _PartnerItem partner;

  const _PartnerCard({
    required this.partner,
  });

  @override
  State<_PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends State<_PartnerCard> {
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
        height: 190,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.62) : darkBorder,
            width: isHovered ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 26 : 14,
              offset: Offset(0, isHovered ? 13 : 6),
              color: Colors.black.withOpacity(isHovered ? 0.32 : 0.18),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 22,
                color: primaryGreen.withOpacity(0.18),
              ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.20),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    widget.partner.assetPath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_rounded,
                        color: primaryGreen.withOpacity(0.65),
                        size: 34,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.partner.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 15.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.partner.type,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: mutedText,
                fontSize: 11.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 4,
              width: isHovered ? 44 : 24,
              decoration: BoxDecoration(
                color: isHovered ? goldAccent : accentGreen,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}