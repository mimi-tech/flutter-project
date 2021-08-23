import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar_second.dart';
import 'package:sparks/classroom/courseAdmin/course_company/analysis_count.dart';
import 'package:sparks/classroom/courseAdmin/course_company/analysis_text.dart';

import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';

import 'package:sparks/classroom/courseAnalysis/companyAnalysis/selection.dart';
import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/expert_class/expert_constants/round_profile.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CompanyAnalysis extends StatefulWidget {
  @override
  _CompanyAnalysisState createState() => _CompanyAnalysisState();
}

class _CompanyAnalysisState extends State<CompanyAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  List<dynamic> loginCount = <dynamic>[];
  List<dynamic> logOutCount = <dynamic>[];
  int? total;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CourseAdminAppBar(),
            body: CustomScrollView(slivers: <Widget>[
              CourseSilverAppBar(
                matches: kSappbarcolor,
                friends: kSappbarcolor,
                classroom: kStabcolor1,
                content: kSappbarcolor,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('companyVerifiedCoursesCount')
                      .where('id',
                          isEqualTo: CourseAdminConstants.adminData[0]['id'])
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
                      // final List<DocumentSnapshot> workingDocuments =
                      //     snapshot.data.documents;
                      final List<Map<String, dynamic>> workingDocuments =
                          snapshot.data as List<Map<String, dynamic>>;

                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  kAdminLog.toUpperCase() +
                                      '(${total.toString()})',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: kFontsize.sp,
                                    color: kFbColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'images/classroom/courses.svg',
                                ),
                              ],
                            ),
                          ),
                          CompanyAnalysisCount(
                            name: kAnalysis,
                            online: loginCount.length.toString(),
                            offLine: logOutCount.length.toString(),
                          ),
                          workingDocuments.length == 0
                              ? NoStaffWorking(
                                  noStaff:
                                      '$kNoStaff in ${AnalysisConstants.companyName} $kDaily')
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: workingDocuments.length,
                                  itemBuilder: (context, int index) {
                                    return Card(
                                      elevation: 20,
                                      child: Column(
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
                                                                ),
                                                              ),
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
                                                              children: <
                                                                  Widget>[
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
                                                                SvgPicture
                                                                    .asset(
                                                                  'images/classroom/grey_dot.svg',
                                                                ),
                                                                SizedBox(
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            kDotHeight2)),
                                                              ],
                                                            )),
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
                                          Divider(),
                                          AnalysisText(
                                            seenDaily: workingDocuments[index]
                                                    ['sed']
                                                .toString(),
                                            verifyDaily: workingDocuments[index]
                                                    ['vfd']
                                                .toString(),
                                            seenWeekly: workingDocuments[index]
                                                    ['sew']
                                                .toString(),
                                            verifyWeekly:
                                                workingDocuments[index]['vfw']
                                                    .toString(),
                                            seenMonthly: workingDocuments[index]
                                                    ['semth']
                                                .toString(),
                                            verifyMonthly:
                                                workingDocuments[index]['vfm']
                                                    .toString(),
                                            seenYearly: workingDocuments[index]
                                                    ['sey']
                                                .toString(),
                                            verifyYearly:
                                                workingDocuments[index]['vfy']
                                                    .toString(),
                                          ),
                                          Divider(),
                                          Spacer(),
                                          workingDocuments[index]['lg'] == true
                                              ? RichText(
                                                  text: TextSpan(
                                                      text: 'Login ',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: kFontsize.sp,
                                                        color: kBlackcolor,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${workingDocuments[index]['li'].toString()}',
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontSize:
                                                                kFontsize.sp,
                                                            color: kMaincolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                          text: 'Login ',
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontSize:
                                                                kFontsize.sp,
                                                            color: kBlackcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '${workingDocuments[index]['li'].toString()}',
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                fontSize:
                                                                    kFontsize
                                                                        .sp,
                                                                color:
                                                                    kMaincolor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'LogOut ',
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontSize:
                                                              kFontsize.sp,
                                                          color: kBlackcolor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                '${workingDocuments[index]['lo'].toString()}',
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontSize:
                                                                  kFontsize.sp,
                                                              color: kMaincolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          Spacer(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ],
                      );
                    }
                  },
                )
              ]))
            ])));
  }
}
