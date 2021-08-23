import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        UploadVariables.videoUrlSelected!);

    // Initielize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text('Bee Video'),
        backgroundColor: Colors.black87,
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Stack(
        children: <Widget>[
          Center(
              child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
          Center(
              child: ButtonTheme(
                  height: 100.0,
                  minWidth: 200.0,
                  child: RaisedButton(
                    padding: EdgeInsets.all(60.0),
                    color: Colors.transparent,
                    textColor: Colors.white,
                    onPressed: () {
                      // Wrap the play or pause in a call to `setState`. This ensures the
                      // correct icon is shown.
                      setState(() {
                        // If the video is playing, pause it.
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          // If the video is paused, play it.
                          _controller.play();
                        }
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 120.0,
                    ),
                  )))
        ],
      ),
    );
  }
}

/*

showDialog(
context: context,
builder: (context) => SimpleDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
elevation: 4,
children: <Widget>[
Text(kSwarning,
textAlign: TextAlign.center,
style: TextStyle(
fontSize: ScreenUtil()
    .setSp(
22,
allowFontScalingSelf:
true),
color: kFbColor,
fontFamily: 'Rajdhani',
),
),
Text(kSdetetealert,
textAlign: TextAlign.center,

style: TextStyle(
fontSize: kFontsize.sp,
color: kBlackcolor,
fontFamily: 'RajdhaniMedium',
),
),
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: <Widget>[
OutlineButton(child: Text(kCancel,
style: TextStyle(
fontSize: kFontsize.sp,
color: kBlackcolor,
fontFamily: 'Rajdhani',
),

),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(4.0),
side:
BorderSide(color: kPreviewcolor)),
onPressed: (){Navigator.pop(context);},
),

//ToDo:continue to delete this video
RaisedButton(child: Text(kSYesdelete,
style: TextStyle(
fontSize: ScreenUtil()
    .setSp(
kFontsize,
allowFontScalingSelf:true),
color: kWhitecolor,
fontFamily: 'Rajdhani',
),

),
color:kFbColor,
onPressed: (){
Navigator.pop(context);
actualDelete();},
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(4.0),
)
)
],
)
]
)
);*/
