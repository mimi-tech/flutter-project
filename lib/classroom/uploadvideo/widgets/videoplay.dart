import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool? looping;
  VideoPlay({
    required this.videoPlayerController,
    this.looping,
    Key? key,

  }): super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping!,
        showControlsOnInitialize: false,
        errorBuilder: (context,errorMessage){
          return Center(
            child: Text(errorMessage,style:TextStyle(color: Colors.white)),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8.0),
      child: Chewie(controller: _chewieController,),);
  }
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
