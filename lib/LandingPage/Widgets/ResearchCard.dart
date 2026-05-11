import 'package:flutter/material.dart';

class ResearchCard extends StatefulWidget {
  final String title;
  final String description;

  const ResearchCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ResearchCard> createState() => _ResearchCardState();
}

class _ResearchCardState extends State<ResearchCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: hover
            ? (Matrix4.identity()..translate(0, -10))
            : Matrix4.identity(),
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: hover
              ? const Color(0xFF3F6B2A)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hover
                ? const Color(0xFF3F6B2A)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: hover ? 24 : 12,
              spreadRadius: hover ? 1 : 0,
              offset: const Offset(0, 10),
              color: hover
                  ? const Color(0xFF3F6B2A)
                      .withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hover
                    ? Colors.white.withValues(alpha: 0.15)
                    : const Color(0xFF3F6B2A)
                        .withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.eco,
                color: hover
                    ? Colors.white
                    : const Color(0xFF3F6B2A),
                size: 34,
              ),
            ),

            const SizedBox(height: 24),

            /// TITLE
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: hover
                    ? Colors.white
                    : Colors.black87,
              ),
              child: Text(widget.title),
            ),

            const SizedBox(height: 14),

            /// DESCRIPTION
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                height: 1.7,
                fontSize: 15,
                color: hover
                    ? Colors.white70
                    : Colors.black54,
              ),
              child: Text(widget.description),
            ),
          ],
        ),
      ),
    );
  }
}