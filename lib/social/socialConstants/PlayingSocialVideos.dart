import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/social/socialConstants/reaction_play_video.dart';
import 'package:sparks/social/socialCourse/playCourseClass.dart';
import 'package:video_player/video_player.dart';

class PlayingSocialVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  PlayingSocialVideo({
    required this.videoPlayerController,
    required this.looping,


  });

  @override
  _PlayingSocialVideoState createState() => _PlayingSocialVideoState();
}

class _PlayingSocialVideoState extends State<PlayingSocialVideo> {
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //widget.videoPlayerController.initialize();

    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        // aspectRatio: 16/ 9,
        autoInitialize: true,
        looping: widget.looping,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: true,
        autoPlay: true,
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
        setState(() {
          UploadVariables.videoEnded = true;
        });
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
  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController,);
  }
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}




class FullScreenReactionVideos extends StatefulWidget {
  @override
  _FullScreenReactionVideosState createState() => _FullScreenReactionVideosState();
}

class _FullScreenReactionVideosState extends State<FullScreenReactionVideos> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Expanded(
            child: ReactionVideos(
              videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),

              looping: false,
            ),
          )
        ]
    );
  }
}



class SocialCCVideos extends StatefulWidget {
  @override
  _SocialCCVideosState createState() => _SocialCCVideosState();
}

class _SocialCCVideosState extends State<SocialCCVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: PlayingSocialCc(
                videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),

                looping: false,
              ),
            )
          ]
      ),
    );
  }
}
