import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/CampusSchool/NewsTab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/faculty_screen.dart';
import 'package:sparks/schoolClassroom/CampusSchool/recordsTab.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/All_studies.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_screen.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/create_dept.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/schoolFeeds.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_result.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_assignment.dart';

class AdminBottomBar extends StatefulWidget {
  AdminBottomBar({
    required this.homeColor,
    required this.newsColor,
    required this.recordColor,
  });

  final Color homeColor;
  final Color newsColor;
  final Color recordColor;

  @override
  _AdminBottomBarState createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: BottomAppBar(
        color: kSappbarbacground,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  //Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: SchoolAnnouncement()));

                  if (SchClassConstant.schDoc['camp'] == true) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: FacultyScreen()));
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: SchoolAdminScreen()));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: widget.homeColor),
                    Text('Home',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: 12.sp,
                          ),
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  //Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: SchoolResult()));
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: CampusNewsTab()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_sharp, color: widget.newsColor),
                    Text('News', //kSchoolStudentResult,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: 12.sp,
                          ),
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: CampusRecordTab()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book_online, color: widget.recordColor),

                    // IconButton(icon: Icon(Icons.assessment), onPressed: (){}, color:kBlackcolor2,),
                    Text(
                      'Records', //kSchoolStudentStudies,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kWhitecolor,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /*  GestureDetector(
                onTap: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: AllSchoolFeed()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.feedback, color: kBlackcolor2),

                    // IconButton(icon: Icon(Icons.assessment), onPressed: (){}, color:kBlackcolor2,),
                    Text(
                      'Feedback',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kWhitecolor,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
