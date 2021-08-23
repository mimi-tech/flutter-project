import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_teacher_feedback.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_feedbacks.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/students_response.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_show_text.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_show_text.dart';

import 'package:video_player/video_player.dart';

class SocialClassSearchStream extends StatefulWidget {
  @override
  _SocialClassSearchStreamState createState() => _SocialClassSearchStreamState();
}

class _SocialClassSearchStreamState extends State<SocialClassSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  String like = 'Liked by';
  String view = 'Viewed by';
  String videoDownload = 'Video DownLoaded by';
  String noteDownload = 'Note DownLoaded by';
  List <dynamic>? aoi;
  List <dynamic>? spec;
  List <dynamic>? hobby;
  List <dynamic>? lang;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SchClassConstant().searchBySocialName(value).then((QuerySnapshot docs) {
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

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for a social class',
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        body: CustomScrollView(
            slivers: <Widget>[
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
                    onChanged: (dynamic val) {
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

                    tempSearchStore.length == 0?Text('empty'):
                    ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {


                          return  Card(
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
                                                  tempSearchStore[index]['tmb'] == null? Container(
                                                    width:MediaQuery.of(context).size.width * 0.3,
                                                    height:MediaQuery.of(context).size.width * 0.5,
                                                    child: Center(
                                                      child: ShowUploadedVideo(
                                                        videoPlayerController: VideoPlayerController.network(tempSearchStore[index]['vid']),
                                                        looping: false,
                                                      ),
                                                    ),
                                                  ):Image.network(tempSearchStore[index]['tmb'],
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
                                                                    UploadVariables.videoUrlSelected = tempSearchStore[index]['vid'];
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

                                                  _likeLesson(tempSearchStore[index],like);
                                                },

                                                viewClick: (){
                                                  SchClassConstant.isLiked = false;
                                                  SchClassConstant.isView = true;
                                                  SchClassConstant.isDownload = false;
                                                  SchClassConstant.isDownloadNote = false;
                                                  _viewLesson(tempSearchStore[index],view);

                                                },

                                                feedClick: (){ checkFeedback(tempSearchStore[index]);
                                                },

                                                downloadClick: (){
                                                  SchClassConstant.isLiked = false;
                                                  SchClassConstant.isView = false;
                                                  SchClassConstant.isDownload = true;
                                                  SchClassConstant.isDownloadNote = false;
                                                  _downloadLesson(tempSearchStore[index],videoDownload);

                                                },
                                                downloadNoteClick: (){
                                                  SchClassConstant.isLiked = false;
                                                  SchClassConstant.isView = false;
                                                  SchClassConstant.isDownload = false;
                                                  SchClassConstant.isDownloadNote = true;
                                                  _downloadNoteLesson(tempSearchStore[index],noteDownload);

                                                },

                                                title: tempSearchStore[index]['title'],
                                                desc: tempSearchStore[index]['desc'],
                                                rate: tempSearchStore[index]['like'].toString(),
                                                date: tempSearchStore[index]['ts'],
                                                views: tempSearchStore[index]['view'].toString(),
                                                comm: tempSearchStore[index]['comm'].toString(),
                                                downloads: tempSearchStore[index]['down'].toString(), note: '',

                                            ),

                                          ],
                                        ),

                                        Divider(),
                                        Text(tempSearchStore[index]['tfn'],
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBlackcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),

                                        Text('${tempSearchStore[index]['tcl']} ${tempSearchStore[index]['tsl']}',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kMaincolor,
                                              fontSize: kFontSize14.sp,
                                            ),
                                          ),

                                        ),
                                        Divider(),

                                        IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap:(){checkFeedback(tempSearchStore[index]);},
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

                                              tempSearchStore[index]['ass'] == true?


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
                                                onTap: (){_answerQuestions(tempSearchStore[index]);},
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

                                             /* tempSearchStore[index]['note'] == null
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
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewClassNote(note:tempSearchStore[index]['note'],doc:tempSearchStore[index])));

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
*/
                                              GestureDetector(
                                                onTap: (){
                                                  _reportTeacher(tempSearchStore[index]);
                                                },
                                                child: Text('Report',
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




                        })])
              )])
    ));
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




  void _reportTeacher(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return AdminTeachersFeedback(doc:doc);
        });
  }

}

