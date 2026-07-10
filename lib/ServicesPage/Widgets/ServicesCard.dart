import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatefulWidget {
  final Service service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

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
          isHovered ? -7 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface3 : darkSurface2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.62) : darkBorder,
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 30 : 16,
              offset: Offset(0, isHovered ? 15 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.34 : 0.20),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.20),
              ),
          ],
        ),
        child: AnimatedScale(
          scale: isHovered ? 1.018 : 1.0,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              splashColor: primaryGreen.withOpacity(0.14),
              highlightColor: goldAccent.withOpacity(0.08),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  widget.service.route,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(layout.isMobile ? 18 : 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _iconBox(),
                    const SizedBox(height: 18),
                    Text(
                      widget.service.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: lightText,
                        fontSize: layout.isMobile ? 17 : 18,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        widget.service.description,
                        maxLines: layout.isMobile ? 5 : 6,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: mutedText,
                          fontSize: layout.isMobile ? 13.5 : 14,
                          fontWeight: FontWeight.w600,
                          height: 1.52,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _bottomAction(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(isHovered ? 0.28 : 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: Icon(
        widget.service.icon,
        size: 29,
        color: isHovered ? goldAccent : accentGreen,
      ),
    );
  }

  Widget _bottomAction() {
    return Row(
      children: [
        Text(
          "Explore service",
          style: GoogleFonts.nunito(
            color: isHovered ? goldAccent : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
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

class Service {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const Service({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}