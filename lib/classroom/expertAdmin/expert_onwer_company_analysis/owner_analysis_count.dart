import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';

import 'package:sparks/classroom/expertAdmin/expert_company_analysis/expert_daily.dart';
import 'package:sparks/classroom/expertAdmin/expert_onwer_company_analysis/owner_view_all.dart';
import 'package:sparks/classroom/expertAdmin/expert_staff_analysis.dart';
import 'package:sparks/classroom/expertAdmin/view_all_classes.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class OnwerCompanyCount extends StatefulWidget {
  @override
  _OnwerCompanyCountState createState() => _OnwerCompanyCountState();
}

class _OnwerCompanyCountState extends State<OnwerCompanyCount> {
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
        ? CircularProgressIndicator()
        : Column(children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Number of Staff'.toUpperCase() +
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
                        AnalysisConstants.companyName = '';
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OwnerViewAllClasses()));
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
            SizedBox(
              height: ScreenUtil().setHeight(20),
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
                                itemsData[Index]['fn'].toUpperCase(),
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
    FirebaseFirestore.instance.collectionGroup('details').get().then((value) {
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
      ExpertAdminConstants.currentUser = itemsData[index]['suid'];
      AnalysisConstants.staffName = itemsData[index]['fn'];
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ExpertStaffAnalysis()));
  }
}
