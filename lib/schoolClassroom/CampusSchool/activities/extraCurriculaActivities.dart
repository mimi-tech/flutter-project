import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_socialText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_feedbacks.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/students_response.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:video_player/video_player.dart';

class ExtraCurriculaActivity extends StatefulWidget {
  ExtraCurriculaActivity({required this.doc});
  final DocumentSnapshot doc;
  @override
  _ExtraCurriculaActivityState createState() => _ExtraCurriculaActivityState();
}

class _ExtraCurriculaActivityState extends State<ExtraCurriculaActivity> {

  List<dynamic> extraClassDocs = <dynamic>[];

  var _documents = <DocumentSnapshot>[];

  bool progress = false;


  bool _loadMoreExtraClassesProgress = false;
  bool moreExtraClassesData = false;
  var _lastExtraClassesDocument;
  bool extraClassesProgress = false;

  String like = 'Liked by';
  String view = 'Viewed by';
  String videoDownload = 'Video DownLoaded by';
  String noteDownload = 'Note DownLoaded by';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScheduledLive();
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
      ListView.builder(
          itemCount: extraClassDocs.length,
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
                                    extraClassDocs[index]['tmb'] == null ? Container(
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
                                              .network(extraClassDocs[index]['vid']),
                                          looping: false,
                                        ),
                                      ),
                                    ) : Image.network(extraClassDocs[index]['tmb'],
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
                                                      UploadVariables.videoUrlSelected =
                                                      extraClassDocs[index]['vid'];
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  PlayingVideos()));
                                                    },
                                                    child: Icon(
                                                        Icons.play_arrow,
                                                        size: 40)))))
                                  ]),
                              SizedBox(
                                width: 5.0,
                              ),
                              TeacherSocialShowText(
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
                                  SchClassConstant.isLiked = false;
                                  SchClassConstant.isView = false;
                                  SchClassConstant.isDownload = true;
                                  SchClassConstant.isDownloadNote = false;
                                  _downloadLesson(_documents[index], videoDownload);
                                },

                                title: extraClassDocs[index]['title'],
                                desc: extraClassDocs[index]['desc'],
                                rate: extraClassDocs[index]['like'].toString(),
                                date: extraClassDocs[index]['ts'],
                                views: extraClassDocs[index]['view'].toString(),
                                comm: extraClassDocs[index]['comm'].toString(),
                                downloads: extraClassDocs[index]['down'].toString(),

                              ),

                            ],
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

                                extraClassDocs[index]['ass'] == true ?


                                GestureDetector(
                                  //onTap: (){_blockLesson(workingDocuments,index);},
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
                                  // onTap: (){_unBlockLesson(workingDocuments,index);},
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
                                  child: Text("Questions",
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

                                extraClassDocs[index]['note'] == null
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
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            ViewClassNote(
                                                note: extraClassDocs[index]['note'],
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



          extraClassesProgress == true || _loadMoreExtraClassesProgress == true
              || _documents.length < SocialConstant.streamLength
              ?Text(''):
          moreExtraClassesData == true? PlatformCircularProgressIndicator():GestureDetector(
              onTap: (){loadMoreExtraClass();},
              child: SvgPicture.asset('assets/classroom/load_more.svg',))



        ],
      ),
    );
  }

  void getScheduledLive() {


    ///getting the extra curricula class

    try{
      FirebaseFirestore.instance.collectionGroup('schoolSocials')
          .where('tId',isEqualTo:   widget.doc['id'])
          .where('schId',isEqualTo:  widget.doc['schId'])
          .where('tsl',isEqualTo:   widget.doc['lv'])
          .where('tcl',isEqualTo:   widget.doc['cl'])

          .orderBy('ts', descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          extraClassDocs.clear();
          for (DocumentSnapshot document in documents) {
            _lastExtraClassesDocument = documents.last;
            setState(() {
              extraClassDocs.add(document.data());
              _documents.add(document);
            });
          }
        }
      });


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }



  ///getting the extra class load more
  Future<void> loadMoreExtraClass() async {
    FirebaseFirestore.instance.collectionGroup('schoolSocials')
        .where('tId',isEqualTo:   widget.doc['id'])
        .where('schId',isEqualTo:  widget.doc['schId'])
        .where('tsl',isEqualTo:   widget.doc['lv'])
        .where('tcl',isEqualTo:   widget.doc['cl'])
        .orderBy('ts', descending: true).
    startAfterDocument(_lastExtraClassesDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length == 0) {
        setState(() {
          _loadMoreExtraClassesProgress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          _lastExtraClassesDocument = documents.last;

          setState(() {
            moreExtraClassesData = true;
            extraClassDocs.add(document.data());
            _documents.add(document);
            moreExtraClassesData = false;
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
  
  
  
  
  
  


