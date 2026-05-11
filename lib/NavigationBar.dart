import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/LayoutProvider.dart';

class ResponsiveNavBar extends StatelessWidget {
  const ResponsiveNavBar({super.key});

  static const List<_NavItem> _items = [
    _NavItem("Home", "/landingpage"),
    _NavItem("Project", "/project"),
    _NavItem("Dashboard", "/map"),
    _NavItem("Services", "/services"),
    _NavItem("Data", "/data"),
    _NavItem("Updates", "/updates"),
    _NavItem("About Us", "/aboutus"),
  ];

  @override
  Widget build(BuildContext context) {
    return Selector<
        LayoutProvider,
        ({
          bool isMobile,
          double contentWidth,
          double horizontalPadding,
          double verticalPadding,
          double bodyFontSize,
        })>(
      selector: (_, layout) => (
        isMobile: layout.isMobile,
        contentWidth: layout.contentWidth,
        horizontalPadding: layout.horizontalPadding,
        verticalPadding: layout.verticalPadding,
        bodyFontSize: layout.bodyFontSize,
      ),
      builder: (_, layout, __) {
        return SizedBox(
          height: layout.isMobile ? 50 : 55,
          child: Center(
            child: Container(
              width: layout.contentWidth,
              padding: EdgeInsets.symmetric(
                horizontal: layout.horizontalPadding,
              ),
              child: layout.isMobile
                  ? const _MobileNavMenu()
                  : _DesktopNavMenu(
                      items: _items,
                      verticalPadding: layout.verticalPadding,
                      bodyFontSize: layout.bodyFontSize,
                    ),
            ),
          ),
        );
      },
    );
  }
}

/* ================= MOBILE NAV ================= */

class _MobileNavMenu extends StatelessWidget {
  const _MobileNavMenu();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: PopupMenuButton<_NavItem>(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        color: const Color(0xFF1E1E1E),
        onSelected: (item) {
          Navigator.pushReplacementNamed(
            context,
            item.route,
          );
        },
        itemBuilder: (context) {
          return ResponsiveNavBar._items
              .map(
                (item) => PopupMenuItem<_NavItem>(
                  value: item,
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList();
        },
      ),
    );
  }
}

/* ================= DESKTOP NAV ================= */

class _DesktopNavMenu extends StatelessWidget {
  final List<_NavItem> items;
  final double verticalPadding;
  final double bodyFontSize;

  const _DesktopNavMenu({
    required this.items,
    required this.verticalPadding,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Center(
            child: _NavButton(
              item: item,
              verticalPadding: verticalPadding,
              bodyFontSize: bodyFontSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final double verticalPadding;
  final double bodyFontSize;

  const _NavButton({
    required this.item,
    required this.verticalPadding,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();

    return TextButton(
      key: key,
      onPressed: () {
        final renderBox =
            key.currentContext?.findRenderObject() as RenderBox?;

        if (renderBox == null) return;

        final position = renderBox.localToGlobal(Offset.zero);

        final direction =
            RouteTransitionHelper.getDirectionFromPosition(
          position,
          MediaQuery.of(context).size,
        );

        Navigator.pushReplacementNamed(
          context,
          item.route,
          arguments: direction,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding / 2,
        ),
      ),
      child: Text(
        item.label,
        style: TextStyle(
          fontSize: bodyFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/* ================= MODEL ================= */

class _NavItem {
  final String label;
  final String route;

  const _NavItem(this.label, this.route);
}