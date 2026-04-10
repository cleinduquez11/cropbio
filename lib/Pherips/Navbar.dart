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
                ? 55
                : 55;

    return Container(
      // color: Color(0xFF1E1E1E), // slightly lighter than title bar
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
      'Project',
      'Programs',
      'Services',
      'Data',
      'News',
      'About us'
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
      'Project',
      'Programs',
      'Services',
      'Data',
      'News',
      'About us'
    ];
    return SizedBox(
      width: double.infinity,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: items.map((e) {

          return Expanded(
            child: Center(
              child: TextButton(
                onPressed: () {
                  switch (e) {

                    case 'Home':
                      print(e);
                      break;

                    case 'Dashboard':
                      Navigator.pushNamed(context, "/dashboard");
                      print("$e is Selected");
                      break;

                    case 'Programs':
                      Navigator.pushNamed(context, "/map");
                      print("$e is Selected");
                      break;

                    default:
                  }
                },

                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: layout.verticalPadding / 2,
                  ),
                ),

                child: Text(
                  e,

                  style: TextStyle(
                    fontSize: layout.bodyFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );

        }).toList(),
      ),
    );
  }
}