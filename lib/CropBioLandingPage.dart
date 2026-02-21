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
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        // backgroundColor: const COLO,
        body: Column(
          children: [
            ResponsiveTitleBar(title: "Crop Biodiversity"),
            ResponsiveNavBar(),

            // SizedBox(height: layout.verticalPadding), // vertical spacing
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollReveal(
                        delay: const Duration(milliseconds: 200),
                        child: LandingVideo(
                            videoPath: 'lib/Assets/biodiversity.mp4')),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    // ================= IMPACT STATS SECTION =================
                    ScrollReveal(
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: layout.verticalPadding * 2,
                        ),
                        color: const Color(0xFFF4F6F1),
                        child: Center(
                          child: SizedBox(
                            width: layout.contentWidth,
                            child: layout.isMobile
                                ? Column(
                                    children: const [
                                      _StatCard(
                                          number: 120,
                                          suffix: "+",
                                          label: "Crop Accessions"),
                                      SizedBox(height: 20),
                                      _StatCard(
                                          number: 35,
                                          suffix: "+",
                                          label: "Research Projects"),
                                      SizedBox(height: 20),
                                      _StatCard(
                                          number: 15,
                                          suffix: "",
                                          label: "Partner Institutions"),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      _StatCard(
                                          number: 120,
                                          suffix: "+",
                                          label: "Crop Accessions"),
                                      SizedBox(height: 20),
                                      _StatCard(
                                          number: 35,
                                          suffix: "+",
                                          label: "Research Projects"),
                                      SizedBox(height: 20),
                                      _StatCard(
                                          number: 15,
                                          suffix: "",
                                          label: "Partner Institutions"),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
// ================= VISION SECTION =================
                    ScrollReveal(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: layout.verticalPadding * 2,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: layout.contentWidth,
                            child: layout.isMobile
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      _VisionText(),
                                      SizedBox(height: 30),
                                      _VisionImage(),
                                    ],
                                  )
                                : Row(
                                    children: const [
                                      Expanded(child: _VisionText()),
                                      SizedBox(width: 40),
                                      Expanded(child: _VisionImage()),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

// ================= RESEARCH HIGHLIGHTS =================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: layout.verticalPadding * 2),
                      color: const Color(0xFFF8F9F6),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Research Focus Areas",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 40),
                              _ResearchGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),

// ================= CTA SECTION =================
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.symmetric(vertical: 80),
                    //   decoration: const BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Color(0xFF2F4F2F),
                    //         Color(0xFF1E2E1E),
                    //       ],
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       const Text(
                    //         "Join the Future of Crop Research",
                    //         style: TextStyle(
                    //           fontSize: 36,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 20),
                    //       ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: Color(0xFFC6A432),
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 40, vertical: 18),
                    //         ),
                    //         onPressed: () {},
                    //         child: const Text(
                    //           "Get Started",
                    //           style: TextStyle(color: Colors.black),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 100, horizontal: 20),
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
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            children: [
                              const Text(
                                "Join the Future of Crop Biodiversity",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Subscribe to receive updates on research, publications, and biodiversity initiatives.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 40),
                              const _SignupForm(),
                            ],
                          ),
                        ),
                      ),
                    ),

// ================= PARTNERS =================
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          const Text(
                            "In Collaboration With",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Wrap(
                            spacing: 60,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: const [
                              _PartnerLogo(name: "MMSU"),
                              _PartnerLogo(name: "DA"),
                              _PartnerLogo(name: "CHED"),
                            ],
                          ),
                        ],
                      ),
                    ),
// ================= FOOTER =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      color: const Color(0xFF1E2E1E),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: layout.isMobile
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FooterBrand(),
                                    SizedBox(height: 30),
                                    _FooterLinks(),
                                  ],
                                )
                              : const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _FooterBrand(),
                                    _FooterLinks(),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Card(
                    //     elevation: 3,
                    //     margin: EdgeInsets.all(layout.outerMargin),
                    //     child: Container(
                    //       width: layout.contentWidth,
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: layout.horizontalPadding,
                    //         vertical: layout.verticalPadding,
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const HeaderBanner(),
                    //           const SizedBox(height: 16),
                    //           const HeadlineSection(),
                    //           const SizedBox(height: 20),
                    //           ResponsiveThreeColumnSection(
                    //               width: layout.screenWidth),
                    //           const SizedBox(height: 24),
                    //           ResponsiveTwoColumnSection(
                    //               width: layout.screenWidth),
                    //           const SizedBox(height: 24),
                    //           const LatestNewsSidebar(),
                    //           const SizedBox(height: 24),
                    //           const FooterSection(),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CropBio",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Mariano Marcos State University\nBatac, Ilocos Norte",
          style: TextStyle(
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Links",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _footerLink("About Us"),
        _footerLink("Research"),
        _footerLink("Publications"),
        _footerLink("Contact"),
      ],
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),
    );
  }
}

class _PartnerLogo extends StatelessWidget {
  final String name;

  const _PartnerLogo({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ResearchGrid extends StatelessWidget {
  const _ResearchGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      children: const [
        _ResearchCard(
          title: "Genetic Conservation",
          description:
              "Preserving native crop varieties and traditional cultivars.",
        ),
        _ResearchCard(
          title: "Climate Resilience",
          description:
              "Developing adaptive crop systems for changing environments.",
        ),
        _ResearchCard(
          title: "Sustainable Farming",
          description:
              "Supporting low-impact and high-yield agricultural systems.",
        ),
      ],
    );
  }
}

class _ResearchCard extends StatelessWidget {
  final String title;
  final String description;

  const _ResearchCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.eco, color: Color(0xFF3F6B2A), size: 40),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              height: 1.6,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionText extends StatelessWidget {
  const _VisionText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Mission",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "CropBio is dedicated to preserving genetic diversity, "
          "supporting research innovation, and empowering sustainable "
          "agriculture in the Philippines.",
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _VisionImage extends StatelessWidget {
  const _VisionImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(
        "lib/Assets/Cropbio_Logo_Dark.svg",
        fit: BoxFit.cover,
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final int number;
  final String suffix;
  final String label;

  const _StatCard({
    required this.number,
    required this.suffix,
    required this.label,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = IntTween(begin: 0, end: widget.number).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Column(
          children: [
            Text(
              "${_animation.value}${widget.suffix}",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F6B2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(color: Colors.black),
            ),
          ],
        );
      },
    );
  }
}

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _offset = Tween(begin: 40.0, end: 0.0).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _offset.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  bool _hover = false;
  bool _submitted = false;

  void _submit() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _submitted = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _submitted = false;
          _emailController.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _submitted
              ? const Text(
                  "Thank you for subscribing!",
                  key: ValueKey("success"),
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Row(
                  key: const ValueKey("form"),
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Enter your email address",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    MouseRegion(
                      onEnter: (_) => setState(() => _hover = true),
                      onExit: (_) => setState(() => _hover = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        transform: _hover
                            ? (Matrix4.identity()..translate(0, -5))
                            : Matrix4.identity(),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC6A432),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            "Subscribe",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 25),
        TextButton(
          onPressed: () {
            // You can link to contact page here
          },
          child: const Text(
            "Or Email Us Directly",
            style: TextStyle(
              color: Colors.white70,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
