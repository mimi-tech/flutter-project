import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/showText.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchLessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_bottombar.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_feedback.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/e-class-secondAppbar.dart';
import 'package:video_player/video_player.dart';

class StudentLessons extends StatefulWidget {
  @override
  _StudentLessonsState createState() => _StudentLessonsState();
}

class _StudentLessonsState extends State<StudentLessons> {
  int progress = 0;
  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collectionGroup('schoolLessons')
        .where('tsl', isEqualTo: SchClassConstant.schDoc['lv'])
        .where('tcl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('ass', isEqualTo: true)
        .orderBy('ts', descending: true).snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();

  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
      if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
        requestNextPage();
      }
      return true;
    },
    child: Scaffold(
        //bottomNavigationBar:EClassBottomBar(),
      appBar: StuAppBar(),
      body:CustomScrollView(slivers: <Widget>[
        ActivityAppBer(
          activitiesColor: kTextColor,
          classColor: kStabcolor1,
          newsColor: kTextColor,
        ),
        EClassSliverAppBar(
          liveBgColor: Colors.transparent,
          liveColor: klistnmber,
          missedClassBgColor: Colors.transparent,
          missedClassColor: klistnmber,
          recordsBgColor: klistnmber,
          recordsColor: kWhitecolor,
          assessmentBgColor: Colors.transparent,
          assessmentColor: klistnmber,
        ),
        EClassSliverAppBarSearchSecond(
          searchTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStudentsLessons()));

          },
        ),
        SliverList(
            delegate: SliverChildListDelegate([

              Container(
          child: Column(
            children: [
              StreamBuilder<List<DocumentSnapshot>>(
                  stream: _streamController.stream,

                  builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if(snapshot.data == null){
                      return Center(child: Text('Loading...'));
                    } else {
                      return Column(
                          children: snapshot.data!.map((doc) {
                            Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
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
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                height:MediaQuery.of(context).size.width * 0.3,
                                                                child: Center(
                                                                  child: ShowUploadedVideo(
                                                                    videoPlayerController: VideoPlayerController.network(data['vid']),
                                                                    looping: false,
                                                                  ),
                                                                ),
                                                              )
                                                            : Image.network(
                                                          data['tmb'],
                                                                fit: BoxFit.cover,
                                                                width: MediaQuery.of(context).size.width * 0.35,
                                                                height: ScreenUtil().setHeight(80),),
                                                        Center(
                                                            child: ButtonTheme(
                                                                shape: CircleBorder(),
                                                                height: ScreenUtil().setHeight(50),
                                                                child: RaisedButton(
                                                                        color: Colors.transparent,
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              SchClassConstant.studentsLessonDoc = doc;
                                                                              SchClassConstant.isLesson = true;
                                                                              UploadVariables.videoUrlSelected = data['vid'];
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentPlayingVideos()));
                                                                              updateViews(doc);
                                                                            },
                                                                            child: Icon(Icons.play_arrow, size: 40)))))
                                                      ]),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  ShowLiveText(
                                                    likeClick: (){_likeLesson(doc);},
                                                      title: data['title'],
                                                      desc: data['desc'],
                                                      rate: data['like'].toString(),
                                                      date: data['ts'],
                                                      views: data['view'].toString(),
                                                      comm: data['comm'].toString(),
                                                      downloads: data['down'].toString(),
                                                      note: data['ntc'].toString()

                                                  ),


                                                ],
                                              ),

                                              Divider(),
                                              IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final status = await Permission.storage.request();

                                                        if (status.isGranted) {
                                                         // final externalDir = await getExternalStorageDirectory();

                                                          final id = await FlutterDownloader.enqueue(
                                                            url:data['vid'],
                                                            savedDir: _localPath,//externalDir.path,
                                                            fileName: '${data['title']}.mp4',
                                                            showNotification: true,
                                                            openFileFromNotification: true,
                                                          );
                                                          updateDownloads(doc);


                                                        } else {
                                                          print("Permission denied");
                                                        }
                                                      },
                                                      child: Text(
                                                        'Download',
                                                        style:
                                                            GoogleFonts.rajdhani(
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
                                                        if(data['srt'] != null){
                                                        final status = await Permission.storage.request();

                                                        if (status.isGranted) {
                                                          // final externalDir = await getExternalStorageDirectory();

                                                          final id = await FlutterDownloader.enqueue(
                                                            url:data['srt'],
                                                            savedDir: _localPath,//externalDir.path,
                                                            fileName: '${data['title']}.srt',
                                                            showNotification: true,
                                                            openFileFromNotification: true,
                                                          );
                                                          updateDownloads(doc);


                                                        } else {
                                                          print("Permission denied");
                                                        }}
                                                      },
                                                      child: Text(
                                                        data['srt'] == null?'No srt':'Srt',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: kExpertColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    VerticalDivider(),


                                                    GestureDetector(
                                                      onTap: () async {
                                                        if(data['slide'] != null){
                                                          final status = await Permission.storage.request();

                                                          if (status.isGranted) {
                                                            // final externalDir = await getExternalStorageDirectory();

                                                            final id = await FlutterDownloader.enqueue(
                                                              url:data['slide'],
                                                              savedDir: _localPath,//externalDir.path,
                                                              fileName: '${data['title']}.ppt',
                                                              showNotification: true,
                                                              openFileFromNotification: true,
                                                            );
                                                            updateDownloads(doc);


                                                          } else {
                                                            print("Permission denied");
                                                          }}
                                                      },
                                                      child: Text(
                                                        data['slide'] == null?'No slide':'Slide',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: kExpertColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    VerticalDivider(),

                                                    data['note'] == null
                                                        ? Text('No class note',
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: kExpertColor,
                                                                fontSize: kFontSize14.sp,
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewClassNote(note:data['note'],doc:doc)));

                                                      },
                                                          child: Text('View note',
                                                              style: GoogleFonts.rajdhani(
                                                                textStyle: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: kExpertColor,
                                                                  fontSize: kFontSize14.sp,
                                                                ),
                                                              ),
                                                            ),
                                                        ),
                                                    VerticalDivider(),
                                                    GestureDetector(
                                                      onTap: (){
                                                        giveFeedback(doc);
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
                                                      onTap: (){
                                                        askQuestions(doc);
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

                        }).toList()
                              );
                    }
                  })
            ],
          ),
        ),
      ]),
    )])));
  }

  void giveFeedback(DocumentSnapshot doc) {
//give your teacher a feedback concerning this lesson
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentFeedback(doc:doc);
        });

  }

  Future<void> _likeLesson(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{
    //check if student have liked this lesson
    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('likedLessons')
        .where('id', isEqualTo: data['id'])
        .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {
      SchClassConstant.displayBotToastCorrect(title: kSchoolStudentLike);

    }else {
      //update the lesson like count

      FirebaseFirestore.instance.collection('lesson').doc(
          data['schId']).collection('schoolLessons').doc(
          data['id']).get()
          .then((resultLike) {
        dynamic totalLike = resultLike.data()!['like'] + 1;

        resultLike.reference.set({
          'like': totalLike,

        }, SetOptions(merge: true));
      });


      //push lesson to liked lessons
      FirebaseFirestore.instance.collection('studentsLikedLessons').doc(data['schId']).collection('likedLessons').add({
        'id':data['id'],
        'pin':SchClassConstant.schDoc['pin'],
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),


      });

    }}catch(e){
   print(e);
 }
}

  Future<void> updateViews(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{
      //check if student have liked this lesson
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('viewedLessons')
          .where('id', isEqualTo: data['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 0) {

        //update the lesson view count

        FirebaseFirestore.instance.collection('lesson').doc(
            data['schId']).collection('schoolLessons').doc(
            data['id']).get()
            .then((resultView) {
          dynamic totalViews = resultView.data()!['view'] + 1;

          resultView.reference.set({
            'view': totalViews,

          }, SetOptions(merge: true));
        });


        //push lesson to view lessons
        FirebaseFirestore.instance.collection('studentsViewedLessons').doc(data['schId']).collection('viewedLessons').add({
          'id':data['id'],
          'pin':SchClassConstant.schDoc['pin'],
          'fn':SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'ts':DateTime.now().toString(),

        });

      }

    }catch(e){
      print(e);
    }
  }

  Future<void> updateDownloads(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{
      //check if student have downloaded this lesson
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('downloadedLessons')
          .where('id', isEqualTo: data['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 0) {

        //update the lesson view count

        FirebaseFirestore.instance.collection('lesson').doc(
            data['schId']).collection('schoolLessons').doc(
            data['id']).get()
            .then((resultDownloads) {
          dynamic totalDownloads = resultDownloads.data()!['down'] + 1;

          resultDownloads.reference.set({
            'down': totalDownloads,

          }, SetOptions(merge: true));
        });


        //push lesson to view lessons
        FirebaseFirestore.instance.collection('studentsDownloadedLessons').doc(data['schId']).collection('downloadedLessons').add({
          'id':data['id'],
          'pin':SchClassConstant.schDoc['pin'],
          'fn':SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'ts':DateTime.now().toString(),

        });

      }
    }catch(e){
      print(e);
    }

  }

  void askQuestions(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsQuestions(doc:doc);
        });
  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await    FirebaseFirestore.instance
            .collectionGroup('schoolLessons')
            .where('tsl', isEqualTo: SchClassConstant.schDoc['lv'])
            .where('tcl', isEqualTo: SchClassConstant.schDoc['cl'])
            .where('ass', isEqualTo: true)
            .orderBy('ts', descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await   FirebaseFirestore.instance
            .collectionGroup('schoolLessons')
            .where('tsl', isEqualTo: SchClassConstant.schDoc['lv'])
            .where('tcl', isEqualTo: SchClassConstant.schDoc['cl'])
            .where('ass', isEqualTo: true)
            .orderBy('ts', descending: true)
            .startAfterDocument(_products[_products.length - 1])
            .limit(SchClassConstant.streamCount)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }
}
