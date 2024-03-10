import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/sample.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        // Play the video
        _controller.play();
      });

    // Simulate a delay before navigating to the second page
    Future.delayed(const Duration(seconds: 4), () {
      _controller.pause();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            // ? AspectRatio(
            //     aspectRatio: 1.2,
            //     child: VideoPlayer(_controller),
            //   )
            ? VideoPlayer(_controller)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
