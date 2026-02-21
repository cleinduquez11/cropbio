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

class _LandingVideoState extends State<LandingVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); // Refresh when initialized
        _controller.play();
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    // Responsive height
    double videoHeight;
    if (layout.isMobile) {
      videoHeight = 120;
    } else if (layout.isTablet) {
      videoHeight = 350;
    } else if (layout.isDesktop) {
      videoHeight = 425;
    } else {
      videoHeight = 500;
    }

    if (!_controller.value.isInitialized) {
      return SizedBox(
        height: videoHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: videoHeight,
      width: double.infinity,
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover, // crop video for small screens
          alignment: Alignment.center,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: Stack(children: [
              VideoPlayer(_controller),
                           
               Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.50), // adjust this value
              ),),
                  Positioned.fill(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Small Tagline
              Text(
                "MMSU • Batac • Ilocos Norte",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              // Main Heading
              Text(
                "Crop Biodiversity",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: layout.isMobile ? 32 : 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                "Advancing research, preserving genetic resources,\nand empowering sustainable agriculture.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: layout.isMobile ? 14 : 18,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 30),

              // Call To Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0B84C), // gold accent
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Explore Research",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),

              ]),
          ),
        ),
      ),
    );
  }
}
