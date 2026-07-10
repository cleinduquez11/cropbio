import 'dart:async';

import 'package:cropbio/Models/UserModel.dart';
import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Providers/UserSession.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResponsiveTitleBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<ResponsiveTitleBar> createState() => _ResponsiveTitleBarState();

  @override
  Size get preferredSize => const Size.fromHeight(88);
}

class _ResponsiveTitleBarState extends State<ResponsiveTitleBar> {
  AppUser? user;
  bool isLoading = true;

  final GlobalKey signInKey = GlobalKey();
  final GlobalKey signUpKey = GlobalKey();

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF111C14);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkSurface3 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await UserSession.getUser();

    if (!mounted) return;

    setState(() {
      user = result;
      isLoading = false;
    });
  }

  void _navigateFromKey({
    required BuildContext context,
    required GlobalKey key,
    required String route,
  }) {
    final keyContext = key.currentContext;

    if (keyContext == null) {
      Navigator.pushNamed(context, route);
      return;
    }

    final renderObject = keyContext.findRenderObject();

    if (renderObject is! RenderBox) {
      Navigator.pushNamed(context, route);
      return;
    }

    final position = renderObject.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final direction = RouteTransitionHelper.getDirectionFromPosition(
      position,
      screenSize,
    );

    Navigator.pushNamed(
      context,
      route,
      arguments: direction,
    );
  }

  Future<void> _logout(BuildContext context) async {
    await UserSession.clearUser();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      "/landingpage",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      height: layout.appBarHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1712),
            Color(0xFF111C14),
            Color(0xFF162216),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            maxWidth: layout.contentWidth > 1280 ? 1280 : layout.contentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: layout.isMobile ? 14 : layout.outerMargin,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _LogoTitle(
                  title: widget.title,
                  logoHeight: layout.logoHeight,
                  logoWidth: layout.logoWidth,
                  isMobile: layout.isMobile,
                ),

                const Spacer(),

                if (!layout.isMobile) ...[
                  const _PHTimeWidget(),
                  const SizedBox(width: 14),
                ],

                if (!layout.isMobile) ...[
                  if (widget.onLanguagePressed != null)
                    _CircleIconButton(
                      tooltip: "Language",
                      icon: Icons.language_rounded,
                      onPressed: widget.onLanguagePressed!,
                    ),
                  if (widget.onToggleTheme != null) ...[
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      tooltip: "Toggle theme",
                      icon: Icons.dark_mode_rounded,
                      onPressed: widget.onToggleTheme!,
                    ),
                  ],
                  if (widget.onSearch != null) ...[
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      tooltip: "Search",
                      icon: Icons.search_rounded,
                      onPressed: widget.onSearch!,
                    ),
                  ],
                  const SizedBox(width: 12),
                  _authArea(layout),
                ],

                if (layout.isMobile)
                  _CircleIconButton(
                    tooltip: "Search",
                    icon: Icons.search_rounded,
                    onPressed: widget.onSearch ?? () {},
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authArea(LayoutProvider layout) {
    if (isLoading) {
      return const SizedBox(
        height: 36,
        width: 36,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: goldAccent,
          ),
        ),
      );
    }

    if (user != null) {
      return _UserMenu(
        user: user!,
        onSettings: () {
          Navigator.pushNamed(context, "/settings");
        },
        onLogout: () => _logout(context),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AuthButton(
          key: signInKey,
          label: "Sign In",
          isPrimary: false,
          isLarge: layout.isLargeDesktop,
          onPressed: () {
            _navigateFromKey(
              context: context,
              key: signInKey,
              route: "/signin",
            );
          },
        ),
        const SizedBox(width: 8),
        _AuthButton(
          key: signUpKey,
          label: "Sign Up",
          isPrimary: true,
          isLarge: layout.isLargeDesktop,
          onPressed: () {
            _navigateFromKey(
              context: context,
              key: signUpKey,
              route: "/signup",
            );
          },
        ),
      ],
    );
  }
}

class _LogoTitle extends StatefulWidget {
  final String title;
  final double logoHeight;
  final double logoWidth;
  final bool isMobile;

  const _LogoTitle({
    required this.title,
    required this.logoHeight,
    required this.logoWidth,
    required this.isMobile,
  });

  @override
  State<_LogoTitle> createState() => _LogoTitleState();
}

class _LogoTitleState extends State<_LogoTitle> {
  bool isHovered = false;

  static const Color goldAccent = Color(0xFFC6A432);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: "logo",
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                0,
                isHovered ? -3 : 0,
                0,
              ),
              child: AnimatedScale(
                scale: isHovered ? 1.035 : 1.0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: SizedBox(
                  height: widget.logoHeight,
                  width: widget.isMobile ? 150 : widget.logoWidth,
                  child: SvgPicture.asset(
                    "lib/Assets/Cropbio_LOGO_par.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
if (!widget.isMobile) ...[
  const SizedBox(width: 14),
  Container(
    width: 1,
    height: 34,
    color: Colors.white.withOpacity(0.12),
  ),
  const SizedBox(width: 14),
  Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "MMSU",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          color: lightText,
          fontSize: 19,
          fontWeight: FontWeight.w900,
          height: 1,
          letterSpacing: 0.4,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        "Mariano Marcos State University",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          color: isHovered ? goldAccent : mutedText,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    ],
  ),
],
       
        ],
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  final AppUser user;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const _UserMenu({
    required this.user,
    required this.onSettings,
    required this.onLogout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  Color get _roleColor {
    switch (user.role.toLowerCase()) {
      case "researcher":
        return Colors.blueAccent;
      case "admin":
        return Colors.redAccent;
      case "user":
      default:
        return primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "?";

    return PopupMenuButton<String>(
      tooltip: "Account",
      offset: const Offset(0, 48),
      color: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) {
        switch (value) {
          case "profile":
            Navigator.pushNamed(context, "/profile");
            break;
          case "settings":
            onSettings();
            break;
          case "logout":
            onLogout();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            width: 220,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _roleColor,
                  child: Text(
                    initial,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: const Color(0xFF162216),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: "profile",
          child: _menuRow(
            icon: Icons.person_outline_rounded,
            label: "Profile",
          ),
        ),
        PopupMenuItem(
          value: "settings",
          child: _menuRow(
            icon: Icons.settings_outlined,
            label: "Settings",
          ),
        ),
        PopupMenuItem(
          value: "logout",
          child: _menuRow(
            icon: Icons.logout_rounded,
            label: "Logout",
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: darkSurface2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: darkBorder,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _roleColor,
              child: Text(
                initial,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                user.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: goldAccent,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF3F6B2A),
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: const Color(0xFF162216),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool isHovered = false;

  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkSurface3 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
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
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isHovered ? darkSurface3 : darkSurface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isHovered ? goldAccent.withOpacity(0.65) : darkBorder,
            ),
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            icon: Icon(
              widget.icon,
              color: isHovered ? goldAccent : lightText,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final bool isLarge;
  final VoidCallback onPressed;

  const _AuthButton({
    super.key,
    required this.label,
    required this.isPrimary,
    required this.isLarge,
    required this.onPressed,
  });

  @override
  State<_AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<_AuthButton> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    final bool filled = widget.isPrimary || isHovered;

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
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -3 : 0,
          0,
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isLarge ? 18 : 14,
              vertical: widget.isLarge ? 11 : 9,
            ),
            foregroundColor: filled ? Colors.black : lightText,
            backgroundColor: filled
                ? (widget.isPrimary ? goldAccent : primaryGreen)
                : darkSurface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: filled ? Colors.transparent : darkBorder,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.nunito(
              fontSize: layout.bodyFontSize,
              fontWeight: FontWeight.w900,
              color: filled ? Colors.black : lightText,
            ),
          ),
        ),
      ),
    );
  }
}

class _PHTimeWidget extends StatefulWidget {
  const _PHTimeWidget();

  @override
  State<_PHTimeWidget> createState() => _PHTimeWidgetState();
}

class _PHTimeWidgetState extends State<_PHTimeWidget> {
  late DateTime now;
  Timer? timer;

  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface2 = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void initState() {
    super.initState();

    now = DateTime.now();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  DateTime get phTime => now.toUtc().add(const Duration(hours: 8));

  String get formattedTime {
    int hour = phTime.hour;
    final minute = phTime.minute.toString().padLeft(2, '0');
    final seconds = phTime.second.toString().padLeft(2, '0');

    final period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    final hourStr = hour.toString().padLeft(2, '0');

    return "$hourStr:$minute:$seconds $period";
  }

  String get formattedDate {
    final weekday = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ][phTime.weekday - 1];

    final month = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ][phTime.month - 1];

    return "$weekday, ${phTime.day} ${month} ${phTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    if (layout.isMobile) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      margin:  const EdgeInsets.symmetric(horizontal: 13, vertical: 9), 
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: goldAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 245),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PHILIPPINE STANDARD TIME",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: mutedText,
                    fontSize: layout.bodyFontSize * 0.62,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: lightText,
                    fontSize: layout.bodyFontSize * 0.72,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: goldAccent,
                    fontSize: layout.bodyFontSize * 0.74,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}