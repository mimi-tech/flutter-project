import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ThumbnailWidget extends StatefulWidget {
  final double size;
  final String? imagePath;

  const ThumbnailWidget({Key? key, required this.imagePath, this.size = 32.0})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  String? thumb;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    // From Ellis - Should be XFile video = ...
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryCreateScreen(isVideo: false, videoPath: image.path, duration: null)));
  }

  Future getVideo() async {
    // From Ellis - Should be XFile video = ...
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video == null) {
      return;
    }

    _videoPlayerController = VideoPlayerController.file(
      File(video.path),
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized) {
        /*Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            StoryCreateScreen(isVideo: true, videoPath: video.path,
                duration: _videoPlayerController.value.duration.inSeconds.toString())));*/
        print("play video");
      }
    });

    _videoPlayerController.initialize();
  }

  void checkVideo() {
    if (_videoPlayerController.value.isInitialized) {}

    if (_videoPlayerController.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
      print('video Ended');
    }
  }

  @override
  Widget build(BuildContext context) {
    thumb = widget.imagePath;

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: getImage,
          child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8.0)),
              child: thumb != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(thumb!),
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                    )
                  : null),
        ),
        GestureDetector(
          onTap: getVideo,
          child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8.0)),
              child: thumb != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(thumb!),
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                    )
                  : null),
        ),
      ],
    );
  }
}
