import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/assessmentActivity.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/attendedClassActivity.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/extraCurriculaActivities.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/recordedActivities.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/resultActivity.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/scheduledLiveActivity.dart';


class SchoolTeachersActivities extends StatefulWidget {
  SchoolTeachersActivities({required this.doc});
  final DocumentSnapshot doc;

  @override
  _SchoolTeachersActivitiesState createState() => _SchoolTeachersActivitiesState();
}

class _SchoolTeachersActivitiesState extends State<SchoolTeachersActivities> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kSappbarbacground,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab( text: "E-Scheduled class".toUpperCase(),),
                Tab( text: "E-Attended classes".toUpperCase(),),
                Tab( text: "Recorded".toUpperCase()),
                Tab( text: "Extra curricula".toUpperCase()),
                Tab( text: "Result".toUpperCase()),
                Tab( text: "Assessments".toUpperCase()),

              ],

              indicatorColor: kWhitecolor,
              indicatorWeight: 2.0,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Creates border
                  color: kbtnsecond),
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
                fontSize:20.sp,
                fontWeight: FontWeight.w700,
                color: kAYellow,
              ),)
        ),
        body: TabBarView(
          children: [
            ScheduledLiveActivity(doc:widget.doc),
            AttendedEClassActivity(doc:widget.doc),
            RecordedActivities(doc:widget.doc),
            ExtraCurriculaActivity(doc:widget.doc),
            ResultActivities(doc:widget.doc),
            AssessmentActivities(doc:widget.doc),
          ],
        ),
      ),
    );
  }
}
