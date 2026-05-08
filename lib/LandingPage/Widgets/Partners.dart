import 'package:flutter/material.dart';

class PartnerLogo extends StatelessWidget {
  final String name;
  final String assetPath;

  const PartnerLogo({super.key, 
    required this.name,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: 0, end: 0),
      builder: (context, value, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: StatefulBuilder(
            builder: (context, setState) {
              bool hover = false;

              return MouseRegion(
                onEnter: (_) => setState(() => hover = true),
                onExit: (_) => setState(() => hover = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  transform: hover
                      ? (Matrix4.identity()..translate(0, -8))
                      : Matrix4.identity(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(
                      color: hover
                          ? const Color(0xFF3F6B2A)
                          : Colors.white.withOpacity(0.15),
                    ),
                    boxShadow: hover
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3F6B2A)
                                  .withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        assetPath,
                        height: 55,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: hover
                              ? Colors.white
                              : Colors.white70,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}