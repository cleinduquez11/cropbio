// ignore: file_names
import 'package:cropbio/AppShell.dart';
import 'package:cropbio/LandingPage/Sections/CTASection.dart';
import 'package:cropbio/LandingPage/Sections/PartnersSection.dart';
import 'package:cropbio/LandingPage/Sections/RASection.dart';
import 'package:cropbio/LandingPage/Sections/RFASection.dart';
import 'package:cropbio/LandingPage/Sections/StatSection.dart';
import 'package:cropbio/LandingPage/Widgets/Vision.dart';
import 'package:cropbio/Pherips/Footer.dart';
import 'package:cropbio/Pherips/LandingCarouselVid.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPagetest extends StatelessWidget {
  const LandingPagetest({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
        ),
        slivers: [
          /// HERO VIDEO
          SliverToBoxAdapter(
            child: RepaintBoundary(
              child: const LandingVideo(
                videoPath: 'lib/Assets/final.mp4',
              ),
            ),
          ),
      
          /// DIVIDER
          SliverToBoxAdapter(
            child: Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey.withValues(alpha: 0.15),
            ),
          ),
      
          /// STATS
          SliverToBoxAdapter(
            child: RepaintBoundary(
              child: StatsSection(),
            ),
          ),
      
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 1.5,
                horizontal: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        1200, // 👈 IMPORTANT FIX (or increase layout.contentWidth)
                  ),
                  child: layout.isMobile
                      ? const Column(
                          children: [
                            VisionText(),
                            SizedBox(height: 40),
                            VisionImage(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Expanded(flex: 5, child: VisionText()),
                            SizedBox(width: 60),
                            Expanded(flex: 4, child: VisionImage()),
                          ],
                        ),
                ),
              ),
            ),
          ),
      
          /// RESEARCH SECTION
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 2,
                horizontal: 20,
              ),
              color: const Color(0xFFF8F9F6),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth + 10,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Research Focus Areas",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F6B2A),
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Exploring sustainable agricultural innovation through biodiversity, resilience, and conservation research.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 40),
                      ResearchGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      
          /// ANALYTICS
          SliverToBoxAdapter(
            child: Selector<LayoutProvider,
                ({double verticalPadding, double contentWidth})>(
              selector: (_, p) => (
                verticalPadding: p.verticalPadding,
                contentWidth: p.contentWidth,
              ),
              builder: (_, layout, __) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: layout.verticalPadding * 2,
                    horizontal: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: layout.contentWidth,
                      ),
                      child:  RepaintBoundary(
                        child: ResearchAnalyticsSection(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      
          /// CTA SECTION
          const SliverToBoxAdapter(
            child: CTASection(),
          ),
      
          /// PARTNERS
          const SliverToBoxAdapter(
            child: RepaintBoundary(
              child: PartnersSection(),
            ),
          ),
      
          /// FOOTER
          SliverToBoxAdapter(
            child: RepaintBoundary(
              child: Container(
                width: double.infinity,
                color: Color(0xFF1E2E1E),
                child: FooterSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
