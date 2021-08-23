import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:video_player/video_player.dart';

class PlayContentVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  PlayContentVideo({
    required this.videoPlayerController,
    required this.looping,


  });

  @override
  _PlayContentVideoState createState() => _PlayContentVideoState();
}

class _PlayContentVideoState extends State<PlayContentVideo> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        // aspectRatio: 16/ 9,
        autoInitialize: true,
        looping: widget.looping,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: true,
        autoPlay: true,
        fullScreenByDefault:  true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
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
      print('yyyyyyyy');
      print(UploadVariables.videoEnded );
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





class PlayStudentContentVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  PlayStudentContentVideo({
    required this.videoPlayerController,
    required this.looping,


  });

  @override
  _PlayStudentContentVideoState createState() => _PlayStudentContentVideoState();
}

class _PlayStudentContentVideoState extends State<PlayStudentContentVideo> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController:widget.videoPlayerController,
        // aspectRatio: 16/ 9,
        autoInitialize: true,
        looping: widget.looping,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: true,
        autoPlay: true,
        fullScreenByDefault:  true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
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


        studentsAnalysis();

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


  Future<void> studentsAnalysis() async {

    FirebaseFirestore.instance.collection('studentActivity')
        .doc(SchClassConstant.schDoc['schId']).collection('sActivity')
        .where('id',isEqualTo: SchClassConstant.studentsLessonDoc['id'])
        .where('stId',isEqualTo: SchClassConstant.schDoc['id']).get()
        .then((value){

      final List <DocumentSnapshot> documents = value.docs;

      if (documents.length == 0) {


        FirebaseFirestore.instance.collection('studentActivity').doc(SchClassConstant.schDoc['schId']).collection('sActivity').doc()
            .set({
          'ts':DateTime.now().toString(),
          SchClassConstant.isLesson?'sc':'ec':true,
          'stId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
          'fn': SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'cl':SchClassConstant.schDoc['cl'],
          'lv':SchClassConstant.schDoc['lv'],
          'tp':SchClassConstant.studentsLessonDoc['title'],
          'desc':SchClassConstant.studentsLessonDoc['desc'],
          'cn':SchClassConstant.studentsLessonDoc['tcl'],
          'tcId':SchClassConstant.studentsLessonDoc['tId'],
          'tsn':SchClassConstant.studentsLessonDoc['tfn'],
          'id':SchClassConstant.studentsLessonDoc['id'],
          'tmb':SchClassConstant.studentsLessonDoc['tmb'],
          'vid':SchClassConstant.studentsLessonDoc['vid']
        });

        SchClassConstant.isLesson = false;

      }

    });



  }



}


