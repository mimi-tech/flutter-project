import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/courseAnalysis/companyAnalysis/daily.dart';
import 'package:sparks/classroom/courseAnalysis/view_courses.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AnalysisCompany extends StatefulWidget {
  @override
  _AnalysisCompanyState createState() => _AnalysisCompanyState();
}

class _AnalysisCompanyState extends State<AnalysisCompany> {
  var itemsData = [];
  var _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourseCompany();
  }

  @override
  Widget build(BuildContext context) {
    return _documents.length == 0
        ? Center(child: CircularProgressIndicator())
        : Column(children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SvgPicture.asset(
                    'images/classroom/add_circle.svg',
                  ),
                  Text(
                    kCourseParternship.toUpperCase() +
                        '(${_documents.length.toString()})',
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kFbColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        AnalysisConstants.companyName = null;
                      });
                    },
                    child: Text(
                      'View all',
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kExpertColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 40.0,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _documents.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: OutlineButton(
                              onPressed: () {
                                getCompanyDocId(
                                    context, _documents[Index], Index);
                              },
                              child: Text(
                                itemsData[Index]['name'].toUpperCase(),
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                  color: kBlackcolor,
                                ),
                              ),
                            ),
                          ));
                    }))
          ]);
  }

  void getCourseCompany() {
    FirebaseFirestore.instance
        .collectionGroup('courseCompany')
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          /* itemsData.clear();
          _documents.clear();*/
          _documents.add(result);
          itemsData.add(result.data());
        });
      });
    });
  }

  void getCompanyDocId(
      BuildContext context, DocumentSnapshot document, int index) {
    setState(() {
      AnalysisConstants.docId = document.id;
      AnalysisConstants.companyName = itemsData[index]['name'];
    });
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DailyCompanyCoursesAnalysis()));
  }
}

class CourseCount extends StatefulWidget {
  CourseCount({required this.count});
  final int count;
  @override
  _CourseCountState createState() => _CourseCountState();
}

class _CourseCountState extends State<CourseCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            kAdminLog.toUpperCase() + '(${widget.count.toString()})',
            style: GoogleFonts.rajdhani(
              fontSize: kFontsize.sp,
              color: kFbColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ViewAllCourses()));
              },
              child: SvgPicture.asset(
                'images/classroom/courses.svg',
              )),
        ],
      ),
    );
  }
}
