import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideoScreen extends StatefulWidget {
  BackgroundVideoScreen({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  final String videoPath;

  @override
  _BackgroundVideoScreenState createState() => _BackgroundVideoScreenState();
}

class _BackgroundVideoScreenState extends State<BackgroundVideoScreen> {
  late VideoPlayerController _videoController;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath);
    _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      setState(() {
        _videoController.play();
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Stack(
        children: [
          VideoPlayer(_videoController),
          Container(color: Colors.grey.withOpacity(0.2)),
        ],
      ),
    );
  }
}
