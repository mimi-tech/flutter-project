import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';

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

class AllClassesAnalysis extends StatefulWidget {
  @override
  _AllClassesAnalysisState createState() => _AllClassesAnalysisState();
}

class _AllClassesAnalysisState extends State<AllClassesAnalysis> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  List<dynamic> noOfClasses = <dynamic>[];
  var itemsData = [];
  var _documents = [];
  List<DocumentSnapshot>? workingDocuments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmins();
  }

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
                        .where('day', isEqualTo: DateTime.now().day)
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
                            name: kDaily,
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
                                                      '${workingDocuments[index]['vfd'].toString()}',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: kFontsize.sp,
                                                        color: kBlackcolor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )),
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

  Future<void> getAdmins() async {
    CourseAdminConstants.courseAdminLogin.clear();
    CourseAdminConstants.courseAdminLogout.clear();
    CourseAdminConstants.courseDoc.clear();
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('CourseAdmin').get();

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
