import 'package:cropbio/Models/UserModel.dart';
import 'package:cropbio/Providers/UserSession.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/LayoutProvider.dart';

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
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _ResponsiveTitleBarState extends State<ResponsiveTitleBar> {
  AppUser? user;
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // double barHeight = layout.isMobile
    //     ? 60
    //     : layout.isTablet
    //         ? 70
    //         : layout.isDesktop
    //             ? 90
    //             : 100;

    return Container(
      color: Color(0xFF1E1E1E),
      // color: colors.primary, // dark blue background
      height: layout.appBarHeight,
      child: Center(
        child: Container(
          width: layout.contentWidth + 200,
          margin: EdgeInsets.symmetric(horizontal: layout.outerMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// LEFT — LOGO
              Hero(
                tag: "logo",
                child: SizedBox(
                  height: layout.logoHeight,
                  width: layout.logoWidth,
                  child: SvgPicture.asset(
                    "lib/Assets/Cropbio_Logo_par.svg",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              /// Push everything else to the right
              const Spacer(),

              const SizedBox(width: 20),
              _PHTimeWidget(),

              const SizedBox(width: 20),

              /// RIGHT — ACTION BUTTONS
              Row(
                children: [
                  // _LanguageButton(
                  //   isLarge: layout.isLargeDesktop,
                  //   onPressed: onLanguagePressed,
                  // ),
                  // const SizedBox(width: 8),
                  // _ThemeToggleButton(
                  //   isLarge: layout.isLargeDesktop,
                  //   onPressed: onToggleTheme,
                  // ),
                  const SizedBox(width: 8),
                  _SearchButton(
                    isLarge: layout.isLargeDesktop,
                    onPressed: widget.onSearch,
                  ),
                  if (!layout.isMobile) ...[
                    const SizedBox(width: 12),

                    /// ================= LOGGED IN =================
                    if (user != null) ...[
                      Row(
                        children: [
                                                   

                          /// PROFILE BUTTON
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF3F6B2A),
                            child: Text(
                              user!.fullName.isNotEmpty
                                  ? user!.fullName[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                           const SizedBox(width: 10),
                          /// USER NAME
                          Text(
                            "${user!.fullName.split(" ")[0][0].toUpperCase()}${user!.fullName.split(" ")[1][0].toUpperCase()}. ${user!.fullName.split(" ")[2]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),



                          const SizedBox(width: 10),

                          /// LOGOUT BUTTON (optional)
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.remove("logged_in_user");

                              if (!mounted) return;

                              Navigator.pushReplacementNamed(
                                context,
                                "/signin",
                              );
                            },
                          ),
                        ],
                      )
                    ]

                    /// ================= NOT LOGGED IN =================
                    else ...[
                      _AuthButton(
                        label: "Sign In",
                        isPrimary: false,
                        isLarge: layout.isLargeDesktop,
                        onPressed: () {
                          Navigator.pushNamed(context, "/signin");
                        },
                      ),
                      const SizedBox(width: 8),
                      _AuthButton(
                        label: "Sign Up",
                        isPrimary: true,
                        isLarge: layout.isLargeDesktop,
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                      ),
                    ]
                  ]
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

// auth button
class _AuthButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isLarge;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.label,
    required this.isPrimary,
    required this.isLarge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 18 : 14,
          vertical: isLarge ? 10 : 8,
        ),
        foregroundColor: isPrimary ? colors.onPrimary : colors.onSecondary,
        backgroundColor: isPrimary ? colors.primary : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(
                  color: colors.outline.withOpacity(0.4),
                ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: layout.bodyFontSize,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _PHTimeWidget extends StatefulWidget {
  const _PHTimeWidget({super.key});

  @override
  State<_PHTimeWidget> createState() => _PHTimeWidgetState();
}

class _PHTimeWidgetState extends State<_PHTimeWidget> {
  late DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        now = DateTime.now();
      });

      return true;
    });
  }

  String get formattedTime {
    final phTime = now.toUtc().add(const Duration(hours: 8));

    int hour = phTime.hour;
    final minute = phTime.minute.toString().padLeft(2, '0');
    final seconds = phTime.second.toString().padLeft(2, '0');

    final period = hour >= 12 ? "PM" : "AM";

    // convert to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12;

    final hourStr = hour.toString().padLeft(2, '0');

    return "$hourStr:$minute:$seconds $period";
  }

  String get formattedDate {
    final phTime = now.toUtc().add(const Duration(hours: 8));

    final weekday = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][phTime.weekday - 1];

    final day = phTime.day;
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
      "December"
    ][phTime.month - 1];

    String suffix(int d) {
      if (d >= 11 && d <= 13) return "th";
      switch (d % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    }

    return "$weekday, ${day}${suffix(day)} of $month ${phTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    if (layout.isMobile) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // decoration: BoxDecoration(
        //   color: Colors.white.withOpacity(0.06),
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(
        //     color: Colors.white.withOpacity(0.10),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// LABEL
            Text(
              "PHILIPPINE STANDARD TIME",
              style: TextStyle(
                color: Colors.white60,
                fontSize: layout.bodyFontSize * 0.60,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),

            /// DATE
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white,
                fontSize: layout.bodyFontSize * 0.70,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 3),
            Text(
              formattedTime,
              style: TextStyle(
                color: const Color(0xFFC6A432),
                fontSize: layout.bodyFontSize * 0.70,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            /// TIME (highlighted slightly)
          ],
        ),
      ),
    );
  }
}
