import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MediaPlayer extends StatefulWidget {
  final String url;
  MediaPlayer({@required this.url});
  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  var videoPlayerController;

//https://v.redd.it/7fpx9a4xvi431/DASH_360
  var chewieController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.url);
    // videoPlayerController = VideoPlayerController.network(
    //     "https://v.redd.it/63jiq0c2be531/DASH_720?source=fallback");

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
