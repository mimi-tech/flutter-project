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
import 'package:sparks/classroom/expertAdmin/expert_admin_appbar.dart';
import 'package:sparks/classroom/expertAdmin/expert_analysis_count.dart';
import 'package:sparks/classroom/expertAdmin/expert_company_analysis/company_count.dart';
import 'package:sparks/classroom/expertAdmin/expert_onwer_company_analysis/owner_analysis_count.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertCompanyWeeklyAnalysis extends StatefulWidget {
  @override
  _ExpertCompanyWeeklyAnalysisState createState() =>
      _ExpertCompanyWeeklyAnalysisState();
}

class _ExpertCompanyWeeklyAnalysisState
    extends State<ExpertCompanyWeeklyAnalysis> {
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
            appBar: ExpertAdminAppBar(),
            body: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('expertCount')
                      .where('id', isEqualTo: AnalysisConstants.docId)
                      .where('yr', isEqualTo: DateTime.now().year)
                      .where('mth', isEqualTo: DateTime.now().month)
                      .where('wky', isEqualTo: Jiffy().week)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: ProgressIndicatorState(),
                      );
                    } else if ((!snapshot.hasData) &&
                        (snapshot.connectionState == ConnectionState.done)) {
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
                      // final logs = snapshot.data.documents;
                      for (var message in workingDocuments) {
                        final classes = message['vfw'];

                        noOfClasses.clear();

                        noOfClasses.add(classes);

                        total = noOfClasses.fold(
                            0,
                            ((previous, current) => previous + current as int?)
                                as int? Function(int?, dynamic));
                      }

                      return Column(children: <Widget>[
                        OnwerCompanyCount(),
                        space(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                kAdminLog2.toUpperCase() +
                                    '(${total.toString()})',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  color: kFbColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SvgPicture.asset(
                                'images/classroom/classes.svg',
                              ),
                            ],
                          ),
                        ),
                        ExpertCompanyAnalysisCount(
                          name: kWeekly,
                          online: workingDocuments.length.toString(),
                          offLine: 0.toString(),
                        ),
                        workingDocuments.length == 0
                            ? NoStaffWorking(
                                noStaff: kNoStaff,
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: workingDocuments.length,
                                itemBuilder: (context, int index) {
                                  return Column(children: <Widget>[
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 32,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: workingDocuments[index]
                                                  ['pix'],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                              width: kPixWidth,
                                              height: kPixHeight,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              workingDocuments[index]['fn'],
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kNameSize.sp,
                                                color: kBlackcolor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              workingDocuments[index]['ln'],
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kNameSize.sp,
                                                color: kBlackcolor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              workingDocuments[index]['comN']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kCompName.sp,
                                                color: kBlackcolor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
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
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.w500,
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
                                                          color: kBlackcolor,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontSize: 12.sp,
                                                            color: kBlackcolor,
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
                                  ]);
                                }),
                      ]);
                    }
                  }),
            )));
  }
}
