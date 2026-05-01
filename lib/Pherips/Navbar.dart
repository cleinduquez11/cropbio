import 'package:cropbio/Pherips/RouteDirection.dart';
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
      'Dashboard',
      'Services',
      'Data',
      'Updates',
      'About Us'
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
class _DesktopNavMenu extends StatefulWidget {
  const _DesktopNavMenu();

  @override
  State<_DesktopNavMenu> createState() => _DesktopNavMenuState();
}

class _DesktopNavMenuState extends State<_DesktopNavMenu> {
  // final GlobalKey cropbioMapKey = GlobalKey();
  final Map<String, GlobalKey> menuKeys = {
    "Home": GlobalKey(),
    "Dashboard": GlobalKey(),
    "Programs": GlobalKey(),
    "Data": GlobalKey(),
    "Services": GlobalKey(),
    "Updates": GlobalKey(),
    "About Us": GlobalKey(),
  };
  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final items = [
      'Home',
      'Project',
      'Dashboard',
      'Services',
      'Data',
      'Updates',
      'About Us'
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
                key: menuKeys[e],
                onPressed: () {
                  switch (e) {
                    case 'Home':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/landingpage",
                          arguments: direction);
                      print(e);
                      break;

                    case 'Dashboard':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/map",
                          arguments: direction);
                      print("$e is Selected");
                      break;

                    case 'Data':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/data",
                          arguments: direction);
                      print("$e is Selected");
                      break;

                    case 'Services':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/services",
                          arguments: direction);
                      print("$e is Selected");
                      break;

                    case 'Updates':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/updates",
                          arguments: direction);
                      print("$e is Selected");
                      break;

                    case 'About Us':
                      final RenderBox box = menuKeys[e]!
                          .currentContext!
                          .findRenderObject() as RenderBox;

                      final position = box.localToGlobal(Offset.zero);

                      final screenSize = MediaQuery.of(context).size;

                      final direction =
                          RouteTransitionHelper.getDirectionFromPosition(
                        position,
                        screenSize,
                      );
                      Navigator.pushNamed(context, "/aboutus",
                          arguments: direction);
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
