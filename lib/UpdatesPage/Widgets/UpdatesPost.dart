import 'package:flutter/material.dart';

class UpdatesPost {
  final String title;
  final String excerpt;
  final String category;
  final String date;

  UpdatesPost({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
  });
}





class UpdatesCard extends StatelessWidget {
  final UpdatesPost post;

  const UpdatesCard({super.key, 
    required this.post,
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
                ? (Matrix4.identity()..translate(0.0, -8.0))
                : Matrix4.identity(),

            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              color: isHovering
                  ? const Color(0xFF3F6B2A)
                  : Colors.white,

              boxShadow: [
                BoxShadow(
                  blurRadius: isHovering ? 22 : 15,
                  offset: const Offset(0, 10),

                  color: isHovering
                      ? const Color(0xFF3F6B2A)
                          .withValues(alpha: 0.18)
                      : Colors.black.withValues(alpha: 0.08),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// CATEGORY TAG
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: isHovering
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFF3F6B2A)
                            .withValues(alpha: 0.1),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    post.category,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,

                      color: isHovering
                          ? Colors.white
                          : const Color(0xFF3F6B2A),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// TITLE
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                    color: isHovering
                        ? Colors.white
                        : Colors.black87,
                  ),

                  child: Text(post.title),
                ),

                const SizedBox(height: 10),

                /// EXCERPT
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),

                  style: TextStyle(
                    height: 1.6,

                    color: isHovering
                        ? Colors.white70
                        : Colors.black54,
                  ),

                  child: Text(post.excerpt),
                ),

                const Spacer(),

                /// FOOTER
                Row(
                  children: [
                    Text(
                      post.date,

                      style: TextStyle(
                        fontSize: 12,

                        color: isHovering
                            ? Colors.white60
                            : Colors.black38,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      Icons.arrow_forward,

                      color: isHovering
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}