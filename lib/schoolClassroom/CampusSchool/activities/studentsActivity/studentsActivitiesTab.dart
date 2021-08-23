import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentAssessmentActivity.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentAttendedClass.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentExtraActivity.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentMissedClasses.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentRecordedVideos.dart';


class StudentActivitiesTab extends StatefulWidget {
  StudentActivitiesTab({required this.doc});
  final DocumentSnapshot doc;

  @override
  _StudentActivitiesTabState createState() => _StudentActivitiesTabState();
}

class _StudentActivitiesTabState extends State<StudentActivitiesTab> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kSappbarbacground,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab( text: "Attended classes".toUpperCase(),),
                Tab( text: "Missed classes".toUpperCase(),),

                Tab( text: "Recorded".toUpperCase()),
                Tab( text: "Extra curricula".toUpperCase()),
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
            title: Text('${widget.doc['fn']} ${widget.doc['ln']} '.toUpperCase(),
              style: GoogleFonts.rajdhani(
                fontSize:20.sp,
                fontWeight: FontWeight.w700,
                color: kAYellow,
              ),)
        ),
        body: TabBarView(
          children: [
            StudentAttendedClass(doc:widget.doc),
            StudentMissedClasses(doc:widget.doc),
            StudentRecordedActivities(doc:widget.doc),
            StudentExtraCurriculaActivities(doc:widget.doc),
            StudentAssessmentActivities(doc:widget.doc),
          ],
        ),
      ),
    );
  }
}
