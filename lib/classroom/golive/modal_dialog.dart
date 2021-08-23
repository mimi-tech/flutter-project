import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ChewieDemo extends StatefulWidget {


  @override
  _ChewieDemoState createState() => _ChewieDemoState();
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  List<VideoItem> items = [
    VideoItem(
      title: 'Fluttering Butterfly',
      description: 'A lovely butterfly flapping it\'s wings',
      controller: new VideoPlayerController.network(
  'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true'
  ),
    ),
    VideoItem(
      title: 'Fluttering Butterfly',
      description: 'A lovely butterfly flapping it\'s wings',
      controller: new VideoPlayerController.network(
          'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true'
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: new ListView(
          children: items.map((item) {
            return new Container(
              margin: new EdgeInsets.only(bottom: 20.0),
              child: new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      item.title!,
                      style: Theme.of(context).textTheme.title,
                    ),
                    new Text(
                      item.description!,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    new Chewie(
                        controller: ChewieController(
                          videoPlayerController: item.controller!,
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          looping: true,
                        )
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );

  }
}
class VideoItem {
  final String? title;
  final String? description;
  final VideoPlayerController? controller;

  VideoItem({this.title, this.description, this.controller});
}