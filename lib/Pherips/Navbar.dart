import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

class ResponsiveNavBar extends StatelessWidget {
  const ResponsiveNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    double navHeight = layout.isMobile
        ? 50
        : layout.isTablet
            ? 55
            : layout.isDesktop
                ? 60
                : 65;

    return Container(
      color: colors.onSecondaryContainer, // slightly lighter than title bar
      height: navHeight,
      child: Center(
        child: Container(
          width: layout.contentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
          ),
          child: layout.isMobile
              ? const _MobileNavMenu()
              : const _DesktopNavMenu(),
        ),
      ),
    );
  }
}

/* ================= MOBILE NAV ================= */

class _MobileNavMenu extends StatelessWidget {
  const _MobileNavMenu();

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

    return Align(
      alignment: Alignment.centerRight,
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (value) {},
        itemBuilder: (context) => items
            .map(
              (e) => PopupMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

/* ================= DESKTOP NAV ================= */

class _DesktopNavMenu extends StatelessWidget {
  const _DesktopNavMenu();

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: layout.isLargeDesktop ? 10 : 12,
              ),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      e,
                      style: TextStyle(
                        fontSize: layout.isLargeDesktop ? 16 : 14,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_outlined,color: Colors.white, size: layout.isLargeDesktop ? 16 : 12),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
