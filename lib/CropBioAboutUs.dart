import 'package:cropbio/AboutUsPage/Sections/AboutCTA.dart';
import 'package:cropbio/AboutUsPage/Sections/AboutHero.dart';
import 'package:cropbio/AboutUsPage/Sections/AboutMissionVision.dart';
import 'package:cropbio/AboutUsPage/Sections/Organization.dart';
import 'package:cropbio/AboutUsPage/Sections/Strengths.dart';
import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutProvider>();

    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= HERO =================
          const SliverToBoxAdapter(
            child: AboutHero(),
          ),
      
          /// ================= MISSION / VISION =================
          SliverToBoxAdapter(
            child: Container(
                 color: Colors.black,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: layout.verticalPadding * 2,
                  horizontal: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: layout.contentWidth,
                    ),
                    child: const MissionVisionSection(),
                  ),
                ),
              ),
            ),
          ),
      
          /// ================= ORGANIZATION =================
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 2,
                horizontal: 20,
              ),
              color: const Color(0xFFF4F6F1),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: const OrganizationSection(),
                ),
              ),
            ),
          ),
      
          /// ================= STRENGTHS =================
          SliverToBoxAdapter(
      
      
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: layout.verticalPadding * 2,
                  horizontal: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      
                      maxWidth: layout.contentWidth,
                    ),
                    child:  StrengthSection(),
                  ),
                ),
              ),
            ),
          ),
      
          /// ================= CTA =================
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2F4F2F),
                    Color(0xFF1E2E1E),
                  ],
                ),
              ),
              child: const AboutCTA(),
            ),
          ),
        ],
      ),
    );
  }
}






