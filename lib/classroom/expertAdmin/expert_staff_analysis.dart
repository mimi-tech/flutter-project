import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courseAdmin/course_company/analysis_text.dart';

import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_appbar.dart';

class ExpertStaffAnalysis extends StatefulWidget {
  @override
  _ExpertStaffAnalysisState createState() => _ExpertStaffAnalysisState();
}

class _ExpertStaffAnalysisState extends State<ExpertStaffAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  int? total;

  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobar',
    'Novermber',
    'December'
  ];
  static var now = new DateTime.now();
  var currentMon = now.month;

  Widget spaceWidth() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAdminAppBar(),
            body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('expertCount')
                    .where('suid', isEqualTo: ExpertAdminConstants.currentUser)
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

                    return workingDocuments.length == 0
                        ? Center(
                            child: Text('You have not verfied any courses'))
                        : SingleChildScrollView(
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: workingDocuments.length,
                                itemBuilder: (context, int index) {
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
                                        spaceWidth(),
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
                                            workingDocuments[index]['vfd'] >= 3
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
                                    space(),
                                    space(),
                                    Divider(),
                                    DataTable(
                                      columnSpacing:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          'Periods',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: kFontsize.sp,
                                            color: kMaincolor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'No',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: kFontsize.sp,
                                            color: kMaincolor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ))
                                      ],
                                      rows: [
                                        DataRow(cells: [
                                          DataCell(
                                            Text(
                                              "Today",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kExpertColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              DateTime.now().day ==
                                                      workingDocuments[index]
                                                          ['day']
                                                  ? workingDocuments[index]
                                                          ['sed']
                                                      .toString()
                                                  : 'none',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kBlackcolor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text(
                                              kWeekly,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kExpertColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            Jiffy().week ==
                                                    workingDocuments[index]
                                                        ['wky']
                                                ? workingDocuments[index]['vfw']
                                                    .toString()
                                                : 'none',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              fontSize: kFontsize.sp,
                                              color: kBlackcolor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text(
                                              months[currentMon - 1],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kExpertColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            DateTime.now().month ==
                                                    workingDocuments[index]
                                                        ['mth']
                                                ? workingDocuments[index]['vfm']
                                                    .toString()
                                                : 'none',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              fontSize: kFontsize.sp,
                                              color: kBlackcolor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text(
                                              '$kYear ${DateTime.now().year}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kExpertColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            DateTime.now().year ==
                                                    workingDocuments[index]
                                                        ['yr']
                                                ? workingDocuments[index]['vfy']
                                                    .toString()
                                                : 'none',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              fontSize: kFontsize.sp,
                                              color: kBlackcolor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ]),
                                      ],
                                      sortColumnIndex: 1,
                                      sortAscending: true,
                                      dataRowHeight:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      dividerThickness: 5,
                                    ),
                                  ]);
                                }),
                          );
                  }
                })));
  }
}
