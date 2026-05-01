


import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        body: Column(
          children: [
            ResponsiveTitleBar(title: "About CropBio"),
            ResponsiveNavBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// ================= HERO =================
                    const _AboutHero(),

                    /// ================= MISSION / VISION =================
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: const _MissionVisionSection(),
                        ),
                      ),
                    ),

                    /// ================= ORGANIZATION =================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      color: const Color(0xFFF4F6F1),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: const _OrganizationSection(),
                        ),
                      ),
                    ),

                    /// ================= STRENGTHS =================
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: _StrengthSection(),
                        ),
                      ),
                    ),

                    /// ================= CTA =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 90, horizontal: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2F4F2F),
                            Color(0xFF1E2E1E),
                          ],
                        ),
                      ),
                      child: const _AboutCTA(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F4F2F),
            Color(0xFF1E2E1E),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            children: [
              SizedBox(
                height: 90,
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_Logo_Dark.svg",
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "About CropBio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "A research-driven platform dedicated to preserving crop biodiversity, "
                "advancing agricultural science, and enabling data-driven decision-making "
                "for sustainable farming systems in the Philippines.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.7,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _MissionVisionSection extends StatelessWidget {
  const _MissionVisionSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return isMobile
            ? Column(
                children: const [
                  _InfoBlock(
                    title: "Our Mission",
                    text:
                        "To collect, manage, and disseminate high-quality crop biodiversity data "
                        "that supports scientific research, conservation, and sustainable agriculture.",
                  ),
                  SizedBox(height: 30),
                  _InfoBlock(
                    title: "Our Vision",
                    text:
                        "To become a leading digital platform for agricultural biodiversity "
                        "research and innovation in Southeast Asia.",
                  ),
                ],
              )
            : const Row(
                children: [
                  Expanded(
                    child: _InfoBlock(
                      title: "Our Mission",
                      text:
                          "To collect, manage, and disseminate high-quality crop biodiversity data "
                          "that supports scientific research, conservation, and sustainable agriculture.",
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: _InfoBlock(
                      title: "Our Vision",
                      text:
                          "To become a leading digital platform for agricultural biodiversity "
                          "research and innovation in Southeast Asia.",
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String text;

  const _InfoBlock({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              height: 1.7,
              color: Colors.white54 ,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganizationSection extends StatelessWidget {
  const _OrganizationSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Who We Are",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        SizedBox(height: 20),
        Text(
          "CropBio is developed and maintained through collaborative efforts between "
          "academic institutions, agricultural researchers, and technology developers. "
          "We integrate geospatial technologies, field research, and data science "
          "to build a comprehensive biodiversity monitoring system.",
          style: TextStyle(height: 1.7, color: Colors.black87),
        ),
      ],
    );
  }
}

class _StrengthSection extends StatelessWidget {
  const _StrengthSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ================= TITLE =================
        const Text(
          "What We Do",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Core strengths that drive CropBio’s research, innovation, and impact in agricultural biodiversity.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white54,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 30),

        /// ================= GRID =================
        const _StrengthGrid(),
      ],
    );
  }
}

class _StrengthGrid extends StatelessWidget {
  const _StrengthGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _Strength("Data-Driven Research", Icons.analytics),
      _Strength("GIS Integration", Icons.map),
      _Strength("Drone Mapping", Icons.flight),
      _Strength("Sustainable Agriculture", Icons.eco),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int cols = constraints.maxWidth > 1000
            ? 4
            : constraints.maxWidth > 700
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, i) {
            return _StrengthCard(item: items[i]);
          },
        );
      },
    );
  }
}

class _Strength {
  final String title;
  final IconData icon;

  _Strength(this.title, this.icon);
}

class _StrengthCard extends StatelessWidget {
  final _Strength item;

  const _StrengthCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon,
              size: 40, color: const Color(0xFF3F6B2A)),
          const SizedBox(height: 15),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCTA extends StatelessWidget {
  const _AboutCTA();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Join Our Research Network",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Collaborate with us in advancing crop biodiversity and agricultural innovation.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6A432),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 18,
            ),
          ),
          onPressed: () {},
          child: const Text("Contact Us"),
        )
      ],
    );
  }
}