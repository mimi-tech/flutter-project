import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_company.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_second_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_top_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/companyAnalysis/selection.dart';
import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/expert_class/expert_constants/round_profile.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class DailyCompanyCoursesAnalysis extends StatefulWidget {
  @override
  _DailyCompanyCoursesAnalysisState createState() =>
      _DailyCompanyCoursesAnalysisState();
}

class _DailyCompanyCoursesAnalysisState
    extends State<DailyCompanyCoursesAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  var itemsData = [];
  var _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AnalysisAppBar(),
            body: CustomScrollView(slivers: <Widget>[
              AnalysisSilverAppBar(
                matches: kStabcolor1,
                friends: kSappbarcolor,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                AnalysisCompany(),
                space(),
                CourseCount(
                  count: CourseAdminConstants.courseDoc.length,
                ),
                SelectionCount(
                  name: kDaily,
                  online:
                      CourseAdminConstants.courseAdminLogin.length.toString(),
                  offLine:
                      CourseAdminConstants.courseAdminLogout.length.toString(),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('companyVerifiedCoursesCount')
                        .where('id', isEqualTo: AnalysisConstants.docId)
                        .where('yr', isEqualTo: DateTime.now().year)
                        .where('mth', isEqualTo: DateTime.now().month)
                        .where('day', isEqualTo: DateTime.now().day)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ProgressIndicatorState(),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: NoContentCreated(
                          title: kNoCourseVerified,
                        ));
                      } else {
                        final List<Map<String, dynamic>> workingDocuments =
                            snapshot.data as List<Map<String, dynamic>>;

                        return Card(
                          child: Column(children: <Widget>[
                            workingDocuments.length == 0
                                ? NoStaffWorking(
                                    noStaff:
                                        '$kNoStaff in ${AnalysisConstants.companyName} $kDaily',
                                  )
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: workingDocuments.length,
                                    itemBuilder: (context, int index) {
                                      return Column(
                                        children: <Widget>[
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                  width: kImageRightShift.w),
                                              ImageScreen(
                                                image: workingDocuments[index]
                                                    ['pix'],
                                              ),
                                              SizedBox(
                                                  width: kImageRightShift.w),
                                              Column(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    workingDocuments[index]
                                                        ['fn'],
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kNameSize.sp,
                                                      color: kFbColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    workingDocuments[index]
                                                        ['ln'],
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kNameSize.sp,
                                                      color: kFbColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    workingDocuments[index]
                                                            ['comN']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kCompName.sp,
                                                      color: kBlackcolor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: kSpaceHeight.h,
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              workingDocuments[index]['lg'] ==
                                                      true
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          color: kSsprogressbar,
                                                          onPressed: () {},
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                '${workingDocuments[index]['sed'].toString()} : ${workingDocuments[index]['vfd'].toString()}',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  fontSize:
                                                                      kFontsize
                                                                          .sp,
                                                                  color:
                                                                      kBlackcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          kDotHeight2)),
                                                              SvgPicture.asset(
                                                                'images/classroom/green_dot.svg',
                                                              ),
                                                              SizedBox(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          kDotHeight2)),
                                                            ],
                                                          ),
                                                        ),
                                                        workingDocuments[index]
                                                                    ['vfd'] >=
                                                                AnalysisConstants
                                                                    .target
                                                            ? FlatButton(
                                                                color:
                                                                    kSsprogressbar,
                                                                onPressed:
                                                                    () {},
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                      'images/classroom/good.svg',
                                                                    ),
                                                                    Text(
                                                                      'Target\n Reached',
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color:
                                                                            kBlackcolor,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                            : FlatButton(
                                                                color:
                                                                    kWhitecolor,
                                                                onPressed:
                                                                    () {},
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .close,
                                                                      color:
                                                                          kFbColor,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        'Target\n Not Reached',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .rajdhani(
                                                                          fontSize:
                                                                              12.sp,
                                                                          color:
                                                                              kBlackcolor,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          color: kWhitecolor,
                                                          onPressed: () {},
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                '${workingDocuments[index]['sed'].toString()} : ${workingDocuments[index]['vfd'].toString()}',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  fontSize:
                                                                      kFontsize
                                                                          .sp,
                                                                  color:
                                                                      kBlackcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          kDotHeight2)),
                                                              SvgPicture.asset(
                                                                'images/classroom/grey_dot.svg',
                                                              ),
                                                              SizedBox(
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          kDotHeight2)),
                                                            ],
                                                          ),
                                                        ),
                                                        workingDocuments[index]
                                                                    ['vfd'] >=
                                                                AnalysisConstants
                                                                    .target
                                                            ? FlatButton(
                                                                color:
                                                                    kSsprogressbar,
                                                                onPressed:
                                                                    () {},
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                      'images/classroom/good.svg',
                                                                    ),
                                                                    Text(
                                                                      'Target\n Reached',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color:
                                                                            kBlackcolor,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                            : FlatButton(
                                                                color:
                                                                    kLightGrey,
                                                                onPressed:
                                                                    () {},
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .close,
                                                                      color:
                                                                          kFbColor,
                                                                    ),
                                                                    Text(
                                                                      ' Not Reached \n ${workingDocuments[index]['time'].toString()}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color:
                                                                            kBlackcolor,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                          ]),
                        );
                      }
                    })
              ]))
            ])));
  }

  Future<void> getAdmins() async {
    CourseAdminConstants.courseAdminLogin.clear();
    CourseAdminConstants.courseAdminLogout.clear();
    CourseAdminConstants.courseDoc.clear();
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('CourseAdmin')
          .where('id', isEqualTo: AnalysisConstants.docId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
      } else {
        for (DocumentSnapshot document in documents) {
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());
            CourseAdminConstants.courseDoc.add(document);
            // PageConstants.getCompanies.clear();
          });
        }
      }

      CourseAdminConstants.courseAdminLogin =
          itemsData.where((element) => element['lg'] == true).toList();
      CourseAdminConstants.courseAdminLogout =
          itemsData.where((element) => element['lg'] == false).toList();
    } catch (e) {
      // return CircularProgressIndicator();
    }
  }
}
