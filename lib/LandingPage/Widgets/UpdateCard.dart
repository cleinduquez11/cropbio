import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateCard extends StatefulWidget {
  final String image;
  final String title;
  final String date;

  const UpdateCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
  });

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF1B231B);
  static const Color darkSurface2 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFD6E0D1);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final bool compact = width < 340;
          final bool veryCompact = width < 300;

          final double imageHeight = height <= 380
              ? 160
              : compact
                  ? 168
                  : 185;

          final double padding = compact ? 16 : 18;
          final double titleSize = veryCompact ? 15.5 : compact ? 16.5 : 18;
          final int titleLines = compact ? 2 : 3;

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
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isHovered ? darkSurface2 : darkSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isHovered
                      ? goldAccent.withOpacity(0.55)
                      : darkBorder.withOpacity(0.70),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: isHovered ? 22 : 14,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(isHovered ? 0.24 : 0.16),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: _imageArea(),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _categoryBadge(),
                          SizedBox(height: compact ? 10 : 12),

                          Flexible(
                            child: Text(
                              widget.title,
                              maxLines: titleLines,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontSize: titleSize,
                                height: 1.25,
                                fontWeight: FontWeight.w900,
                                color: lightText,
                              ),
                            ),
                          ),

                          const Spacer(),

                          _dateRow(compact),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imageArea() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF111C14),
                Color(0xFF1D2B20),
                Color(0xFF111C14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        AnimatedScale(
          scale: isHovered ? 1.045 : 1.0,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          child: Image.asset(
            widget.image,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            cacheWidth: 1000,
            frameBuilder: (
              context,
              child,
              frame,
              wasSynchronouslyLoaded,
            ) {
              if (wasSynchronouslyLoaded) return child;

              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                child: child,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF202820),
                child: const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white54,
                    size: 38,
                  ),
                ),
              );
            },
          ),
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.22),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryBadge() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.campaign_rounded,
            size: 13,
            color: isHovered ? goldAccent : accentGreen,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              "CropBio Update",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: isHovered ? goldAccent : mutedText,
                fontWeight: FontWeight.w900,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateRow(bool compact) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 14,
          color: mutedText.withOpacity(0.72),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            widget.date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: mutedText.withOpacity(0.78),
              fontSize: compact ? 12.5 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          transform: Matrix4.translationValues(
            isHovered ? 4 : 0,
            0,
            0,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: isHovered ? goldAccent : lightText,
            size: 18,
          ),
        ),
      ],
    );
  }
}