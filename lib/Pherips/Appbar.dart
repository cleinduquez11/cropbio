import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ResponsiveAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    double appBarHeight = layout.isMobile
        ? 60
        : layout.isTablet
            ? 70
            : layout.isDesktop
                ? 75
                : 85; // larger for big desktop

    return Container(
      color: const Color(0xFF0B3C5D),
      height: appBarHeight,
      child: Center(
        child: Container(
          width: layout.contentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT - TITLE
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: layout.isMobile ? 18 : 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              /// RIGHT - NAVIGATION
              layout.isMobile
                  ? const _MobileMenu()
                  : const _DesktopMenu(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

/* ================= MOBILE MENU ================= */

class _MobileMenu extends StatelessWidget {
  const _MobileMenu();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Home',
      'About',
      'Programs',
      'Biodiversity',
      'Data',
      'News',
      'Contact'
    ];

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {},
      itemBuilder: (context) => items
          .map((e) => PopupMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
    );
  }
}

/* ================= DESKTOP MENU ================= */

class _DesktopMenu extends StatelessWidget {
  const _DesktopMenu();

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = [
      'Home',
      'About',
      'Programs',
      'Biodiversity',
      'Data',
      'News',
      'Contact'
    ];

    return Row(
      children: items
          .map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: layout.isLargeDesktop ? 16 : 10,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  e,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
