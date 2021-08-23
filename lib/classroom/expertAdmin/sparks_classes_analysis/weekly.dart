import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_second_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_top_appbar.dart';

import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/expertAdmin/classes_company.dart';
import 'package:sparks/classroom/expertAdmin/expert_analysis_count.dart';
import 'package:sparks/classroom/expert_class/expert_constants/round_profile.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class WeeklyClassesAnalysis extends StatefulWidget {
  @override
  _WeeklyClassesAnalysisState createState() => _WeeklyClassesAnalysisState();
}

class _WeeklyClassesAnalysisState extends State<WeeklyClassesAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  List<dynamic> noOfClasses = <dynamic>[];

  int? total;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AnalysisAppBar(),
            body: CustomScrollView(slivers: <Widget>[
              AnalysisSilverAppBar(
                matches: kSappbarcolor,
                friends: kStabcolor1,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('expertCount')
                        .where('yr', isEqualTo: DateTime.now().year)
                        .where('mth', isEqualTo: DateTime.now().month)
                        .where('wky', isEqualTo: Jiffy().week)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ProgressIndicatorState(),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          kSorryError2,
                          style: GoogleFonts.rajdhani(
                            fontSize: kFontsize.sp,
                            color: kFbColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                      } else {
                        final List<Map<String, dynamic>> workingDocuments =
                            snapshot.data as List<Map<String, dynamic>>;

                        return Column(children: <Widget>[
                          ClassesCompany(),
                          space(),
                          ClassCount(
                            count: workingDocuments.length,
                          ),
                          ExpertAnalysisCount(
                            name: kWeekly,
                            online: workingDocuments.length.toString(),
                            offLine: 0.toString(),
                          ),
                          workingDocuments.length == 0
                              ? NoStaffWorking(
                                  noStaff: '$kNoStaff this $kMonth',
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: workingDocuments.length,
                                  itemBuilder: (context, int index) {
                                    return Card(
                                      child: Column(children: <Widget>[
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(width: kImageRightShift.w),
                                            ImageScreen(
                                              image: workingDocuments[index]
                                                  ['pix'],
                                            ),
                                            SizedBox(width: kImageRightShift.w),
                                            Column(
                                              //mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  workingDocuments[index]['fn'],
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kNameSize.sp,
                                                    color: kFbColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  workingDocuments[index]['ln'],
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kNameSize.sp,
                                                    color: kFbColor,
                                                    fontWeight: FontWeight.w600,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: kSpaceHeight.h,
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Row(children: <Widget>[
                                              Container(
                                                  color: kSsprogressbar,
                                                  width: ScreenUtil()
                                                      .setWidth(targetWidth),
                                                  height: ScreenUtil()
                                                      .setHeight(targetHeight),
                                                  child: Center(
                                                    child: Text(
                                                      '${workingDocuments[index]['vfw'].toString()}',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: kFontsize.sp,
                                                        color: kBlackcolor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )),
                                              workingDocuments[index]['vfw'] >=
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
                                                              color:
                                                                  kBlackcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  : FlatButton(
                                                      color: kWhitecolor,
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                fontSize: 12.sp,
                                                                color:
                                                                    kBlackcolor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                            ])
                                          ],
                                        )
                                      ]),
                                    );
                                  }),
                        ]);
                      }
                    })
              ]))
            ])));
  }
}
