import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/allStudentsReport.dart';
import 'package:sparks/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/schoolPost/schoolProfile.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentPostProfile.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacherProfile.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_feed.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/highSchoolProfile.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class PostSliverAppBar extends StatefulWidget with PreferredSizeWidget{

  PostSliverAppBar({
    required this.campusColor,
    required this.campusBgColor,
    required this.deptColor,
    required this.deptBgColor,
    required this.recordsColor,
    required this.recordsBgColor,
  });
  final Color campusColor;
  final Color campusBgColor;
  final Color deptColor;
  final Color deptBgColor;
  final Color recordsColor;
  final Color recordsBgColor;
  @override
  _PostSliverAppBarState createState() => _PostSliverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _PostSliverAppBarState extends State<PostSliverAppBar> {
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
              setState(() {
                SchoolPostConst.checkClass = true;
              });

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusPostScreen()));

            },
            child: Material(
             borderRadius: BorderRadius.circular(20.0),
             color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isUniStudent || SchClassConstant.isCampusProprietor?'My campus':'My school',
        style: GoogleFonts.rajdhani(
            fontSize: kFontSize14.sp,
            fontWeight: FontWeight.bold,
            color: widget.campusColor,
        ),

      ),
              ),
              ),
          ),

          SchClassConstant.isUniStudent? GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassmatePost()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Classmates',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.deptColor,
                  ),

                ),
              ),
            ),
          ):GestureDetector(
            onTap: (){
               if(SchClassConstant.isTeacher){
                 Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersProfile()));

               }else if(SchClassConstant.isProprietor){
                 Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolProfile()));

               } else{
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HighSchoolStudentProfile()));

            }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isProprietor?'School profile':'My Profile',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.deptColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
    if(SchClassConstant.isTeacher){
      Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: ChatScreen()));

    }else if(SchClassConstant.isProprietor) {
      Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: AllSchoolStudentReport()));


    }else{
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: FullStudentsResult()));

            }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isTeacher?'Chat':SchClassConstant.isProprietor?'Report':'Records',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.recordsColor,
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




class PostSliverStudentAppBar extends StatefulWidget with PreferredSizeWidget{

  PostSliverStudentAppBar({
    required this.campusColor,
    required this.campusBgColor,
    required this.deptColor,
    required this.deptBgColor,
    required this.recordsColor,
    required this.recordsBgColor,
    required this.profileBgColor,
    required this.profileColor,
  });
  final Color campusColor;
  final Color campusBgColor;
  final Color deptColor;
  final Color deptBgColor;
  final Color recordsColor;
  final Color recordsBgColor;
  final Color profileBgColor;
  final Color profileColor;
  @override
  _PostSliverStudentAppBarState createState() => _PostSliverStudentAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _PostSliverStudentAppBarState extends State<PostSliverStudentAppBar> {
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
              setState(() {
                SchoolPostConst.checkClass = true;
              });

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusPostScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isUniStudent || SchClassConstant.isCampusProprietor?'My campus':'My school',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.campusColor,
                  ),

                ),
              ),
            ),
          ),

          SchClassConstant.isUniStudent? GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassmatePost()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Classmates',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.deptColor,
                  ),

                ),
              ),
            ),
          ):GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersProfile()));

              }else if(SchClassConstant.isProprietor){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolProfile()));

              } else{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HighSchoolStudentProfile()));

              }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isProprietor?'School profile':'My Profile',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.deptColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher){
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: ChatScreen()));

              }else if(SchClassConstant.isProprietor) {
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: AllSchoolStudentReport()));


              }else{
                Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: FullStudentsResult()));

              }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(SchClassConstant.isTeacher?'Chat':SchClassConstant.isProprietor?'Report':'Records',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.recordsColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsPostProfile(doc: SchClassConstant.schDoc,)));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.profileBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Profile',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.profileColor,
                  ),

                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

