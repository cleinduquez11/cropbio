import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Providers/UpdatesProvider.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesGrid.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesHero.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return AppShell(
      child: Container(
        color: darkBg,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// ================= HERO =================
            const SliverToBoxAdapter(
              child: UpdatesHero(),
            ),

            /// ================= SEARCH =================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: layout.isMobile
                      ? layout.verticalPadding
                      : layout.verticalPadding * 1.15,
                  horizontal: layout.isMobile ? 14 : 24,
                ),
                color: darkBg,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: _UpdatesSearchPanel(layout: layout),
                  ),
                ),
              ),
            ),

            /// ================= POSTS =================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  layout.isMobile ? 14 : 24,
                  0,
                  layout.isMobile ? 14 : 24,
                  layout.isMobile
                      ? layout.verticalPadding * 1.4
                      : layout.verticalPadding * 2,
                ),
                color: darkBg,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: _UpdatesGridPanel(layout: layout),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdatesSearchPanel extends StatelessWidget {
  final LayoutProvider layout;

  const _UpdatesSearchPanel({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: layout.isMobile ? _mobileLayout(context) : _desktopLayout(context),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        _iconBox(),
        const SizedBox(width: 18),
        Expanded(
          child: _titleBlock(),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 430,
          child: _searchBox(context),
        ),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _iconBox(),
            const SizedBox(width: 14),
            Expanded(
              child: _titleBlock(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _searchBox(context),
      ],
    );
  }

  Widget _iconBox() {
    return Container(
      height: layout.isMobile ? 48 : 56,
      width: layout.isMobile ? 48 : 56,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: const Icon(
        Icons.search_rounded,
        color: accentGreen,
        size: 28,
      ),
    );
  }

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Updates",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 20 : 26,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Find CropBio news, project activities, research notes, and announcements.",
          maxLines: layout.isMobile ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 12.5 : 14,
            fontWeight: FontWeight.w600,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _searchBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 4 : 6),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: UpdatesSearchBar(
        onChanged: context.read<UpdatesProvider>().updateQuery,
      ),
    );
  }
}

class _UpdatesGridPanel extends StatelessWidget {
  final LayoutProvider layout;

  const _UpdatesGridPanel({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 20 : 28),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(),
          SizedBox(height: layout.isMobile ? 20 : 32),

          /// Existing UpdatesGrid is preserved.
          /// Hover animation inside the grid/cards will still work.
          Selector<UpdatesProvider, String>(
            selector: (_, provider) => provider.query,
            builder: (_, query, __) {
              return RepaintBoundary(
                child: UpdatesGrid(
                  query: query,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader() {
    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionBadge(),
          const SizedBox(height: 12),
          _titleBlock(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _titleBlock(),
        ),
        const SizedBox(width: 20),
        _sectionBadge(),
      ],
    );
  }

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Latest Updates",
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            "Stay informed about CropBio fieldwork, data releases, research activities, capacity-building efforts, and project milestones.",
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 13.5 : 15,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.32),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.campaign_rounded,
            size: 17,
            color: accentGreen,
          ),
          const SizedBox(width: 8),
          Text(
            "News & Announcements",
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class HoverAnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HoverAnimatedCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<HoverAnimatedCard> createState() => _HoverAnimatedCardState();
}

class _HoverAnimatedCardState extends State<HoverAnimatedCard> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  @override
  Widget build(BuildContext context) {
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
          isHovered ? -8 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: isHovered ? darkSurface2 : darkSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered ? goldAccent.withOpacity(0.65) : darkBorder,
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 34 : 18,
              offset: Offset(0, isHovered ? 18 : 8),
              color: Colors.black.withOpacity(isHovered ? 0.38 : 0.24),
            ),
            if (isHovered)
              BoxShadow(
                blurRadius: 26,
                color: primaryGreen.withOpacity(0.22),
              ),
          ],
        ),
        child: AnimatedScale(
          scale: isHovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: widget.onTap,
              splashColor: primaryGreen.withOpacity(0.12),
              highlightColor: goldAccent.withOpacity(0.08),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}