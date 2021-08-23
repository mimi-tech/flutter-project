import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';

import 'package:sparks/classroom/contents/course_widget/section_course_edit.dart';

import 'package:sparks/classroom/courseAdmin/course_admin_appbar.dart';
import 'package:sparks/classroom/courseAdmin/sections.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewCourses extends StatefulWidget {
  @override
  _ViewCoursesState createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  var itemsData = [];
  var items = [];
  var showData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    itemsData.clear();
  }

  var _documents = [];
  Course globalLectures = Course();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: EditAdminCourseAppBar(
          title: CourseAdminConstants.courseAdminName,
          pix: CourseAdminConstants.courseAdminPix,
        ),
        body: _documents.length == 0
            ? ProgressIndicatorState()
            : SingleChildScrollView(
                child: Column(
                  children: _documents.map((doc) {
                    List<dynamic> loadVideos = doc['lectures'];

                    Course lectures = Course();

                    int? prevLectureCount;

                    int? currLectureCount;

                    loadVideos.sort((a, b) {
                      return a['lecture'][0]['Lcount']
                          .compareTo(b['lecture'][0]['Lcount']);
                    });

                    for (int i = 0; i < loadVideos.length; i++) {
                      List<dynamic> section = loadVideos[i]['lecture'];

                      Lecture sLecture = Lecture();

                      Section sSection = Section();

                      sSection.vido = section[0]['vido'];
                      sSection.sectionCount = section[0]['Sc'];
                      sSection.title = section[0]['title'];
                      sSection.at = section[0]['at'];
                      sSection.name = section[0]['name'];
                      sSection.lCount = section[0]['Lcount'];

                      if (i == 0) {
                        currLectureCount = section[0]['Lcount'];

                        sLecture.index = currLectureCount;

                        sLecture.sectionLength = 1;

                        sLecture.sections.add(sSection);

                        lectures.lectures.add(sLecture);
                      } else {
                        prevLectureCount =
                            loadVideos[i - 1]['lecture'][0]['Lcount'];

                        currLectureCount =
                            loadVideos[i]['lecture'][0]['Lcount'];

                        int? lCount = loadVideos[i]['lecture'][0]['Lcount'];

                        if (currLectureCount == prevLectureCount) {
                          lectures.lectures[lCount! - 1].sections.add(sSection);

                          lectures.lectures[lCount - 1].sectionLength++;
                        } else {
                          if (lectures.lectures.length < lCount!) {
                            sLecture.index = currLectureCount;

                            sLecture.sectionLength = 1;

                            sLecture.sections.add(sSection);

                            lectures.lectures.add(sLecture);
                          } else {
                            lectures.lectures[lCount].sections.add(sSection);

                            lectures.lectures[lCount].sectionLength++;
                          }
                        }
                      }
                    }

                    globalLectures = lectures;

                    return Column(children: <Widget>[
                      Container(
                        child: ListView.builder(
                            itemCount: lectures.lectures.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, int index) {
                              //return Text('we are here');

                              return Container(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      CourseAdminConstants.lectureSelectedIndex
                                          .clear();
                                      CourseAdminConstants.lectureSelectedIndex
                                          .add(index);
                                    });
                                    final value =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CourseAdminSections(
                                          currentSections:
                                              lectures.lectures[index].sections,
                                          currentLectures: lectures,
                                          currentIndexOfLectures: index,
                                          lectureName: lectures
                                              .lectures[index].sections[0].name,
                                        ),
                                      ),
                                    );

                                    if (value != null && value == 'Done') {
                                      getData();
                                    }
                                  },
                                  child: Card(
                                      color: CourseAdminConstants
                                              .lectureSelectedIndex
                                              .contains(index)
                                          ? Colors.white70
                                          : kWhitecolor,
                                      elevation: 20,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 20),
                                          SizedBox(width: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Lecture ${index + 1}',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kExpertColor,
                                                          fontSize:
                                                              kTwentyTwo.sp,
                                                        ),
                                                      )),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: ScreenUtil()
                                                          .setWidth(
                                                              constrainedReadMore),
                                                      minHeight: ScreenUtil()
                                                          .setHeight(
                                                              constrainedReadMoreHeight),
                                                    ),
                                                    child: ReadMoreText(
                                                      '${lectures.lectures[index].sections[0].name}',
                                                      trimLines: 2,
                                                      colorClickableText:
                                                          Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: ' ...',
                                                      trimExpandedText:
                                                          'show less',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kBlackcolor,
                                                          fontSize:
                                                              kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RaisedButton(
                                                  color: kFbColor,
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseAdminSections(
                                                          currentSections:
                                                              lectures
                                                                  .lectures[
                                                                      index]
                                                                  .sections,
                                                          currentLectures:
                                                              lectures,
                                                          currentIndexOfLectures:
                                                              index,
                                                          lectureName: lectures
                                                              .lectures[index]
                                                              .sections[0]
                                                              .name,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    lectures.lectures[index]
                                                            .sections.length
                                                            .toString() +
                                                        " " +
                                                        'sections',
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kWhitecolor,
                                                        fontSize: kFontsize.sp,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(height: 20),
                                        ],
                                      )),
                                ),
                              );
                            }),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
      ),
    );
  }

  void getData() {
    try {
      FirebaseFirestore.instance
          .collectionGroup('courses')
          .where('id', isEqualTo: CourseAdminConstants.courseAdminDocId)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          setState(() {
            /*_documents.clear();
            showData.clear();*/
            _documents.add(result);
            showData.add(result.data());
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
