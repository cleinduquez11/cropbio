import 'package:cropbio/LandingPage/Widgets/UpdateCard.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatesSection extends StatelessWidget {
  const UpdatesSection({super.key});

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

    final updates = const [
      _UpdateItem(
        image: "lib/Assets/Sample_Files/Sampless/1.jpg",
        title: "Field Survey and Crop Diversity Sampling in Dry Season Areas",
        date: "May 2026",
      ),
      _UpdateItem(
        image: "lib/Assets/Sample_Files/Sampless/2.jpg",
        title:
            "Hands-on drone training for agricultural monitoring and data collection",
        date: "April 2026",
      ),
      _UpdateItem(
        image: "lib/Assets/Sample_Files/Sampless/3.jpg",
        title:
            "Training: Remote Sensing and GIS for Crop Biodiversity Assessment",
        date: "March 2026",
      ),
    ];

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
            maxWidth: layout.contentWidth > 1200 ? 1200 : layout.contentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 16 : 28),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(layout),
                SizedBox(height: layout.isMobile ? 22 : 34),
                _updatesGrid(context, updates),
                SizedBox(height: layout.isMobile ? 30 : 42),
                Center(
                  child: _SeeMoreButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/updates");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        Expanded(child: _titleBlock(layout)),
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
          "Latest Updates",
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
            "Recent activities, field surveys, drone work, data collection, and research developments from the CropBio initiative.",
            style: GoogleFonts.nunito(
              fontSize: layout.isMobile ? 13.5 : 15,
              height: 1.55,
              color: mutedText,
              fontWeight: FontWeight.w600,
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
            Icons.campaign_rounded,
            size: 17,
            color: accentGreen,
          ),
          const SizedBox(width: 8),
          Text(
            "News & Activities",
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

Widget _updatesGrid(BuildContext context, List<_UpdateItem> updates) {
  final layout = context.watch<LayoutProvider>();

  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;

      final double spacing = layout.isMobile ? 14 : 18;

      /// Desktop view: always keep the 3 update cards in one row.
      if (!layout.isMobile && width >= 900) {
        return SizedBox(
          height: 405,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: updates.asMap().entries.map((entry) {
              final index = entry.key;
              final update = entry.value;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == updates.length - 1 ? 0 : spacing,
                  ),
                  child: _HoverUpdateCard(
                    onTap: () {
                      Navigator.pushNamed(context, "/updates");
                    },
                    child: UpdateCard(
                      image: update.image,
                      title: update.title,
                      date: update.date,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }

      /// Tablet and mobile fallback.
      final int columnCount = width >= 680 ? 2 : 1;

      final double cardHeight = columnCount == 1 ? 410 : 395;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: updates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: cardHeight,
        ),
        itemBuilder: (context, index) {
          final update = updates[index];

          return _HoverUpdateCard(
            onTap: () {
              Navigator.pushNamed(context, "/updates");
            },
            child: UpdateCard(
              image: update.image,
              title: update.title,
              date: update.date,
            ),
          );
        },
      );
    },
  );
}

}

class _HoverUpdateCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _HoverUpdateCard({
    required this.child,
    this.onTap,
  });

  @override
  State<_HoverUpdateCard> createState() => _HoverUpdateCardState();
}

class _HoverUpdateCardState extends State<_HoverUpdateCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkBorder = Color(0xFF2E3E31);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
          isHovered ? -8 : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.75) : darkBorder,
            width: isHovered ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 34 : 14,
              offset: Offset(0, isHovered ? 18 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.42 : 0.22),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.25),
              ),
          ],
        ),
        child: AnimatedScale(
          scale: isHovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                splashColor: primaryGreen.withOpacity(0.12),
                highlightColor: goldAccent.withOpacity(0.08),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateItem {
  final String image;
  final String title;
  final String date;

  const _UpdateItem({
    required this.image,
    required this.title,
    required this.date,
  });
}

class _SeeMoreButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _SeeMoreButton({
    required this.onPressed,
  });

  @override
  State<_SeeMoreButton> createState() => _SeeMoreButtonState();
}

class _SeeMoreButtonState extends State<_SeeMoreButton> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
          isHovered ? -4 : 0,
          0,
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovered ? goldAccent : primaryGreen,
            foregroundColor: isHovered ? Colors.black : lightText,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isHovered ? goldAccent : darkBorder,
              ),
            ),
          ),
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: isHovered ? Colors.black : lightText,
            size: 20,
          ),
          label: Text(
            "See More Updates",
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
              color: isHovered ? Colors.black : lightText,
            ),
          ),
        ),
      ),
    );
  }
}