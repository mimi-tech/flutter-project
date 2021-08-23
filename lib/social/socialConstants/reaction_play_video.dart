import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:video_player/video_player.dart';

class ReactionVideos extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  ReactionVideos({
    required this.videoPlayerController,
    required this.looping,


  });

  @override
  _ReactionVideosState createState() => _ReactionVideosState();
}

class _ReactionVideosState extends State<ReactionVideos> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.videoPlayerController.addListener(checkVideo);
    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        //aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        showControlsOnInitialize: false,
        showControls: true,
        autoPlay: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: [

          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ],
        deviceOrientationsAfterFullScreen: [

          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,

        ],
        errorBuilder: (context,errorMessage){
          return Center(
            child: Text(errorMessage,style:TextStyle(color: Colors.white)),
          );
        }
    );
    widget.videoPlayerController.addListener(() {
      if (widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {
        print('video has  Ended');
      }
    });

    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
    });

  }

  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.transparent,
        ),
        child: Chewie(controller: _chewieController,));
  }


  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(widget.videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      //print('video Started');
    }

    if(widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {
      //print('video Ended');
    }

  }
}
