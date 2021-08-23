import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_feedbacks.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/students_response.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_show_text.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:video_player/video_player.dart';
class RecordedActivities extends StatefulWidget {
  RecordedActivities({required this.doc});
  final DocumentSnapshot doc;
  @override
  _RecordedActivitiesState createState() => _RecordedActivitiesState();
}

class _RecordedActivitiesState extends State<RecordedActivities> {
  List<dynamic> workingDocuments = <dynamic>[];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  var _documents = <DocumentSnapshot>[];
  String like = 'Liked by';
  String view = 'Viewed by';
  String videoDownload = 'Video DownLoaded by';
  String noteDownload = 'Note DownLoaded by';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              itemCount: workingDocuments.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return Card(
                    elevation: 10,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        workingDocuments[index]['tmb'] == null
                                            ? Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.3,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.5,
                                          child: Center(
                                            child: ShowUploadedVideo(
                                              videoPlayerController: VideoPlayerController
                                                  .network(
                                                  workingDocuments[index]['vid']),
                                              looping: false,
                                            ),
                                          ),
                                        )
                                            : Image.network(
                                          workingDocuments[index]['tmb'],
                                          fit: BoxFit.cover,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.35,
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
                                                          UploadVariables
                                                              .videoUrlSelected =
                                                          workingDocuments[index]['vid'];
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                        },
                                                        child: Icon(
                                                            Icons.play_arrow,
                                                            size: 40)))))
                                      ]),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  TeacherShowText(
                                      likeClick: () {
                                        SchClassConstant.isLiked = true;
                                        SchClassConstant.isView = false;
                                        SchClassConstant.isDownload = false;
                                        SchClassConstant.isDownloadNote = false;

                                        _likeLesson(_documents[index], like);
                                      },

                                      viewClick: () {
                                        SchClassConstant.isLiked = false;
                                        SchClassConstant.isView = true;
                                        SchClassConstant.isDownload = false;
                                        SchClassConstant.isDownloadNote = false;
                                        _viewLesson(_documents[index], view);
                                      },

                                      feedClick: () {
                                        checkFeedback(_documents[index]);
                                      },

                                      downloadClick: () {

                                      },
                                      downloadNoteClick: () {


                                      },

                                      title: workingDocuments[index]['title'],
                                      desc: workingDocuments[index]['desc'],
                                      rate: workingDocuments[index]['like']
                                          .toString(),
                                      date: DateFormat('EE-MM-yyyy hh:mm:a').format(
                                          DateTime.parse(
                                              workingDocuments[index]['ts'])),
                                      //workingDocuments[index]['ts'],
                                      views: workingDocuments[index]['view']
                                          .toString(),
                                      comm: workingDocuments[index]['comm']
                                          .toString(),
                                      downloads: workingDocuments[index]['down']
                                          .toString(),
                                      note: workingDocuments[index]['ntc'].toString()

                                  ),

                                ],
                              ),

                              Divider(),


                              Text(
                                '${workingDocuments[index]['tcl']} ${workingDocuments[index]['tsl']}',
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
                                      onTap: () {
                                        checkFeedback(_documents[index]);
                                      },
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

                                    workingDocuments[index]['ass'] == true ?


                                    GestureDetector(

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
                                      onTap: () {
                                        _answerQuestions(_documents[index]);
                                      },
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

                                    workingDocuments[index]['note'] == null
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
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                ViewClassNote(
                                                    note: workingDocuments[index]['note'],
                                                    doc: _documents[index])));
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
              }),

          prog == true || _loadMoreProgress == true
              || _documents.length < SocialConstant.streamLength
              ?Text(''):
          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
              onTap: (){loadMore();},
              child: SvgPicture.asset('assets/classroom/load_more.svg',))
        ],
      ),
    );}


  void getResult() {
    try{
      FirebaseFirestore.instance.collectionGroup('schoolLessons')
          .where('tId',isEqualTo:  widget.doc['id'])
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {
    FirebaseFirestore.instance.collectionGroup('schoolLessons')
        .where('tId',isEqualTo:  widget.doc['id'])
        .orderBy('ts',descending: true)
       .startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length == 0) {
        setState(() {
          _loadMoreProgress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          _lastDocument = documents.last;

          setState(() {
            moreData = true;
            _documents.add(document);
            workingDocuments.add(document.data());

            moreData = false;
          });
        }
      }
    });
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
}
