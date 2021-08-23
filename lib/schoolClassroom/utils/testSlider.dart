import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:video_player/video_player.dart';

class ShowingPostVideos extends StatefulWidget {
  @override
  _ShowingPostVideosState createState() => _ShowingPostVideosState();
}

class _ShowingPostVideosState extends State<ShowingPostVideos> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : CircularProgressIndicator(backgroundColor: kFbColor,),
          ),
        IconButton(onPressed: (){

          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        }, icon:Icon( _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,size: 30,color: kWhitecolor,) )
      ],
    );



  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
