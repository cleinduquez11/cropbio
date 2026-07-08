import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../Providers/LayoutProvider.dart';

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

  final ValueNotifier<bool> initialized = ValueNotifier(false);

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
    await _controller.initialize();

    await _controller.setLooping(true);
    await _controller.setVolume(0);

    if (!mounted) return;

    initialized.value = true;

    /// Slight delay prevents initial frame stutter on web
    Future.delayed(
      const Duration(milliseconds: 120),
      () {
        if (mounted) {
          _controller.play();
        }
      },
    );
  }

  @override
  void dispose() {
    initialized.dispose();
    _controller.dispose();
    super.dispose();
  }

  double _responsiveHeight(LayoutProvider layout) {
    if (layout.isMobile) return 320;
    if (layout.isTablet) return 420;
    if (layout.isDesktop) return 520;
    return 620;
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
        child: ValueListenableBuilder(
          valueListenable: initialized,
          builder: (context, isReady, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: isReady
                  ? _buildVideo(layout)
                  : _buildSkeleton(videoHeight),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton(double height) {
    return Container(
      key: const ValueKey("skeleton"),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
            Colors.grey.shade900,
          ],
        ),
      ),
      child: Stack(
        children: [
          /// subtle shimmer layer
          TweenAnimationBuilder<double>(
            tween: Tween(begin: -1, end: 2),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.linear,
            onEnd: () {
              if (mounted) {
                setState(() {});
              }
            },
            builder: (_, value, child) {
              return Transform.translate(
                offset: Offset(value * 500, 0),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          /// loading indicator
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Loading Experience",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideo(LayoutProvider layout) {
    return SizedBox(
      key: const ValueKey("video"),
      height: double.infinity,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// VIDEO
            FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),

            /// OVERLAY
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),

            /// CONTENT
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MMSU • Batac • Ilocos Norte",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            letterSpacing: 2,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Crop Biodiversity",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: layout.isMobile ? 36 : 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "Promoting crop and cropping diversity through innovative space applications",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: layout.isMobile ? 14 : 18,
                            height: 1.8,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 36),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFE0B84C),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Explore Research",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}