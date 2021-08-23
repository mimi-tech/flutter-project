import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar_second.dart';
import 'package:sparks/classroom/courseAdmin/course_company/analysis_count.dart';
import 'package:sparks/classroom/courseAdmin/course_company/analysis_text.dart';

import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';

import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class StaffAnalysis extends StatefulWidget {
  @override
  _StaffAnalysisState createState() => _StaffAnalysisState();
}

class _StaffAnalysisState extends State<StaffAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  int? total;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CourseAdminAppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
            CourseSilverAppBar(
              matches: kSappbarcolor,
              friends: kSappbarcolor,
              classroom: kStabcolor1,
              content: kSappbarcolor,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('companyVerifiedCoursesCount')
                        .where('suid',
                            isEqualTo: CourseAdminConstants.currentUser)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ProgressIndicatorState(),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          'You have not verified any courses',
                          style: GoogleFonts.rajdhani(
                            fontSize: kFontsize.sp,
                            color: kExpertColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ));
                      } else {
                        final List<Map<String, dynamic>> workingDocuments =
                            snapshot.data as List<Map<String, dynamic>>;

                        return workingDocuments.length == 0
                            ? Center(
                                child:
                                    Text('You have not verified any courses'))
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: workingDocuments.length,
                                itemBuilder: (context, int index) {
                                  DateTime todayDate = DateTime.parse(
                                      '2020-07-19 15:59:50.023329');

                                  final now = DateTime.now();
                                  final today =
                                      DateTime(now.year, now.month, now.day);

                                  //final aDateTime = ...
                                  // var dateToCheck;
                                  final aDate = DateTime(todayDate.year,
                                      todayDate.month, todayDate.day);
                                  return Column(children: <Widget>[
                                    space(),
                                    Row(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          imageUrl: workingDocuments[index]
                                              ['pix'],
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                workingDocuments[index]['fn']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kNameSize.sp,
                                                  color: kExpertColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                workingDocuments[index]['comN']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kCompName.sp,
                                                  color: kBlackcolor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            workingDocuments[index]['vfd'] >=
                                                    AnalysisConstants.target
                                                ? FlatButton(
                                                    color: kSsprogressbar,
                                                    onPressed: () {},
                                                    child: Column(
                                                      children: <Widget>[
                                                        SvgPicture.asset(
                                                          'images/classroom/good.svg',
                                                        ),
                                                        Text(
                                                          'Target\n Reached',
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontSize: 12.sp,
                                                            color: kBlackcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                : FlatButton(
                                                    color: klistnmber,
                                                    onPressed: () {},
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.close,
                                                          color: kFbColor,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            'Target\n Not Reached',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontSize:
                                                                  kFontsize.sp,
                                                              color:
                                                                  kWhitecolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                          ],
                                        ),
                                      ],
                                    ),
                                    AnalysisText(
                                      seenDaily: DateTime.now().day ==
                                              workingDocuments[index]['day']
                                          ? workingDocuments[index]['sed']
                                              .toString()
                                          : 'none',
                                      verifyDaily: DateTime.now().day ==
                                              workingDocuments[index]['day']
                                          ? workingDocuments[index]['vfd']
                                              .toString()
                                          : 'none',
                                      seenWeekly: Jiffy().week ==
                                              workingDocuments[index]['wky']
                                          ? workingDocuments[index]['sew']
                                              .toString()
                                          : 'none',
                                      verifyWeekly: Jiffy().week ==
                                              workingDocuments[index]['wky']
                                          ? workingDocuments[index]['vfw']
                                              .toString()
                                          : 'none',
                                      seenMonthly: DateTime.now().month ==
                                              workingDocuments[index]['mth']
                                          ? workingDocuments[index]['semth']
                                              .toString()
                                          : 'none',
                                      verifyMonthly: DateTime.now().month ==
                                              workingDocuments[index]['mth']
                                          ? workingDocuments[index]['vfm']
                                              .toString()
                                          : 'none',
                                      seenYearly: DateTime.now().year ==
                                              workingDocuments[index]['yr']
                                          ? workingDocuments[index]['sey']
                                              .toString()
                                          : 'none',
                                      verifyYearly: DateTime.now().year ==
                                              workingDocuments[index]['yr']
                                          ? workingDocuments[index]['vfy']
                                              .toString()
                                          : 'none',
                                    ),
                                    Divider(),
                                  ]);
                                });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
