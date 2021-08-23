import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:video_player/video_player.dart';

class PlayingSocialCc extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  PlayingSocialCc({
    required this.videoPlayerController,
    required this.looping,


  });

  @override
  _PlayingSocialCcState createState() => _PlayingSocialCcState();
}

class _PlayingSocialCcState extends State<PlayingSocialCc> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
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
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage, style: TextStyle(color: Colors.white)),
          );
        }


    );

    //stop music after 12 seconds
    /*Future.delayed(Duration(seconds: 12), () {
      _chewieController.pause();
      _chewieController.showControls = false;
    });*/


    widget.videoPlayerController.addListener(() {
      if (_chewieController.isPlaying) {

        //stop music after 12 seconds
        Future.delayed(Duration(seconds: 12), () {
          _chewieController.pause();
          Navigator.pop(context);

        });

      }else{
        print('eeeeeee');
      }

    });


  }
  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController,);
  }
  void dispose() {
    super.dispose();
    if(widget.videoPlayerController != null){
      widget.videoPlayerController.dispose();
    }
   if( _chewieController != null){
     _chewieController.dispose();
   }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
