import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LandingVideo extends StatefulWidget {
  final String videoPath;

  const LandingVideo({
    super.key,
    required this.videoPath,
  });

  @override
  State<LandingVideo> createState() => _LandingVideoState();
}

class _LandingVideoState extends State<LandingVideo>
    with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController _controller;

  bool isReady = false;
  bool hasError = false;
  bool isButtonHovered = false;
  bool isVideoHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFD6E0D1);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      widget.videoPath,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0);

      if (!mounted) return;

      setState(() {
        isReady = true;
        hasError = false;
      });

      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted && _controller.value.isInitialized) {
          _controller.play();
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        hasError = true;
        isReady = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _responsiveHeight(LayoutProvider layout) {
    if (layout.isMobile) return 420;
    if (layout.isTablet) return 500;
    if (layout.isDesktop) return 600;
    return 660;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final layout = context.watch<LayoutProvider>();
    final videoHeight = _responsiveHeight(layout);

    return RepaintBoundary(
      child: SizedBox(
        height: videoHeight,
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: hasError
              ? _buildFallbackHero(layout)
              : isReady
                  ? _buildVideo(layout)
                  : _buildSkeleton(layout, videoHeight),
        ),
      ),
    );
  }

  Widget _buildSkeleton(LayoutProvider layout, double height) {
    return Container(
      key: const ValueKey("video-skeleton"),
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1712),
            Color(0xFF162216),
            Color(0xFF1E2E1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -40,
            child: _glowCircle(
              size: layout.isMobile ? 160 : 240,
              color: primaryGreen.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: _glowCircle(
              size: layout.isMobile ? 150 : 220,
              color: goldAccent.withOpacity(0.10),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: goldAccent,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Loading CropBio Experience",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: mutedText,
                    letterSpacing: 0.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackHero(LayoutProvider layout) {
    return Container(
      key: const ValueKey("fallback-hero"),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1712),
            Color(0xFF162216),
            Color(0xFF1E2E1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: _heroContent(layout),
    );
  }

  Widget _buildVideo(LayoutProvider layout) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isVideoHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isVideoHovered = false;
        });
      },
      child: SizedBox(
        key: const ValueKey("video"),
        height: double.infinity,
        width: double.infinity,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// ================= VIDEO =================
              AnimatedScale(
                scale: isVideoHovered ? 1.025 : 1.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),

              /// ================= DARK OVERLAY =================
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.30),
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.76),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              /// ================= GREEN SIDE GLOW =================
              Positioned(
                top: -90,
                right: -60,
                child: _glowCircle(
                  size: layout.isMobile ? 170 : 280,
                  color: primaryGreen.withOpacity(0.20),
                ),
              ),
              Positioned(
                bottom: -90,
                left: -60,
                child: _glowCircle(
                  size: layout.isMobile ? 160 : 250,
                  color: goldAccent.withOpacity(0.13),
                ),
              ),

              /// ================= CONTENT =================
              _heroContent(layout),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroContent(LayoutProvider layout) {
    return Positioned.fill(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: layout.isMobile ? 18 : 28,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 980,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _locationBadge(layout),
                SizedBox(height: layout.isMobile ? 18 : 22),

                Text(
                  "Crop Biodiversity",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: layout.isMobile ? 42 : 78,
                    fontWeight: FontWeight.w800,
                    color: lightText,
                    height: 1.02,
                    letterSpacing: -0.8,
                  ),
                ),

                SizedBox(height: layout.isMobile ? 16 : 20),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Text(
                    "Promoting crop and cropping diversity through innovative space applications, in-situ field protocols, UAV mapping, GVG sampling, FieldWatch boundary surveys, and geospatial analytics.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: layout.isMobile ? 15 : 18,
                      height: 1.7,
                      color: mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: layout.isMobile ? 22 : 30),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeroChip(
                      icon: Icons.satellite_alt_rounded,
                      label: "Earth Observation",
                    ),
                    _HeroChip(
                      icon: Icons.flight_takeoff_rounded,
                      label: "UAV Mapping",
                    ),
                    _HeroChip(
                      icon: Icons.edit_location_alt_rounded,
                      label: "GVG Sampling",
                    ),
                    _HeroChip(
                      icon: Icons.map_rounded,
                      label: "FieldWatch",
                    ),
                  ],
                ),

                SizedBox(height: layout.isMobile ? 28 : 38),

                _ctaButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationBadge(LayoutProvider layout) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.isMobile ? 13 : 16,
        vertical: layout.isMobile ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "MMSU • City of Batac • Ilocos Norte",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: layout.isMobile ? 12.5 : 14,
                letterSpacing: 0.4,
                color: lightText,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isButtonHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isButtonHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isButtonHovered ? -5 : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              blurRadius: isButtonHovered ? 26 : 14,
              offset: Offset(0, isButtonHovered ? 14 : 7),
              color: goldAccent.withOpacity(isButtonHovered ? 0.28 : 0.12),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isButtonHovered ? goldAccent : primaryGreen,
            foregroundColor: isButtonHovered ? Colors.black : lightText,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(
                color: isButtonHovered ? goldAccent : Colors.white24,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/data");
          },
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: isButtonHovered ? Colors.black : lightText,
            size: 20,
          ),
          label: Text(
            "Explore CropBio Data",
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: isButtonHovered ? Colors.black : lightText,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({
    required this.icon,
    required this.label,
  });

  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface = Color(0xFF162216);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.74),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
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