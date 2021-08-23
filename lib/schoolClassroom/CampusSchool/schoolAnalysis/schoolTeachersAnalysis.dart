import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/daily.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/monthly.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/weekly.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/yearly.dart';



class SchoolTeachersAnalysis extends StatefulWidget {
  SchoolTeachersAnalysis({required this.doc});
  final DocumentSnapshot doc;

  @override
  _SchoolTeachersAnalysisState createState() => _SchoolTeachersAnalysisState();
}

class _SchoolTeachersAnalysisState extends State<SchoolTeachersAnalysis> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Daily".toUpperCase(),),
              Tab( text: "Weekly".toUpperCase()),
              Tab( text: "Monthly".toUpperCase()),
              Tab( text: "Yearly".toUpperCase()),

            ],

            indicatorColor: kWhitecolor,
            indicatorWeight: 2.0,

            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kStabcolor1,
                fontSize: kFontSize14.sp,
              ),),
            unselectedLabelColor: kTextColor,

          ),
          title: Text('${widget.doc['tc']} '.toUpperCase(),
            style: GoogleFonts.rajdhani(
              fontSize:16.sp,
              fontWeight: FontWeight.w700,
              color: kWhitecolor,
            ),)
        ),
        body: TabBarView(
          children: [
            DailyTeachersAnalysis(doc:widget.doc),
            WeeklyTeachersAnalysis(doc:widget.doc),
            MonthlyTeachersAnalysis(doc:widget.doc),
            YearlyTeachersAnalysis(doc:widget.doc)
          ],
        ),
      ),
    );
  }
}
