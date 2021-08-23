import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowUploadedVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool? looping;
  ShowUploadedVideo({
    required this.videoPlayerController,
    this.looping,
    Key? key,

  }): super(key: key);

  @override
  _ShowUploadedVideoState createState() => _ShowUploadedVideoState();
}

class _ShowUploadedVideoState extends State<ShowUploadedVideo> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.videoPlayerController.addListener(checkVideo);
    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping!,
        showControlsOnInitialize: false,
        showControls: false,

        placeholder: Center(
            child: CircularProgressIndicator()),

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
