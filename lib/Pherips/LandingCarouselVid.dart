import 'package:flutter/material.dart';
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
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
