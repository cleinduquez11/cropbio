import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerLogo extends StatelessWidget {
  final String name;
  final String assetPath;
  final String url;

  const PartnerLogo({
    super.key,
    required this.name,
    required this.assetPath,
    required this.url,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

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

          child: GestureDetector(
            onTap: _launchUrl,

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,

              transform: isHovering
                  ? (Matrix4.identity()..translate(0.0, -8.0))
                  : Matrix4.identity(),

              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 25,
              ),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                color: Colors.white.withValues(alpha: 0.06),

                border: Border.all(
                  color: isHovering
                      ? const Color(0xFF3F6B2A)
                      : Colors.white.withValues(alpha: 0.15),
                ),

                boxShadow: isHovering
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3F6B2A)
                              .withValues(alpha: 0.25),
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
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.3,
                      color: isHovering
                          ? Colors.white
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}