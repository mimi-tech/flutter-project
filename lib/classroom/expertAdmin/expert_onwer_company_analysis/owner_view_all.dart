import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';

import 'package:sparks/classroom/courseAnalysis/analysis_second_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_top_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_appbar.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class OwnerViewAllClasses extends StatefulWidget {
  @override
  _OwnerViewAllClassesState createState() => _OwnerViewAllClassesState();
}

class _OwnerViewAllClassesState extends State<OwnerViewAllClasses> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAdminAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collectionGroup('details')
                          .where('id', isEqualTo: AnalysisConstants.docId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: ProgressIndicatorState(),
                          );
                        } else if ((!snapshot.hasData) &&
                            (snapshot.connectionState ==
                                ConnectionState.done)) {
                          return Center(child: Text(kNoClasses));
                        } else {
                          final List<Map<String, dynamic>> workingDocuments =
                              snapshot.data as List<Map<String, dynamic>>;
                          return workingDocuments.length == 0
                              ? NoStaffWorking(noStaff: kNoClasses)
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: workingDocuments.length,
                                  itemBuilder: (context, int index) {
                                    return Column(children: <Widget>[
                                      Card(
                                        elevation: 20,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 32,
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          workingDocuments[
                                                              index]['pix'],
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                      width: kPixWidth,
                                                      height: kPixHeight,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  workingDocuments[index]['fn']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Company: ',
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kFbColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  workingDocuments[index]
                                                      ['comN'],
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Topic: ',
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kFbColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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
                                                    workingDocuments[index]
                                                        ['tp'],
                                                    trimLines: 2,
                                                    colorClickableText:
                                                        Colors.pink,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText: ' ...',
                                                    trimExpandedText: ' less',
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontsize.sp,
                                                      color: kBlackcolor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Date: ',
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kFbColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  workingDocuments[index]
                                                          ['date']
                                                      .toString(),
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: kFontsize.sp,
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(10),
                                            )
                                          ],
                                        ),
                                      )
                                    ]);
                                  });
                        }
                      })
                ],
              ),
            )));
  }
}
