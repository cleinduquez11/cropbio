import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

class ResponsiveTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearch;
  final VoidCallback? onToggleTheme;
  final VoidCallback? onLanguagePressed;

  const ResponsiveTitleBar({
    super.key,
    required this.title,
    this.onSearch,
    this.onToggleTheme,
    this.onLanguagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    double barHeight = layout.isMobile
        ? 60
        : layout.isTablet
            ? 70
            : layout.isDesktop
                ? 75
                : 85;

    return Container(
      color: colors.primary, // dark blue background
      height: barHeight,
      child: Center(
        child: Container(
          width: layout.contentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              /// LEFT — TITLE
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: layout.isMobile ? 18 : 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              /// RIGHT — ACTION BUTTONS
              Row(
                children: [
                  _LanguageButton(
                    isLarge: layout.isLargeDesktop,
                    onPressed: onLanguagePressed,
                  ),
                  const SizedBox(width: 8),
                  _ThemeToggleButton(
                    isLarge: layout.isLargeDesktop,
                    onPressed: onToggleTheme,
                  ),
                  const SizedBox(width: 8),
                  _SearchButton(
                    isLarge: layout.isLargeDesktop,
                    onPressed: onSearch,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}

/* ================= LANGUAGE BUTTON ================= */

class _LanguageButton extends StatelessWidget {
  final bool isLarge;
  final VoidCallback? onPressed;

  const _LanguageButton({
    required this.isLarge,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.language, color: Colors.white),
      label: isLarge
          ? const Text(
              "EN",
              style: TextStyle(color: Colors.white),
            )
          : const SizedBox.shrink(),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    );
  }
}

/* ================= DARK MODE BUTTON ================= */

class _ThemeToggleButton extends StatelessWidget {
  final bool isLarge;
  final VoidCallback? onPressed;

  const _ThemeToggleButton({
    required this.isLarge,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.dark_mode,
        color: Colors.white,
      ),
      tooltip: "Toggle Dark Mode",
    );
  }
}

/* ================= SEARCH BUTTON ================= */

class _SearchButton extends StatelessWidget {
  final bool isLarge;
  final VoidCallback? onPressed;

  const _SearchButton({
    required this.isLarge,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      tooltip: "Search",
    );
  }
}
