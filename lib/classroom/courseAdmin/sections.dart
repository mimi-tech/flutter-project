import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';

import 'package:readmore/readmore.dart';

import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';

import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_appbar.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/show_pdf.dart';

import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:video_player/video_player.dart';

class CourseAdminSections extends StatefulWidget {
  final List<Section> currentSections;
  final Course currentLectures;
  final int currentIndexOfLectures;
  final String? lectureName;

  CourseAdminSections({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.lectureName,
  });

  @override
  _CourseAdminSectionsState createState() => _CourseAdminSectionsState(
        currentLectures: currentLectures,
        currentIndexOfLectures: currentIndexOfLectures,
        currentSections: currentSections,
      );
}

class _CourseAdminSectionsState extends State<CourseAdminSections> {
  List<Section>? currentSections;
  Course? currentLectures;
  int? currentIndexOfLectures;

  _CourseAdminSectionsState({
    this.currentLectures,
    this.currentIndexOfLectures,
    this.currentSections,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: EditAdminCourseAppBar(
          title: CourseAdminConstants.courseAdminName,
          pix: CourseAdminConstants.courseAdminPix,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(50.0),
                margin: EdgeInsets.symmetric(vertical: 10),
                width: ScreenUtil().setWidth(200.0),
                child: Card(
                  elevation: 20.0,
                  child: Center(
                    child: Text(
                        'Lecture ${(currentIndexOfLectures! + 1).toString()}',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFbColor,
                            fontSize: kTwentyTwo.sp,
                          ),
                        )),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: currentSections!.length,
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

  Widget buildSection({required int index}) {
    return SingleChildScrollView(
      child: Container(
        //height:ScreenUtil().setHeight(150),

        child: Card(
            elevation: 20,
            child: Column(
              children: <Widget>[
                widget.currentSections[index].at == null
                    ? Container()
                    : Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: kFbColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.topToBottom,
                                        child: ShowPdf(
                                            userPdf: widget
                                                .currentSections[index].at)));
                              },
                              child: Text(
                                '1',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  color: kWhitecolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Column(
                      children: <Widget>[
                        Text('Section ${index + 1}',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kExpertColor,
                                fontSize: kTwentyTwo.sp,
                              ),
                            )),
                        Stack(alignment: Alignment.center, children: <Widget>[
                          Container(
                            //height:MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ShowUploadedVideo(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                      widget.currentSections[index].vido!),
                              looping: false,
                            ),
                          ),
                          Container(
                            //height:MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ButtonTheme(
                                //height: 50,
                                shape: CircleBorder(),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    child: GestureDetector(
                                        onTap: () {
                                          UploadVariables.videoUrlSelected =
                                              widget
                                                  .currentSections[index].vido;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayingVideos()));
                                        },
                                        child:
                                            Icon(Icons.play_arrow, size: 40)))),
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
                        widget.currentSections[index].title!,
                        trimLines: 2,
                        colorClickableText: kFbColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' ...',
                        trimExpandedText: 'show les',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kBlackcolor,
                            fontSize: kFontsize.sp,
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
