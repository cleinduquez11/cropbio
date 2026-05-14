import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';

import 'package:cropbio/ServicesPage/Sections/ServicesProcess.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'ServicesPage/Sections/ServicesCTA.dart';
import 'ServicesPage/Sections/ServicesGrid.dart';
import 'ServicesPage/Sections/ServicesHero.dart';


class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutProvider>();

    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= HERO =================
          SliverToBoxAdapter(
            child: ServicesHero(),
          ),
      
          /// ================= SERVICES GRID =================
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 2,
              ),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Capabilities",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Comprehensive solutions for crop research, geospatial analysis, and biodiversity monitoring.",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 40),
                      ServicesGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      
          /// ================= PROCESS =================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 2,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: const ServiceProcess(),
                ),
              ),
            ),
          ),
      
          /// ================= CTA =================
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 100,
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2F4F2F),
                    Color(0xFF1E2E1E),
                  ],
                ),
              ),
              child: const ServiceCTA(),
            ),
          ),
        ],
      ),
    );
  }
}




