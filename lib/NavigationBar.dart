import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResponsiveNavBar extends StatelessWidget {
  const ResponsiveNavBar({super.key});

  static const List<_NavItem> _items = [
    _NavItem("Home", "/landingpage", Icons.home_rounded),
    _NavItem("Project", "/projectpage", Icons.workspaces_rounded),
    _NavItem("Dashboard", "/map", Icons.dashboard_rounded),
    _NavItem("Services", "/services", Icons.design_services_rounded),
    _NavItem("Data", "/data", Icons.storage_rounded),
    _NavItem("Updates", "/updates", Icons.campaign_rounded),
    _NavItem("About Us", "/aboutus", Icons.info_rounded),
  ];

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF111C14);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Selector<
        LayoutProvider,
        ({
          bool isMobile,
          bool isTablet,
          double contentWidth,
          double horizontalPadding,
          double outerMargin,
          double bodyFontSize,
        })>(
      selector: (_, layout) => (
        isMobile: layout.isMobile,
        isTablet: layout.isTablet,
        contentWidth: layout.contentWidth,
        horizontalPadding: layout.horizontalPadding,
        outerMargin: layout.outerMargin,
        bodyFontSize: layout.bodyFontSize,
      ),
      builder: (_, layout, __) {
        final activeRoute = ModalRoute.of(context)?.settings.name;

        return Container(
          height: layout.isMobile ? 56 : 62,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F1712),
                Color(0xFF111C14),
                Color(0xFF162216),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border(
              bottom: BorderSide(
                color: darkBorder,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: layout.contentWidth > 1280
                    ? 1280
                    : layout.contentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: layout.isMobile ? 14 : layout.outerMargin,
                ),
                child: layout.isMobile
                    ? _MobileNavMenu(
                        items: _items,
                        activeRoute: activeRoute,
                      )
                    : _DesktopNavMenu(
                        items: _items,
                        activeRoute: activeRoute,
                        bodyFontSize: layout.bodyFontSize,
                      ),
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
  final List<_NavItem> items;
  final String? activeRoute;

  const _MobileNavMenu({
    required this.items,
    required this.activeRoute,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkSurface3 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Navigation",
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const Spacer(),
        PopupMenuButton<_NavItem>(
          tooltip: "Open menu",
          offset: const Offset(0, 46),
          color: darkSurface2,
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: darkBorder,
            ),
          ),
          onSelected: (item) {
            if (activeRoute == item.route) return;

            Navigator.pushReplacementNamed(
              context,
              item.route,
            );
          },
          itemBuilder: (context) {
            return items.map((item) {
              final isActive = activeRoute == item.route;

              return PopupMenuItem<_NavItem>(
                value: item,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: isActive ? goldAccent : mutedText,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.nunito(
                            color: isActive ? goldAccent : lightText,
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isActive)
                        const Icon(
                          Icons.check_rounded,
                          color: goldAccent,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: darkSurface3,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: darkBorder,
              ),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: goldAccent,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

/* ================= DESKTOP NAV ================= */

class _DesktopNavMenu extends StatelessWidget {
  final List<_NavItem> items;
  final String? activeRoute;
  final double bodyFontSize;

  const _DesktopNavMenu({
    required this.items,
    required this.activeRoute,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        final isActive = activeRoute == item.route;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _NavButton(
              item: item,
              isActive: isActive,
              bodyFontSize: bodyFontSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final double bodyFontSize;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.bodyFontSize,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  final GlobalKey navKey = GlobalKey();
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkSurface3 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  void _navigate(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == widget.item.route) return;

    final renderBox = navKey.currentContext?.findRenderObject();

    if (renderBox is! RenderBox) {
      Navigator.pushReplacementNamed(
        context,
        widget.item.route,
      );
      return;
    }

    final position = renderBox.localToGlobal(Offset.zero);

    final direction = RouteTransitionHelper.getDirectionFromPosition(
      position,
      MediaQuery.of(context).size,
    );

    Navigator.pushReplacementNamed(
      context,
      widget.item.route,
      arguments: direction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.isActive || isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        key: navKey,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 42,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -3 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.isActive
              ? primaryGreen.withOpacity(0.28)
              : isHovered
                  ? darkSurface3
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isActive
                ? goldAccent.withOpacity(0.60)
                : isHovered
                    ? darkBorder
                    : Colors.transparent,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: primaryGreen.withOpacity(0.14),
            highlightColor: goldAccent.withOpacity(0.08),
            onTap: () => _navigate(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 7,
                        width: highlighted ? 7 : 0,
                        margin: EdgeInsets.only(
                          right: highlighted ? 7 : 0,
                        ),
                        decoration: const BoxDecoration(
                          color: goldAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: widget.isActive
                              ? goldAccent
                              : isHovered
                                  ? lightText
                                  : mutedText,
                          fontSize: widget.bodyFontSize,
                          fontWeight: widget.isActive
                              ? FontWeight.w900
                              : FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= MODEL ================= */

class _NavItem {
  final String label;
  final String route;
  final IconData icon;

  const _NavItem(
    this.label,
    this.route,
    this.icon,
  );
}