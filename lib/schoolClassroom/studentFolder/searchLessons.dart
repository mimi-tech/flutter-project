import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:sparks/schoolClassroom/showText.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_feedback.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sparks/schoolClassroom/utils/searchservice.dart';

import 'package:video_player/video_player.dart';

class SearchStudentsLessons extends StatefulWidget {
  @override
  _SearchStudentsLessonsState createState() => _SearchStudentsLessonsState();
}

class _SearchStudentsLessonsState extends State<SearchStudentsLessons> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot>[];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot>[];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  bool isPlaying = false;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByStudentsLessons(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {
      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['title'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading")!;

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/
    });

    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();
  }

  late String _localPath;
  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    print('Download Path: $_localPath');

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kStatusbar,
              title: Text(
                'Search for a lesson',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kWhitecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhitecolor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    tempSearchStore.length == 0
                        ? Text('')
                        : ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          Map<String, dynamic> data = tempSearchStore[index]
                              .data() as Map<String, dynamic>;
                          return Card(
                              elevation: 10,
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                data['tmb'] == null
                                                    ? Container(
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.3,
                                                  height: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.5,
                                                  child: Center(
                                                    child:
                                                    ShowUploadedVideo(
                                                      videoPlayerController:
                                                      VideoPlayerController.network(
                                                          tempSearchStore[
                                                          index]
                                                          [
                                                          'vid']),
                                                      looping: false,
                                                    ),
                                                  ),
                                                )
                                                    : Image.network(
                                                  data['tmb'],
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.35,
                                                  height: ScreenUtil()
                                                      .setHeight(80),
                                                ),
                                                Center(
                                                  child: ButtonTheme(
                                                    shape: CircleBorder(),
                                                    height: ScreenUtil()
                                                        .setHeight(50),
                                                    child: RaisedButton(
                                                      color: Colors.transparent,
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          UploadVariables
                                                              .videoUrlSelected =
                                                          data['vid'];
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                      PlayingVideos()));
                                                          updateViews(index);
                                                        },
                                                        child: Icon(
                                                            Icons.play_arrow,
                                                            size: 40),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            ShowLiveText(
                                                likeClick: () {
                                                  _likeLesson(
                                                      tempSearchStore[index]);
                                                },
                                                title: data['title'],
                                                desc: data['desc'],
                                                rate: data['like'].toString(),
                                                date: data['ts'],
                                                views: data['view'].toString(),
                                                comm: data['comm'].toString(),
                                                downloads:
                                                data['down'].toString(),
                                                note: data['ntc'].toString()),
                                          ],
                                        ),
                                        Divider(),
                                        IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final status =
                                                  await Permission.storage
                                                      .request();

                                                  if (status.isGranted) {
                                                    // final externalDir = await getExternalStorageDirectory();

                                                    final id =
                                                    await FlutterDownloader
                                                        .enqueue(
                                                      url: data['vid'],
                                                      savedDir:
                                                      _localPath, //externalDir.path,
                                                      fileName:
                                                      '${data['title']}.mp4',
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                      true,
                                                    );
                                                    updateDownloads(index);
                                                  } else {
                                                    print("Permission denied");
                                                  }
                                                },
                                                child: Text(
                                                  'Video',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (data['srt'] != null) {
                                                    final status =
                                                    await Permission.storage
                                                        .request();

                                                    if (status.isGranted) {
                                                      // final externalDir = await getExternalStorageDirectory();

                                                      final id =
                                                      await FlutterDownloader
                                                          .enqueue(
                                                        url: data['srt'],
                                                        savedDir:
                                                        _localPath, //externalDir.path,
                                                        fileName:
                                                        '${data['title']}.srt',
                                                        showNotification: true,
                                                        openFileFromNotification:
                                                        true,
                                                      );
                                                      updateDownloads(index);
                                                    } else {
                                                      print(
                                                          "Permission denied");
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  data['srt'] == null
                                                      ? 'No srt'
                                                      : 'Download srt',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (data['slide'] != null) {
                                                    final status =
                                                    await Permission.storage
                                                        .request();

                                                    if (status.isGranted) {
                                                      // final externalDir = await getExternalStorageDirectory();

                                                      final id =
                                                      await FlutterDownloader
                                                          .enqueue(
                                                        url: data['slide'],
                                                        savedDir:
                                                        _localPath, //externalDir.path,
                                                        fileName:
                                                        '${data['title']}.ppt',
                                                        showNotification: true,
                                                        openFileFromNotification:
                                                        true,
                                                      );
                                                      updateDownloads(index);
                                                    } else {
                                                      print(
                                                          "Permission denied");
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  data['slide'] == null
                                                      ? 'No slide'
                                                      : 'Download slide',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(),
                                              data['note'] == null
                                                  ? Text(
                                                'No class note',
                                                style:
                                                GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: kExpertColor,
                                                    fontSize:
                                                    kFontSize14.sp,
                                                  ),
                                                ),
                                              )
                                                  : GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewClassNote(
                                                              note: tempSearchStore[
                                                              index]
                                                              [
                                                              'note'],
                                                              doc: tempSearchStore[
                                                              index])));
                                                },
                                                child: Text(
                                                  'Note',
                                                  style: GoogleFonts
                                                      .rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize:
                                                      kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(),
                                              GestureDetector(
                                                onTap: () {
                                                  giveFeedback(
                                                      tempSearchStore[index]);
                                                },
                                                child: Text(
                                                  'Feedback',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(),
                                              GestureDetector(
                                                onTap: () {
                                                  askQuestions(
                                                      tempSearchStore[index]);
                                                },
                                                child: Text(
                                                  'Q & A',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ])));
                        }),
                  ]))
            ])));
  }

  void giveFeedback(DocumentSnapshot doc) {
//give your teacher a feedback concerning this lesson
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentFeedback(doc: doc);
        });
  }

  Future<void> _likeLesson(index) async {
    Map<String, dynamic> data =
    tempSearchStore[index].data() as Map<String, dynamic>;
    try {
      //check if student have liked this lesson
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('likedLessons')
          .where('id', isEqualTo: data['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length >= 1) {
        SchClassConstant.displayBotToastCorrect(title: kSchoolStudentLike);
      } else {
        //update the lesson like count

        FirebaseFirestore.instance
            .collection('lesson')
            .doc(data['schId'])
            .collection('schoolLessons')
            .doc(data['id'])
            .get()
            .then((resultLike) {
          dynamic totalLike = resultLike.data()!['like'] + 1;

          resultLike.reference.set({
            'like': totalLike,
          }, SetOptions(merge: true));
        });

        //push lesson to liked lessons
        FirebaseFirestore.instance
            .collection('studentsLikedLessons')
            .doc(data['schId'])
            .collection('likedLessons')
            .add({
          'id': data['id'],
          'pin': SchClassConstant.schDoc['pin'],
          'fn': SchClassConstant.schDoc['fn'],
          'ln': SchClassConstant.schDoc['ln'],
          'ts': DateTime.now().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateViews(int index) async {
    Map<String, dynamic> data =
    tempSearchStore[index].data() as Map<String, dynamic>;
    try {
      //check if student have liked this lesson
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('viewedLessons')
          .where('id', isEqualTo: data['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        //update the lesson view count

        FirebaseFirestore.instance
            .collection('lesson')
            .doc(data['schId'])
            .collection('schoolLessons')
            .doc(data['id'])
            .get()
            .then((resultView) {
          dynamic totalViews = resultView.data()!['view'] + 1;

          resultView.reference.set({
            'view': totalViews,
          }, SetOptions(merge: true));
        });

        //push lesson to view lessons
        FirebaseFirestore.instance
            .collection('studentsViewedLessons')
            .doc(data['schId'])
            .collection('viewedLessons')
            .add({
          'id': data['id'],
          'pin': SchClassConstant.schDoc['pin'],
          'fn': SchClassConstant.schDoc['fn'],
          'ln': SchClassConstant.schDoc['ln'],
          'ts': DateTime.now().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateDownloads(int index) async {
    Map<String, dynamic> data =
    tempSearchStore[index].data() as Map<String, dynamic>;
    try {
      //check if student have downloaded this lesson
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('downloadedLessons')
          .where('id', isEqualTo: data['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        //update the lesson view count

        FirebaseFirestore.instance
            .collection('lesson')
            .doc(data['schId'])
            .collection('schoolLessons')
            .doc(data['id'])
            .get()
            .then((resultDownloads) {
          dynamic totalDownloads = resultDownloads.data()!['down'] + 1;

          resultDownloads.reference.set({
            'down': totalDownloads,
          }, SetOptions(merge: true));
        });

        //push lesson to view lessons
        FirebaseFirestore.instance
            .collection('studentsDownloadedLessons')
            .doc(data['schId'])
            .collection('downloadedLessons')
            .add({
          'id': data['id'],
          'pin': SchClassConstant.schDoc['pin'],
          'fn': SchClassConstant.schDoc['fn'],
          'ln': SchClassConstant.schDoc['ln'],
          'ts': DateTime.now().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void askQuestions(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsQuestions(doc: doc);
        });
  }
}
