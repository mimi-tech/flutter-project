import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/all_socialClasses.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/e-class-secondAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_feedbacks.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/students_response.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_show_text.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/w.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchLessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:video_player/video_player.dart';

class TeacherStudies extends StatefulWidget {
  @override
  _TeacherStudiesState createState() => _TeacherStudiesState();
}

class _TeacherStudiesState extends State<TeacherStudies> {

  String like = 'Liked by';
  String view = 'Viewed by';
  String videoDownload = 'Video DownLoaded by';
  String noteDownload = 'Note DownLoaded by';

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

  @override
  void initState() {

    FirebaseFirestore.instance.collectionGroup('schoolLessons')
        .where('tId',isEqualTo:  SchClassConstant.schDoc['id'])
        .orderBy('ts',descending: true).snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
        child: SafeArea(
          child: Scaffold(

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
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStudentsLessons()));

              },
            ),
              SliverList(
                  delegate: SliverChildListDelegate([
            Column(
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
                                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Row(
                                                  children: [
                                                    Stack(
                                                        alignment: Alignment.center,
                                                        children: <Widget>[
                                                          data['tmb'] == null? Container(
                                                            width:MediaQuery.of(context).size.width * 0.3,
                                                            height:MediaQuery.of(context).size.width * 0.5,
                                                            child: Center(
                                                              child: ShowUploadedVideo(
                                                                videoPlayerController: VideoPlayerController.network(data['vid']),
                                                                looping: false,
                                                              ),
                                                            ),
                                                          ):Image.network(data['tmb'],
                                                            fit: BoxFit.cover,
                                                            width:MediaQuery.of(context).size.width * 0.35,
                                                            height: ScreenUtil().setHeight(80),
                                                          ),
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
                                                                            UploadVariables.videoUrlSelected = data['vid'];
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                          },
                                                                          child: Icon(
                                                                              Icons.play_arrow, size: 40)))))
                                                        ]),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    TeacherShowText(
                                                        likeClick: (){

                                                          SchClassConstant.isLiked = true;
                                                          SchClassConstant.isView = false;
                                                          SchClassConstant.isDownload = false;
                                                          SchClassConstant.isDownloadNote = false;

                                                          _likeLesson(doc,like);
                                                        },

                                                        viewClick: (){
                                                          SchClassConstant.isLiked = false;
                                                          SchClassConstant.isView = true;
                                                          SchClassConstant.isDownload = false;
                                                          SchClassConstant.isDownloadNote = false;
                                                          _viewLesson(doc,view);

                                                        },

                                                        feedClick: (){ checkFeedback(doc);
                                                        },

                                                        downloadClick: (){
                                                          SchClassConstant.isLiked = false;
                                                          SchClassConstant.isView = false;
                                                          SchClassConstant.isDownload = true;
                                                          SchClassConstant.isDownloadNote = false;
                                                          _downloadLesson(doc,videoDownload);

                                                        },
                                                        downloadNoteClick: (){
                                                          SchClassConstant.isLiked = false;
                                                          SchClassConstant.isView = false;
                                                          SchClassConstant.isDownload = false;
                                                          SchClassConstant.isDownloadNote = true;
                                                          _downloadNoteLesson(doc,noteDownload);

                                                        },

                                                        title: data['title'],
                                                        desc: data['desc'],
                                                        rate: data['like'].toString(),
                                                        date: DateFormat('EE-MM-yyyy hh:mm:a').format(DateTime.parse(data['ts'])),//data['ts'],
                                                        views: data['view'].toString(),
                                                        comm: data['comm'].toString(),
                                                        downloads: data['down'].toString(),
                                                        note: data['ntc'].toString()

                                                    ),

                                                  ],
                                                ),

                                                Divider(),


                                                Text('${data['tcl']} ${data['tsl']}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kMaincolor,
                                                      fontSize: kFontsize.sp,
                                                    ),
                                                  ),

                                                ),
                                                Divider(),

                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:(){checkFeedback(doc);},
                                                        child: Text("Feedback",
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

                                                      data['ass'] == true?





                                                      GestureDetector(
                                                        onTap: (){_blockLesson(doc);},
                                                        child: Text("Block",
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: kExpertColor,
                                                              fontSize: kFontSize14.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      )

                                                          : GestureDetector(
                                                        onTap: (){_unBlockLesson(doc);},
                                                        child: Text("Unblock",
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
                                                        onTap: (){_answerQuestions(doc);},
                                                        child: Text("Q & A",
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
                                                          ? Text('No note',
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
                                                    ],
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                  );
                                }).toList()

                            );
                          }
                        }
                    ),





                    _isFinish == false ?
                    isLoading == true ? Center(
                        child: PlatformCircularProgressIndicator()) : Text('')

                        : Text(''),
                  ],
                ),
              ]),
            ),
          ]),
        )));
  }

  void _blockLesson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    FirebaseFirestore.instance.collection('lesson').doc(data['schId']).collection('schoolLessons').doc(data['id'])
        .set({
      'ass':false,
    },SetOptions(merge: true));
  }

  void _unBlockLesson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    FirebaseFirestore.instance.collection('lesson').doc(data['schId']).collection('schoolLessons').doc(data['id'])
        .set({
      'ass':true,
      'ts':DateTime.now().toString()
    },SetOptions(merge: true));
  }

  void _answerQuestions(DocumentSnapshot doc) {
    //seeing the questions asked by students

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

  void checkFeedback(DocumentSnapshot doc,) {
    //get feedback from students concerning this lesson

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), builder: (context) {
      return TeachersFeedback(doc:doc);
    });

  }

  void _likeLesson(DocumentSnapshot doc, String like) {

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsResponse(doc:doc,title:like);
        });


  }

  void _viewLesson(DocumentSnapshot doc, String view) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsResponse(doc:doc,title:view);
        });

  }

  void _downloadLesson(DocumentSnapshot doc, String videoDownload) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsResponse(doc:doc,title:videoDownload);
        });
  }

  void _downloadNoteLesson(DocumentSnapshot doc, String noteDownload) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsResponse(doc:doc,title:noteDownload);
        });
  }


  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await    FirebaseFirestore.instance.collectionGroup('schoolLessons')
            .where('tId',isEqualTo:  SchClassConstant.schDoc['id'])
            .orderBy('ts',descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await    FirebaseFirestore.instance.collectionGroup('schoolLessons').where('tId',isEqualTo:  SchClassConstant.schDoc['id']).orderBy('ts',descending: true)
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
