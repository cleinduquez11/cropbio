import 'package:flutter/material.dart';

class UpdatesSearchBar extends StatefulWidget {
  final Function(String) onChanged;

  const UpdatesSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  State<UpdatesSearchBar> createState() => _UpdatesSearchBarState();
}

class _UpdatesSearchBarState extends State<UpdatesSearchBar> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? const Color(0xFF3F6B2A)
        : Colors.black.withValues(alpha: 0.08);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              blurRadius: _hover || _focused ? 18 : 10,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),

        child: Focus(
          onFocusChange: (value) {
            setState(() => _focused = value);
          },

          child: TextField(
            onChanged: widget.onChanged,

            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),

            cursorColor: const Color(0xFF3F6B2A),

            decoration: const InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.black45,
              ),

              hintText: "Search updates, research, datasets...",

              hintStyle: TextStyle(
                color: Colors.black45,
                fontSize: 14,
              ),

              border: InputBorder.none,

              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}