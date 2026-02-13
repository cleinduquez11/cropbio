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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 99, 148), // light brownish background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3C5D),
        elevation: 0,
        title: const Text('Crop Biodiversity', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
        centerTitle: false,
        actions: const [
          NavMenu(),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(16),
          child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HeaderBanner(),
                SizedBox(height: 16),
                HeadlineSection(),
                SizedBox(height: 20),
                ThreeColumnSection(),
                SizedBox(height: 24),
                TwoColumnSection(),
                SizedBox(height: 24),
                LatestNewsSidebar(),
                SizedBox(height: 24),
                FooterSection(),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'Home', 'About', 'Programs', 'Biodiversity', 'Data', 'News', 'Contact'
    ];

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
      child: Column(
        children: const [
          Text(
            'Mariano Marcos State University (MMSU) • Crop Biodiversity Program',
            style: TextStyle(fontSize: 14, letterSpacing: 0.8),
          ),
          SizedBox(height: 4),
          Text(
            'Integrating Earth Observation for Agricultural Biodiversity',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
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
            'MMSU is integrating satellite imagery, drones, and field-based surveys to document and analyze crop biodiversity across the Philippines. The initiative supports conservation of traditional varieties, climate resilience, and evidence-based agricultural planning.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class ThreeColumnSection extends StatelessWidget {
  const ThreeColumnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(child: ArticleCard(
          title: 'Indigenous Rice Diversity',
          body: 'Mapping traditional rice varieties such as heirloom and upland types to support seed banks and farmer-led conservation.',
        )),
        SizedBox(width: 16),
        Expanded(child: ArticleCard(
          title: 'Coconut & Agroforestry Systems',
          body: 'Analyzing mixed cropping systems where coconut coexists with bananas, root crops, and legumes to enhance biodiversity.',
        )),
        SizedBox(width: 16),
        Expanded(child: ArticleCard(
          title: 'Open Crop Data Portal',
          body: 'A public geospatial platform providing maps of crop diversity, hotspots, and climate vulnerability indicators.',
        )),
      ],
    );
  }
}

class TwoColumnSection extends StatelessWidget {
  const TwoColumnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 2, child: ArticleCard(
          title: 'Climate-Resilient Crop Varieties',
          body: 'Satellite-derived climate stress maps help identify which traditional crops perform best under drought, flooding, and heat.',
        )),
        SizedBox(width: 16),
        Expanded(flex: 1, child: ArticleCard(
          title: 'Why Crop Biodiversity Matters',
          body: 'Diverse crops reduce pest risk, improve soil health, and safeguard food security in a changing climate.',
        )),
      ],
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Latest on Crop Biodiversity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('• Satellite survey of Mindanao rice lands completed'),
          Text('• Community seed banks launched in Ifugao'),
          Text('• New drone missions for agroforestry mapping'),
          Text('• Climate risk dashboard released for farmers'),
        ],
      ),
    );
  }
}

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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

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
