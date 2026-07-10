import 'package:cropbio/DataPage/Widgets/TabularDataListPage.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DataTypeCard extends StatefulWidget {
  final DataType item;

  const DataTypeCard({
    super.key,
    required this.item,
  });

  @override
  State<DataTypeCard> createState() => _DataTypeCardState();
}

class _DataTypeCardState extends State<DataTypeCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color deepGreen = Color(0xFF243625);
  static const Color hoverGreen = Color(0xFF2F4F2F);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFD6E0D1);

  void _openDataType(BuildContext context) {
    if (widget.item.type == "tabular") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TabularDataListPage(
            type: widget.item.type,
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${widget.item.title} will be available soon.",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryGreen,
      ),
    );
  }

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
          gradient: LinearGradient(
            colors: isHovered
                ? const [
                    primaryGreen,
                    hoverGreen,
                  ]
                : const [
                    hoverGreen,
                    deepGreen,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered
                ? goldAccent.withOpacity(0.78)
                : accentGreen.withOpacity(0.35),
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 30 : 16,
              offset: Offset(0, isHovered ? 15 : 7),
              color: Colors.black.withOpacity(isHovered ? 0.26 : 0.14),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.25),
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
              splashColor: goldAccent.withOpacity(0.12),
              highlightColor: Colors.white.withOpacity(0.06),
              onTap: () => _openDataType(context),
              child: Padding(
                padding: EdgeInsets.all(layout.isMobile ? 18 : 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topRow(),
                    const SizedBox(height: 22),
                    Text(
                      widget.item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: lightText,
                        fontSize: layout.isMobile ? 18 : 20,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        widget.item.description,
                        maxLines: layout.isMobile ? 4 : 5,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: mutedText,
                          fontSize: layout.isMobile ? 13.2 : 14,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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

  Widget _topRow() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHovered ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
            ),
          ),
          child: Icon(
            widget.item.icon,
            size: 31,
            color: isHovered ? goldAccent : lightText,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
            ),
          ),
          child: Text(
            widget.item.type.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: isHovered ? goldAccent : lightText,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.item.type == "tabular" ? "View records" : "Coming soon",
          style: GoogleFonts.nunito(
            color: isHovered ? goldAccent : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          transform: Matrix4.translationValues(
            isHovered ? 5 : 0,
            0,
            0,
          ),
          child: Icon(
            widget.item.type == "tabular"
                ? Icons.arrow_forward_rounded
                : Icons.lock_clock_rounded,
            color: isHovered ? goldAccent : lightText,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class DataType {
  final String title;
  final String description;
  final IconData icon;
  final String type;

  const DataType({
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
  });
}