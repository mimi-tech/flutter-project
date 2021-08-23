import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/schoolPost/myReports.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_report.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/social_studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_announcement.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_feed.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/stdent_announcement.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_lessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_assignment.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_social.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class NewsBoardAppBar extends StatefulWidget with PreferredSizeWidget{

  NewsBoardAppBar({
    required this.extraLessonsColor,
    required this.extraLessonsBgColor,
    required this.chatColor,
    required this.chatBgColor,
    required this.newsColor,
    required this.newsBgColor,
    required this.reportColor,
    required this.reportBgColor,


  });
  final Color extraLessonsColor;
  final Color extraLessonsBgColor;
  final Color chatColor;
  final Color chatBgColor;
  final Color newsColor;
  final Color newsBgColor;
  final Color reportColor;
  final Color reportBgColor;

  @override
  _NewsBoardAppBarState createState() => _NewsBoardAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _NewsBoardAppBarState extends State<NewsBoardAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kWhitecolor,
      automaticallyImplyLeading: false,
      floating: true,
      pinned: false,
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
              if(SchClassConstant.isTeacher){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersAnnouncement()));

              }else{
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentAnnouncement()));

            }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.newsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('School News',
                  style: GoogleFonts.rajdhani(
                    fontSize:kFontSize12.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.newsColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
    if(SchClassConstant.isTeacher){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeacherSocialStudies()));

    }else{
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentSocial()));

            }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.extraLessonsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Extra curricular',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize12.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.extraLessonsColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher) {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersFeeds()));

              }else{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ChatScreen()));
              }


            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.chatBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isTeacher?'Feeds':'chat',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize12.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.chatColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
    if(SchClassConstant.isTeacher) {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SeeTeachersReport()));

    }else{
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ReportMadeOnMe()));
    }

    },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.reportBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Report',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize12.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.reportColor,
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
