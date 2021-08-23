import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/VirtualClass/missedClasses.dart';
import 'package:sparks/schoolClassroom/VirtualClass/teachermissedClass.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/uploadTab.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_lessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_assignment.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class EClassSliverAppBar extends StatefulWidget with PreferredSizeWidget{

  EClassSliverAppBar({
    required this.liveColor,
    required this.liveBgColor,
    required this.missedClassColor,
    required this.missedClassBgColor,
    required this.recordsColor,
    required this.assessmentColor,
    required this.recordsBgColor,
    required this.assessmentBgColor,

  });
  final Color liveColor;
  final Color liveBgColor;
  final Color missedClassColor;
  final Color missedClassBgColor;
  final Color recordsColor;
  final Color recordsBgColor;
  final Color assessmentBgColor;
  final Color assessmentColor;
  @override
  _EClassSliverAppBarState createState() => _EClassSliverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _EClassSliverAppBarState extends State<EClassSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kWhitecolor,
      automaticallyImplyLeading: false,

      pinned: true,
      forceElevated: true,
      elevation: 6.0,
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsEClasses()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.liveBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Live',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.liveColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher){
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: TeacherMissedClasses()));

              }else{
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: MissedEClass()));

              }

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.missedClassBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Missed classes',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.missedClassColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher){
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: TeacherStudies()));

            }else{
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: StudentLessons()));

              }
              },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Recorded',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.recordsColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
            if(SchClassConstant.isTeacher){
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: UploadTab()));

            }else{
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: StudentAssessment()));

            }
            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.assessmentBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isTeacher?'Upload':'Assessment',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.assessmentColor,
                  ),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
