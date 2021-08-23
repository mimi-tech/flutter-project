import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/VirtualClass/indexpage.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/TeachersNewsTab.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/class_socials.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_announcement.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_assessment.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/uploadTab.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_lessons.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_result.dart';

class TeachersBottomBar extends StatefulWidget {
  TeachersBottomBar({
    required this.classroomColor,
    required this.uploadColor,
    required this.newsColor,
  });

  final Color classroomColor;
  final Color uploadColor;
  final Color newsColor;

  @override
  _TeachersBottomBarState createState() => _TeachersBottomBarState();
}

class _TeachersBottomBarState extends State<TeachersBottomBar> {
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
                onTap: (){
                  //Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: SocialClasses()));
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: TeacherStudies()));

                  },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.class_,color:widget.classroomColor),

                    Text('Classroom',//'Social class',
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
                onTap: (){
                 // Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: TeachersAssessment()));
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: UploadTab()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_rounded,color:widget.uploadColor),

                    Text('Uploads',//kSchoolStudentAssessment,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: kFontSize12.sp,
                          ),
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  //Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: TeachersUploadResult()));
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: TeachersNewsTab()));


                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.near_me,color:widget.newsColor),

                    // IconButton(icon: Icon(Icons.assessment), onPressed: (){}, color:kBlackcolor2,),
                    Text('News',//kSchoolStudentResult,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kWhitecolor,
                          fontSize: kFontSize12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  //Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: IndexPage()));
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: StudentsEClasses()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.live_tv,color:kWhitecolor),
                    Text('Live',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: kFontSize12.sp,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
