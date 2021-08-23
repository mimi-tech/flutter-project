import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/classroom/contents/chewiwplayvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:video_player/video_player.dart';
class PlayingVideos extends StatefulWidget {
  @override
  _PlayingVideosState createState() => _PlayingVideosState();
}

class _PlayingVideosState extends State<PlayingVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: PlayContentVideo(
                videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),

                looping: false,
              ),
            )
          ]
      ),

    );
  }

}


class StudentPlayingVideos extends StatefulWidget {
  @override
  _StudentPlayingVideosState createState() => _StudentPlayingVideosState();
}

class _StudentPlayingVideosState extends State<StudentPlayingVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: PlayStudentContentVideo(
                videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),

                looping: false,
              ),
            )
          ]
      ),

    );
  }
}




class PlayingFileVideos extends StatefulWidget {
  @override
  _PlayingFileVideosState createState() => _PlayingFileVideosState();
}

class _PlayingFileVideosState extends State<PlayingFileVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: PlayContentVideo(
                videoPlayerController: VideoPlayerController.file(UploadVariables.videoFileSelected!),

                looping: false,
              ),
            )
          ]
      ),

    );
  }
}
/*

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
              videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected),

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
                videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected),

                looping: false,
              ),
            )
          ]
      ),
    );
  }
}
*/
