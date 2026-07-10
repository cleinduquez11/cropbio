import 'package:cropbio/AppShell.dart';
import 'package:cropbio/DataPage/Sections/DataHero.dart';
import 'package:cropbio/DataPage/Sections/DataTypeGrid.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
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
              child: DataHero(),
            ),

            /// ================= DATA TYPE SECTION =================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: layout.isMobile
                      ? layout.verticalPadding
                      : layout.verticalPadding * 1.6,
                  horizontal: layout.isMobile ? 14 : 24,
                ),
                decoration: const BoxDecoration(
                  color: darkBg,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: _DataTypeSection(layout: layout),
                  ),
                ),
              ),
            ),

            /// ================= INFO STRIP =================
            SliverToBoxAdapter(
              child: _DataTransparencySection(layout: layout),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataTypeSection extends StatelessWidget {
  final LayoutProvider layout;

  const _DataTypeSection({
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
          const DataTypeGrid(),
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
          "Select Data Type",
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 24 : 30,
            fontWeight: FontWeight.w900,
            color: lightText,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            "Choose the type of dataset you want to explore, preview, filter, and download for research, GIS, analytics, and reporting use.",
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
            Icons.dataset_rounded,
            size: 17,
            color: accentGreen,
          ),
          const SizedBox(width: 8),
          Text(
            "CropBio Data Library",
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

class _DataTransparencySection extends StatelessWidget {
  final LayoutProvider layout;

  const _DataTransparencySection({
    required this.layout,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 56 : 86,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF111C14),
            Color(0xFF162216),
            Color(0xFF0F1712),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.isMobile ? layout.contentWidth : 980,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(layout.isMobile ? 20 : 34),
            decoration: BoxDecoration(
              color: darkSurface.withOpacity(0.92),
              borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
              border: Border.all(
                color: darkBorder,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                  color: Colors.black.withOpacity(0.30),
                ),
              ],
            ),
            child: layout.isMobile ? _mobileContent() : _desktopContent(),
          ),
        ),
      ),
    );
  }

  Widget _desktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconCard(),
        const SizedBox(width: 28),
        Expanded(
          child: _textContent(
            alignCenter: false,
          ),
        ),
      ],
    );
  }

  Widget _mobileContent() {
    return Column(
      children: [
        _iconCard(),
        const SizedBox(height: 20),
        _textContent(
          alignCenter: true,
        ),
      ],
    );
  }

  Widget _iconCard() {
    return Container(
      height: layout.isMobile ? 70 : 82,
      width: layout.isMobile ? 70 : 82,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: const Icon(
        Icons.verified_rounded,
        color: goldAccent,
        size: 42,
      ),
    );
  }

  Widget _textContent({
    required bool alignCenter,
  }) {
    return Column(
      crossAxisAlignment:
          alignCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Data Transparency & Research Access",
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.nunito(
            fontSize: layout.isMobile ? 25 : 34,
            fontWeight: FontWeight.w900,
            color: lightText,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "All datasets are curated from validated field research, remote sensing analysis, and institutional studies. Downloadable formats are optimized for GIS, analytics, academic use, and responsible decision support.",
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.nunito(
            color: mutedText,
            height: 1.65,
            fontSize: layout.isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: alignCenter ? WrapAlignment.center : WrapAlignment.start,
          children: const [
            _InfoChip(
              icon: Icons.science_rounded,
              label: "Validated Research",
            ),
            _InfoChip(
              icon: Icons.map_rounded,
              label: "GIS-ready",
            ),
            _InfoChip(
              icon: Icons.download_rounded,
              label: "Downloadable",
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: accentGreen,
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class DataListPage extends StatelessWidget {
  final String type;

  const DataListPage({
    super.key,
    required this.type,
  });

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

    final mockData = [
      "Dataset A",
      "Dataset B",
      "Dataset C",
    ];

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: lightText,
        ),
        title: Text(
          "Available $type Data",
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(layout.isMobile ? 14 : 24),
            itemCount: mockData.length,
            itemBuilder: (context, index) {
              return _DatasetCard(
                title: mockData[index],
                subtitle: "Description of dataset",
                onDownload: () {
                  /// TODO: download logic
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DatasetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDownload;

  const _DatasetCard({
    required this.title,
    required this.subtitle,
    required this.onDownload,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(layout.isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.22),
          ),
        ],
      ),
      child: layout.isMobile ? _mobileLayout() : _desktopLayout(),
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        _iconBox(),
        const SizedBox(width: 16),
        Expanded(
          child: _textBlock(),
        ),
        const SizedBox(width: 16),
        _downloadButton(),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _iconBox(),
            const SizedBox(width: 12),
            Expanded(
              child: _textBlock(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: _downloadButton(),
        ),
      ],
    );
  }

  Widget _iconBox() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryGreen.withOpacity(0.32),
        ),
      ),
      child: const Icon(
        Icons.table_chart_rounded,
        color: goldAccent,
      ),
    );
  }

  Widget _textBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _downloadButton() {
    return ElevatedButton.icon(
      onPressed: onDownload,
      icon: const Icon(
        Icons.download_rounded,
        color: Colors.black,
        size: 18,
      ),
      label: Text(
        "Download",
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: goldAccent,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}