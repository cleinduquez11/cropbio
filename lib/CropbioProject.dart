import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

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

  static const String imagePath = 'lib/Assets/cropbio_project';

  static const List<_ProjectFeature> features = [
    _ProjectFeature(
      title: 'Crop Diversity Monitoring',
      description:
          'Field protocols are used to document crop types, species, varieties, plot characteristics, and crop growth conditions.',
      icon: Icons.eco_rounded,
    ),
    _ProjectFeature(
      title: 'Earth Observation Integration',
      description:
          'Ground observations are designed to support remote sensing, UAV imagery, and geospatial monitoring of crop biodiversity.',
      icon: Icons.satellite_alt_rounded,
    ),
    _ProjectFeature(
      title: 'Field-to-Database Workflow',
      description:
          'CropBio combines in-situ observations, laboratory measurements, mobile apps, and structured databases for research access.',
      icon: Icons.dataset_rounded,
    ),
  ];

  static const List<_ProtocolCard> protocolCards = [
    _ProtocolCard(
      title: 'GVG App Sampling',
      category: 'Mobile field collection',
      description:
          'Use GVG to collect land cover, crop type, species, sampling point, photo, and cloud-backed field observations.',
      image: '$imagePath/cropbio_gvg_install.png',
      icon: Icons.phone_android_rounded,
    ),
    _ProtocolCard(
      title: 'FieldWatch Survey',
      category: 'Field boundary and yield support',
      description:
          'FieldWatch supports field boundary mapping, field-level data recording, and AI-assisted yield observations.',
      image: '$imagePath/cropbio_fieldwatch_install.png',
      icon: Icons.map_rounded,
    ),
    _ProtocolCard(
      title: 'Field Boundary Mapping',
      category: 'Plot and parcel documentation',
      description:
          'Field boundaries may be drawn manually or recorded by walking around the target field.',
      image: '$imagePath/cropbio_field_boundary.png',
      icon: Icons.polyline_rounded,
    ),
    _ProtocolCard(
      title: 'Plot Survey Sheet',
      category: 'Standardized field protocol',
      description:
          'Plot sheets organize GPS, crop, soil, LAI, canopy, irrigation, fertilizer, and environmental observations.',
      image: '$imagePath/cropbio_plot_survey_sheet.png',
      icon: Icons.assignment_rounded,
    ),
    _ProtocolCard(
      title: 'Spectral Measurements',
      category: 'Canopy and leaf spectra',
      description:
          'Spectroradiometer and leaf clip measurements support canopy spectra, leaf spectra, and crop trait analysis.',
      image: '$imagePath/cropbio_spectroradiometer.jpg',
      icon: Icons.area_chart_rounded,
    ),
    _ProtocolCard(
      title: 'LAI and Canopy Analysis',
      category: 'Morphological traits',
      description:
          'LAI, fractional vegetation cover, and canopy observations support crop growth and vegetation structure assessment.',
      image: '$imagePath/cropbio_lai_measurement.png',
      icon: Icons.grass_rounded,
    ),
    _ProtocolCard(
      title: 'CAN-EYE Processing',
      category: 'Image-based canopy retrieval',
      description:
          'CAN-EYE and hemispherical images help derive LAI, gap fraction, and canopy cover indicators.',
      image: '$imagePath/cropbio_caneye_analysis.png',
      icon: Icons.visibility_rounded,
    ),
    _ProtocolCard(
      title: 'Yield Sampling',
      category: 'Production validation',
      description:
          'Traditional harvest measurements and FieldWatch-based yield estimation support yield validation and calibration.',
      image: '$imagePath/cropbio_yield_sampling.png',
      icon: Icons.agriculture_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return AppShell(
      child: Container(
        color: darkBg,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _HeroSection(layout: layout),
            ),
            SliverToBoxAdapter(
              child: _ContentSection(
                layout: layout,
                child: _OverviewSection(layout: layout),
              ),
            ),
            SliverToBoxAdapter(
              child: _ContentSection(
                layout: layout,
                topPadding: 0,
                child: _ProtocolSection(layout: layout),
              ),
            ),
            SliverToBoxAdapter(
              child: _ContentSection(
                layout: layout,
                topPadding: 0,
                bottomPadding: layout.isMobile ? 56 : 86,
                child: _WorkflowSection(layout: layout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final LayoutProvider layout;

  const _HeroSection({
    required this.layout,
  });

  static const Color primaryGreen = ProjectPage.primaryGreen;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color goldAccent = ProjectPage.goldAccent;
  static const Color darkBg = ProjectPage.darkBg;
  static const Color darkSurface = ProjectPage.darkSurface;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: layout.isMobile ? 14 : 24,
        vertical: layout.isMobile ? 44 : 76,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1712),
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
            maxWidth: layout.contentWidth,
          ),
          child: layout.isMobile ? _mobileHero() : _desktopHero(),
        ),
      ),
    );
  }

  Widget _desktopHero() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _heroText(),
        ),
        const SizedBox(width: 34),
        Expanded(
          flex: 5,
          child: _heroImageCard(),
        ),
      ],
    );
  }

  Widget _mobileHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroText(),
        const SizedBox(height: 24),
        _heroImageCard(),
      ],
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelChip(
          icon: Icons.public_rounded,
          label: 'ESCAP × AIRCAS CropBio Initiative',
        ),
        const SizedBox(height: 18),
        Text(
          'Promoting crop and cropping diversity through innovative space applications',
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 34 : 56,
            fontWeight: FontWeight.w900,
            height: 1.03,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            'CropBio integrates in-situ field protocols, mobile data collection, laboratory measurements, UAV imagery, and Earth Observation to monitor crop biodiversity and strengthen food system resilience.',
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 15 : 17,
              fontWeight: FontWeight.w600,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _HeroStatChip(
              value: '200–500 ha',
              label: 'pilot site scale',
              icon: Icons.landscape_rounded,
            ),
            _HeroStatChip(
              value: 'Field–Air–Space',
              label: 'data integration',
              icon: Icons.satellite_alt_rounded,
            ),
            _HeroStatChip(
              value: 'SDG 2',
              label: 'zero hunger support',
              icon: Icons.flag_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroImageCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.86),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 34,
            offset: const Offset(0, 18),
            color: Colors.black.withOpacity(0.34),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: layout.isMobile ? 1.18 : 1.05,
              child: Image.asset(
                '${ProjectPage.imagePath}/cropbio_project_map.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImageFallback(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: darkSurface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: darkBorder),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: goldAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pilot countries include the Philippines, Indonesia, and Malaysia, with field protocols designed for replication across Asia-Pacific.',
                    style: GoogleFonts.nunito(
                      color: mutedText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.34),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: accentGreen),
          const SizedBox(width: 8),
          Text(
            label,
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

class _HeroStatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _HeroStatChip({
    required this.value,
    required this.label,
    required this.icon,
  });

  static const Color darkSurface = ProjectPage.darkSurface;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: darkBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentGreen, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final LayoutProvider layout;
  final Widget child;
  final double? topPadding;
  final double? bottomPadding;

  const _ContentSection({
    required this.layout,
    required this.child,
    this.topPadding,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        layout.isMobile ? 14 : 24,
        topPadding ?? (layout.isMobile ? 28 : 48),
        layout.isMobile ? 14 : 24,
        bottomPadding ?? (layout.isMobile ? 28 : 48),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  final LayoutProvider layout;

  const _OverviewSection({
    required this.layout,
  });

  static const Color darkSurface = ProjectPage.darkSurface;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color primaryGreen = ProjectPage.primaryGreen;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color goldAccent = ProjectPage.goldAccent;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(layout.isMobile ? 18 : 28),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.26),
          ),
        ],
      ),
      child: layout.isMobile ? _mobile() : _desktop(),
    );
  }

  Widget _desktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _textBlock()),
        const SizedBox(width: 28),
        Expanded(flex: 5, child: _featureGrid()),
      ],
    );
  }

  Widget _mobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textBlock(),
        const SizedBox(height: 22),
        _featureGrid(),
      ],
    );
  }

  Widget _textBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionBadge(
          icon: Icons.info_rounded,
          label: 'Project Overview',
        ),
        const SizedBox(height: 14),
        Text(
          'A field-to-space system for crop biodiversity evidence',
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile ? 25 : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'The project supports standardized in-situ measurement, monitoring, and assessment of crop and cropping diversity. It combines crop sampling, plot surveys, spectral measurements, physiological traits, morphological traits, UAV campaigns, and data management workflows.',
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: layout.isMobile ? 14 : 15.5,
            fontWeight: FontWeight.w600,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _SmallInfoChip(icon: Icons.eco_rounded, label: 'Crop diversity'),
            _SmallInfoChip(icon: Icons.analytics_rounded, label: 'In-situ data'),
            _SmallInfoChip(icon: Icons.flight_takeoff_rounded, label: 'UAV support'),
            _SmallInfoChip(icon: Icons.satellite_alt_rounded, label: 'Earth Observation'),
          ],
        ),
      ],
    );
  }

  Widget _featureGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 620;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ProjectPage.features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 1 : 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: compact ? 2.6 : 0.86,
          ),
          itemBuilder: (context, index) {
            final item = ProjectPage.features[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkSurface2,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: accentGreen, size: 26),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: lightText,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1.16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: compact ? 3 : 6,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: mutedText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.8,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ProtocolSection extends StatelessWidget {
  final LayoutProvider layout;

  const _ProtocolSection({
    required this.layout,
  });

  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          layout: layout,
          badge: 'In-situ Protocol Components',
          title: 'Field activities and measurements',
          description:
              'The project page below uses extracted visuals from the CropBio in-situ protocol to present the major survey workflows and measurement components.',
        ),
        SizedBox(height: layout.isMobile ? 18 : 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final int crossAxisCount;

            if (width < 720) {
              crossAxisCount = 1;
            } else if (width < 1080) {
              crossAxisCount = 2;
            } else {
              crossAxisCount = 4;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ProjectPage.protocolCards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 0.92 : 0.72,
              ),
              itemBuilder: (context, index) {
                return _ProtocolImageCard(
                  item: ProjectPage.protocolCards[index],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ProtocolImageCard extends StatelessWidget {
  final _ProtocolCard item;

  const _ProtocolImageCard({
    required this.item,
  });

  static const Color primaryGreen = ProjectPage.primaryGreen;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color goldAccent = ProjectPage.goldAccent;
  static const Color darkSurface = ProjectPage.darkSurface;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.23),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ImageFallback(),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.64),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: darkSurface.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: darkBorder),
                    ),
                    child: Icon(
                      item.icon,
                      color: goldAccent,
                      size: 22,
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Text(
                    item.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: goldAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: lightText,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: accentGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'View protocol details',
                        style: GoogleFonts.nunito(
                          color: accentGreen,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowSection extends StatelessWidget {
  final LayoutProvider layout;

  const _WorkflowSection({
    required this.layout,
  });

  static const Color darkSurface = ProjectPage.darkSurface;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color goldAccent = ProjectPage.goldAccent;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  static const List<_WorkflowStep> steps = [
    _WorkflowStep(
      number: '01',
      title: 'Select pilot sites',
      description:
          'Choose suitable cropland areas based on crop diversity, data availability, policy relevance, and development benefits.',
      icon: Icons.place_rounded,
    ),
    _WorkflowStep(
      number: '02',
      title: 'Collect field data',
      description:
          'Use GVG, FieldWatch, plot sheets, and field instruments to collect crop, plot, trait, and environmental data.',
      icon: Icons.edit_location_alt_rounded,
    ),
    _WorkflowStep(
      number: '03',
      title: 'Measure traits',
      description:
          'Measure spectral, physiological, morphological, and agronomic parameters such as SPAD, LAI, FVC, biomass, and yield.',
      icon: Icons.science_rounded,
    ),
    _WorkflowStep(
      number: '04',
      title: 'Integrate and analyze',
      description:
          'Combine in-situ data with UAV and satellite observations to generate geospatial evidence for crop biodiversity.',
      icon: Icons.hub_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(layout.isMobile ? 18 : 30),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 22 : 30),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.26),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            layout: layout,
            badge: 'Implementation Workflow',
            title: 'From sampling points to evidence products',
            description:
                'The workflow connects pilot-site preparation, field measurements, database creation, and geospatial analysis.',
            compact: true,
          ),
          SizedBox(height: layout.isMobile ? 18 : 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool compact = constraints.maxWidth < 760;

              if (compact) {
                return Column(
                  children: steps
                      .map(
                        (step) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WorkflowCard(step: step),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps
                    .map(
                      (step) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _WorkflowCard(step: step),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  final _WorkflowStep step;

  const _WorkflowCard({
    required this.step,
  });

  static const Color primaryGreen = ProjectPage.primaryGreen;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color goldAccent = ProjectPage.goldAccent;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 190),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.30),
                  ),
                ),
                child: Icon(step.icon, color: goldAccent, size: 22),
              ),
              const Spacer(),
              Text(
                step.number,
                style: GoogleFonts.nunito(
                  color: accentGreen.withOpacity(0.55),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final LayoutProvider layout;
  final String badge;
  final String title;
  final String description;
  final bool compact;

  const _SectionHeader({
    required this.layout,
    required this.badge,
    required this.title,
    required this.description,
    this.compact = false,
  });

  static const Color lightText = ProjectPage.lightText;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          layout.isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.start,
      children: [
        _SectionBadge(
          icon: Icons.layers_rounded,
          label: badge,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: layout.isMobile
                ? 25
                : compact
                    ? 30
                    : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Text(
            description,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: layout.isMobile ? 14 : 15.5,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionBadge({
    required this.icon,
    required this.label,
  });

  static const Color primaryGreen = ProjectPage.primaryGreen;
  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color lightText = ProjectPage.lightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accentGreen),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SmallInfoChip({
    required this.icon,
    required this.label,
  });

  static const Color accentGreen = ProjectPage.accentGreen;
  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color lightText = ProjectPage.lightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: darkBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accentGreen),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w800,
              fontSize: 12.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  static const Color darkSurface2 = ProjectPage.darkSurface2;
  static const Color darkBorder = ProjectPage.darkBorder;
  static const Color mutedText = ProjectPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkSurface2,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: darkBorder),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          'Image asset not found',
          style: GoogleFonts.nunito(
            color: mutedText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProjectFeature {
  final String title;
  final String description;
  final IconData icon;

  const _ProjectFeature({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _ProtocolCard {
  final String title;
  final String category;
  final String description;
  final String image;
  final IconData icon;

  const _ProtocolCard({
    required this.title,
    required this.category,
    required this.description,
    required this.image,
    required this.icon,
  });
}

class _WorkflowStep {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _WorkflowStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}
