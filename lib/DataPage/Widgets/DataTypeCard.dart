import 'package:flutter/material.dart';

class DataTypeCard extends StatelessWidget {
  final DataType item;

  const DataTypeCard({super.key, 
    required this.item,
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

          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => DataListPage(
              //       type: item.type,
              //     ),
              //   ),
              // );
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,

              transform: isHovering
                  ? (Matrix4.identity()..translate(0.0, -8.0))
                  : Matrix4.identity(),

              width: 260,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: isHovering
                    ? const Color(0xFF3F6B2A)
                    : Colors.white,

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: isHovering
                      ? const Color(0xFF3F6B2A)
                      : Colors.grey.shade200,
                ),

                boxShadow: [
                  BoxShadow(
                    blurRadius: isHovering ? 24 : 15,
                    spreadRadius: isHovering ? 1 : 0,
                    offset: const Offset(0, 10),

                    color: isHovering
                        ? const Color(0xFF3F6B2A)
                            .withValues(alpha: 0.22)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),

                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: isHovering
                          ? Colors.white.withValues(alpha: 0.15)
                          : const Color(0xFF3F6B2A)
                              .withValues(alpha: 0.08),
                    ),

                    child: Icon(
                      item.icon,
                      size: 34,

                      color: isHovering
                          ? Colors.white
                          : const Color(0xFF3F6B2A),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                      color: isHovering
                          ? Colors.white
                          : Colors.black87,
                    ),

                    child: Text(item.title),
                  ),

                  const SizedBox(height: 12),

                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),

                    style: TextStyle(
                      color: isHovering
                          ? Colors.white70
                          : Colors.black54,

                      height: 1.6,
                    ),

                    child: Text(item.description),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),

                      child: Icon(
                        Icons.arrow_forward,

                        color: isHovering
                            ? Colors.white
                            : Colors.black87,
                      ),
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


class DataType {
  final String title;
  final String description;
  final IconData icon;
  final String type;

  DataType({
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
  });
}
