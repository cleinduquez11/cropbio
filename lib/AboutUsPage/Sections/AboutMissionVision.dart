import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MissionVisionSection extends StatelessWidget {
  const MissionVisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = [
      const _MissionVisionItem(
        icon: Icons.flag_rounded,
        title: "Our Mission",
        text:
            "To collect, manage, and disseminate high-quality crop biodiversity data that supports scientific research, conservation, and sustainable agriculture.",
        badge: "Purpose",
      ),
      const _MissionVisionItem(
        icon: Icons.visibility_rounded,
        title: "Our Vision",
        text:
            "To become a leading digital platform for agricultural biodiversity research, innovation, and evidence-based decision-making in Southeast Asia.",
        badge: "Direction",
      ),
    ];

    if (layout.isMobile) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MissionVisionCard(item: item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MissionVisionCard(item: items[0]),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _MissionVisionCard(item: items[1]),
        ),
      ],
    );
  }
}

class _MissionVisionItem {
  final IconData icon;
  final String title;
  final String text;
  final String badge;

  const _MissionVisionItem({
    required this.icon,
    required this.title,
    required this.text,
    required this.badge,
  });
}

class _MissionVisionCard extends StatefulWidget {
  final _MissionVisionItem item;

  const _MissionVisionCard({
    required this.item,
  });

  @override
  State<_MissionVisionCard> createState() => _MissionVisionCardState();
}

class _MissionVisionCardState extends State<_MissionVisionCard> {
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
          isHovered ? -6 : 0,
          0,
        ),
        width: double.infinity,
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
            _topRow(),
            const SizedBox(height: 22),
            Text(
              widget.item.title,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.item.text,
              style: GoogleFonts.nunito(
                color: mutedText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      children: [
        AnimatedContainer(
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
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.16),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: primaryGreen.withOpacity(0.30),
            ),
          ),
          child: Text(
            widget.item.badge,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}