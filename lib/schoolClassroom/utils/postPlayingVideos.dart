import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:video_player/video_player.dart';

class PlayingSchoolPostVideos extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool playing;
  PlayingSchoolPostVideos({
    required this.videoPlayerController,
    required this.playing,
    required this.looping,


  });

  @override
  _PlayingSchoolPostVideosState createState() => _PlayingSchoolPostVideosState();
}

class _PlayingSchoolPostVideosState extends State<PlayingSchoolPostVideos> {
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //widget.videoPlayerController.initialize();

    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
         aspectRatio: widget.videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        showOptions: false,
        looping: widget.looping,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        //allowFullScreen: true,
        autoPlay: widget.playing,
        /*deviceOrientationsOnEnterFullScreen: [

          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ],
        deviceOrientationsAfterFullScreen: [

          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,

        ],*/
        errorBuilder: (context,errorMessage){
          return Center(
            child: Text(kError),
          );
        }



    );

    widget.videoPlayerController.addListener(() {
      if (widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {

       increaseViewCount();
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
    return AspectRatio(
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        child: Chewie(controller: _chewieController,));
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

  Future<void> increaseViewCount() async {
    //check if student have watched this video before
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('viewSchPost')
        .where('id', isEqualTo: SchoolPostConst.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {

      FirebaseFirestore.instance.collection('schoolPost').doc(SchoolPostConst.doc['schId']).collection('campusPost')
          .doc(SchoolPostConst.doc['id'] )
      //.doc(workingDocuments[index]['id'])
          .get()
          .then((value) {

        var count = value.data()!['view'] + 1;
        value.reference.set({
          'view': count,
        }, SetOptions(merge: true));


      });
}}}
