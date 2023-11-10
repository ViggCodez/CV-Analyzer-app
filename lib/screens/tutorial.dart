import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late VideoPlayerController controller;
  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.asset("assets/images/cvrtutorial.mp4");
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heres a quick Tutorial"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          VideoProgressIndicator(controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                backgroundColor: Colors.blueGrey,
                playedColor: Colors.green,
                bufferedColor: Colors.black,
              )),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }

                    setState(() {});
                  },
                  icon: Icon(controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              IconButton(
                onPressed: () {
                  controller.seekTo(const Duration(seconds: 0));
                  setState(() {});
                },
                icon: const Icon(Icons.stop),
              ),
              TextButton(
                onPressed: () {
                  _launchYouTubeVideo();
                },
                child: const Text('Click here to improve your Resume'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final Uri _url = Uri.parse('https://youtu.be/Tt08KmFfIYQ');
Future<void> _launchYouTubeVideo() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
