import 'package:flutter/material.dart';

void main() {
  runApp(const CropBiodiversityApp());
}

class CropBiodiversityApp extends StatelessWidget {
  const CropBiodiversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Biodiversity',
      theme: ThemeData(
        fontFamily: 'Times New Roman',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B3C5D)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        bool isMobile = width < 600;
        bool isTablet = width >= 600 && width < 1024;
        bool isDesktop = width >= 1024 && width < 1600;
        bool isLargeDesktop = width >= 1600;

        double contentWidth = isLargeDesktop
            ? MediaQuery.of(context).size.width * 0.40
            : isDesktop
                ? 1250
                : double.infinity;

        double contentHeight = isLargeDesktop
            ? MediaQuery.of(context).size.height * 0.9
            : isDesktop
                ? 1250
                : double.infinity;

        /// ✅ Adjusted margins
        double outerMargin = isMobile
            ? 8
            : isTablet
                ? 12
                : isDesktop
                    ? 14
                    : 8; // smaller margin for large desktop+

        /// ✅ Adjusted padding slightly tighter on large screens
        double horizontalPadding = isMobile
            ? 12
            : isTablet
                ? 20
                : isDesktop
                    ? 22
                    : 20;

        double verticalPadding = isMobile ? 12 : 50;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 25, 99, 148),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B3C5D),
            elevation: 0,
            title: const Text(
              'Crop Biodiversity',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ResponsiveNavMenu(isMobile: isMobile),
            ],
          ),
          body: Center(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(outerMargin),
              child: Container(
                width: contentWidth,
                height: contentHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderBanner(),
                      const SizedBox(height: 16),
                      const HeadlineSection(),
                      const SizedBox(height: 20),
                      ResponsiveThreeColumnSection(width: width),
                      const SizedBox(height: 24),
                      ResponsiveTwoColumnSection(width: width),
                      const SizedBox(height: 24),
                      const LatestNewsSidebar(),
                      const SizedBox(height: 24),
                      const FooterSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ================= NAVIGATION ================= */

class ResponsiveNavMenu extends StatelessWidget {
  final bool isMobile;

  const ResponsiveNavMenu({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'About CropBio',
      'News',
      'Multimedia',
      'Biodiversity',
      'Data',
      'Publications',
      'Contact'
    ];

    if (isMobile) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (value) {},
        itemBuilder: (context) =>
            items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
      );
    }

    return Row(
      children: items
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

/* ================= HEADER ================= */

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        children: [
          Text(
            'Mariano Marcos State University (MMSU) • Crop Biodiversity Program',
            style: TextStyle(fontSize: 14, letterSpacing: 0.8),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'Integrating Earth Observation for Agricultural Biodiversity',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/* ================= HEADLINE ================= */

class HeadlineSection extends StatelessWidget {
  const HeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapping Philippine Crop Biodiversity from Space',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'By MMSU Crop Biodiversity Program',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          SizedBox(height: 12),
          Text(
            'MMSU integrates satellite imagery, drones, and field surveys to document and analyze crop biodiversity across the Philippines.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/* ================= THREE COLUMN ================= */

class ResponsiveThreeColumnSection extends StatelessWidget {
  final double width;

  const ResponsiveThreeColumnSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    if (width < 700) {
      return Column(
        children: const [
          ArticleCard(
            title: 'Indigenous Rice Diversity',
            body: 'Mapping traditional rice varieties for conservation.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Coconut & Agroforestry Systems',
            body: 'Analyzing mixed cropping systems.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Open Crop Data Portal',
            body: 'Public geospatial platform for crop diversity.',
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
            child: ArticleCard(
                title: 'Indigenous Rice Diversity',
                body: 'Mapping traditional rice varieties...')),
        SizedBox(width: 16),
        Expanded(
            child: ArticleCard(
                title: 'Coconut & Agroforestry Systems',
                body: 'Analyzing mixed cropping systems...')),
        SizedBox(width: 16),
        Expanded(
            child: ArticleCard(
                title: 'Open Crop Data Portal',
                body: 'Public geospatial platform...')),
      ],
    );
  }
}

/* ================= TWO COLUMN ================= */

class ResponsiveTwoColumnSection extends StatelessWidget {
  final double width;

  const ResponsiveTwoColumnSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    if (width < 800) {
      return Column(
        children: const [
          ArticleCard(
            title: 'Climate-Resilient Crop Varieties',
            body: 'Identifying resilient crops under stress.',
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: 'Why Crop Biodiversity Matters',
            body: 'Improves food security and soil health.',
          ),
        ],
      );
    }

    return Row(
      children: const [
        Expanded(
          flex: 2,
          child: ArticleCard(
            title: 'Climate-Resilient Crop Varieties',
            body: 'Identifying resilient crops under stress.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: ArticleCard(
            title: 'Why Crop Biodiversity Matters',
            body: 'Improves food security and soil health.',
          ),
        ),
      ],
    );
  }
}

/* ================= SIDEBAR ================= */

class LatestNewsSidebar extends StatelessWidget {
  const LatestNewsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest on Crop Biodiversity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• Satellite survey completed'),
          Text('• Community seed banks launched'),
          Text('• Drone missions expanded'),
          Text('• Climate risk dashboard released'),
        ],
      ),
    );
  }
}

/* ================= CARD ================= */

class ArticleCard extends StatelessWidget {
  final String title;
  final String body;

  const ArticleCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}

/* ================= FOOTER ================= */

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Text(
        '© 2026 MMSU • Crop Biodiversity Program • All rights reserved',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}
