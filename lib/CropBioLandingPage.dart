import 'package:cropbio/Pherips/Appbar.dart';
import 'package:cropbio/Pherips/Footer.dart';
import 'package:cropbio/Pherips/Header.dart';
import 'package:cropbio/Pherips/Headline.dart';
import 'package:cropbio/Pherips/LandingCarousel.dart';
import 'package:cropbio/Pherips/LandingCarouselVid.dart';
import 'package:cropbio/Pherips/LatestNews.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/ThreeColumnGrid.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Pherips/TwoColumnGrid.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(
          children: [
            ResponsiveTitleBar(title: "Crop Biodiversity"),
            ResponsiveNavBar(),

            // SizedBox(height: layout.verticalPadding), // vertical spacing
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LandingVideo(videoPath: 'lib/Assets/biodiversity.mp4'),
                    Center(
                      child: Card(
                        elevation: 3,
                        margin: EdgeInsets.all(layout.outerMargin),
                        child: Container(
                          width: layout.contentWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: layout.horizontalPadding,
                            vertical: layout.verticalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeaderBanner(),
                              const SizedBox(height: 16),
                              const HeadlineSection(),
                              const SizedBox(height: 20),
                              ResponsiveThreeColumnSection(
                                  width: layout.screenWidth),
                              const SizedBox(height: 24),
                              ResponsiveTwoColumnSection(
                                  width: layout.screenWidth),
                              const SizedBox(height: 24),
                              const LatestNewsSidebar(),
                              const SizedBox(height: 24),
                              const FooterSection(),
                            ],
                          ),
                        ),
                      ),
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
