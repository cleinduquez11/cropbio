// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';




class ProcessCard extends StatelessWidget {
  final ProcessStep step;

  const ProcessCard({super.key, 
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final hover = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: hover,
      builder: (context, isHovering, _) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,

          onEnter: (_) => hover.value = true,
          onExit: (_) => hover.value = false,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,

            transform: isHovering
                ? (Matrix4.identity()..translate(0.0, -6.0))
                : Matrix4.identity(),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              color: isHovering
                  ? const Color(0xFF3F6B2A)
                  : Colors.white,

              boxShadow: [
                BoxShadow(
                  blurRadius: isHovering ? 22 : 12,
                  offset: const Offset(0, 10),

                  color: isHovering
                      ? const Color(0xFF3F6B2A)
                          .withValues(alpha: 0.22)
                      : Colors.black.withValues(alpha: 0.06),
                ),
              ],
            ),

            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: isHovering
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFF3F6B2A)
                            .withValues(alpha: 0.1),
                  ),

                  child: Icon(
                    step.icon,

                    color: isHovering
                        ? Colors.white
                        : const Color(0xFF3F6B2A),
                  ),
                ),

                const SizedBox(height: 18),

                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,

                    color: isHovering
                        ? Colors.white
                        : Colors.black87,
                  ),

                  child: Text(step.title),
                ),

                const SizedBox(height: 10),

                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),

                  style: TextStyle(
                    color: isHovering
                        ? Colors.white70
                        : Colors.black54,

                    height: 1.5,
                    fontSize: 13,
                  ),

                  child: Text(
                    step.description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class ProcessStep {
  final String title;
  final String description;
  final IconData icon;

  ProcessStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
