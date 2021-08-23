import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/course_widget/add.dart';
import 'package:sparks/classroom/contents/course_widget/add_sections.dart';
import 'package:sparks/classroom/contents/course_widget/divider.dart';
import 'package:sparks/classroom/contents/course_widget/edit_lecture_video.dart';
import 'package:sparks/classroom/contents/course_widget/section_attachment_edit.dart';

import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';
import 'package:sparks/classroom/contents/course_widget/section_icons.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/live/courses.dart';

import 'package:sparks/classroom/contents/live/delete_dialog.dart';

import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/social/socialConstants/PlayingSocialVideos.dart';
import 'package:sparks/social/socialConstants/reaction_play_video.dart';
import 'package:sparks/social/socialCourse/cc_appbar.dart';
import 'package:video_player/video_player.dart';

class SocialSectionCourse extends StatefulWidget {

  final List<Section> currentSections;
  final Course currentLectures;
  final int currentIndexOfLectures;
  final String lectureName;
  final DocumentSnapshot doc;

  SocialSectionCourse({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.lectureName,
    required this.doc,
  });

  @override
  _SocialSectionCourseState createState() => _SocialSectionCourseState(
    currentLectures: currentLectures,
    currentIndexOfLectures: currentIndexOfLectures,
    currentSections: currentSections,
  );
}

class _SocialSectionCourseState extends State<SocialSectionCourse> {
  List<Section> currentSections;
  Course currentLectures;
  int currentIndexOfLectures;

  _SocialSectionCourseState({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
  });
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      UploadVariables.videoUrlSelected = widget.currentSections[0].vido;
    });
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(

        appBar: CcAppBar(
          text4: 'A course on',
          text1: widget.doc['topic'],
          text2: widget.doc['fn'],
          text3: widget.doc['ln'],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: ScreenUtil().setWidth(200.0),
                child: Card(
                  elevation: 20.0,
                  child: Center(
                    child: Text('Lecture ${(currentIndexOfLectures + 1).toString()}',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFbColor,
                            fontSize: kTwentyTwo.sp,
                          ),
                        )
                    ),
                  ),
                ),
              ),


              ListView.builder(
                itemCount: currentSections.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int index) {

                  return buildSection(index: index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({int? index}) {
    return SingleChildScrollView(
      child: Container(
        //height:ScreenUtil().setHeight(150),

        child: Card(
            elevation: 20,
            child: Column(
              children: <Widget>[

                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Column(
                      children: <Widget>[
                        Text('Section ${index! + 1}',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kFbColor,
                                fontSize: kTwentyTwo.sp,
                              ),
                            )
                        ),



                        Stack(
                            alignment: Alignment.center,

                            children: <Widget>[
                          Container(
                            height:MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ShowUploadedVideo(
                              videoPlayerController: VideoPlayerController.network(widget.doc['prom']),
                              looping: false,
                            ),
                          ),
                          Align(
                            child: ButtonTheme(
                              //height: 50,
                                shape: CircleBorder(),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    child: GestureDetector(
                                        onTap: () {
                                          UploadVariables.videoUrlSelected = widget.currentSections[index].vido;
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialCCVideos()));

                                        },
                                        child: Icon(Icons.play_arrow, size: 40)))),
                          )
                        ]),
                      ],
                    ),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(150),
                        minHeight: ScreenUtil().setHeight(10),
                      ),
                      child: ReadMoreText(
                        widget.currentSections[index].title.toString(),
                        trimLines: 3,
                        colorClickableText: kFbColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' ...',
                        trimExpandedText: 'show les',
                        style:GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kBlackcolor,
                            fontSize:kFontsize.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),






              ],
            )),
      ),
    );
  }


  }


