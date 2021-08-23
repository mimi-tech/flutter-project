import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/allStudentsReport.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campusMedia.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_admins.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_students_tab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_tutors.dart';
import 'package:sparks/schoolClassroom/CampusSchool/faculty_screen.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/All_studies.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/all_socialClasses.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/create_dept.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/media.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/schoolFeeds.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_result.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_teachers.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/show_admins.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/students_screen.dart';
import 'package:sparks/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/schoolPost/schoolProfile.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacherProfile.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_feed.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/highSchoolProfile.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class CampusSliverAppBar extends StatefulWidget with PreferredSizeWidget{

  CampusSliverAppBar({
    required this.campusColor,
    required this.campusBgColor,
    required this.deptColor,
    required this.deptBgColor,
    required this.recordsColor,
    required this.recordsBgColor,

    required this.adminsColor,
    required this.adminsBgColor,
  });
  final Color campusColor;
  final Color campusBgColor;
  final Color deptColor;
  final Color deptBgColor;
  final Color recordsColor;
  final Color recordsBgColor;

  final Color adminsColor;
  final Color adminsBgColor;
  @override
  _CampusSliverAppBarState createState() => _CampusSliverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _CampusSliverAppBarState extends State<CampusSliverAppBar> {
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
              print(SchoolPostConst.checkClass);
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: FacultyScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Faculty',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.campusColor,
                  ),

                ),
              ),
            ),
          ),

         GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusTutorsScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Lectures',
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusStudentsScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Students',
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusAddShowAdmin()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.adminsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Admins',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.adminsColor,
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





class CampusSliverAppBarNews extends StatefulWidget with PreferredSizeWidget{

  CampusSliverAppBarNews({
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
  _CampusSliverAppBarNewsState createState() => _CampusSliverAppBarNewsState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _CampusSliverAppBarNewsState extends State<CampusSliverAppBarNews> {
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
              print(SchoolPostConst.checkClass);
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolAnnouncement()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Announcement',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.campusColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllSchoolFeed()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Feedback',
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
              if(SchClassConstant.isCampusProprietor){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateCampusSchoolPost()));

            }else{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateHighSchoolPost()));

              }
              },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Media',
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




class CampusSliverAppBarStudies extends StatefulWidget with PreferredSizeWidget{

  CampusSliverAppBarStudies({
    required this.campusColor,
    required this.campusBgColor,
    required this.deptColor,
    required this.deptBgColor,
    required this.recordsColor,
    required this.recordsBgColor,
    required this.eClassColor,
    required this.eClassBgColor,
  });
  final Color campusColor;
  final Color campusBgColor;
  final Color deptColor;
  final Color deptBgColor;
  final Color recordsColor;
  final Color recordsBgColor;

  final Color eClassColor;
  final Color eClassBgColor;
  @override
  _CampusSliverAppBarStudiesState createState() => _CampusSliverAppBarStudiesState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _CampusSliverAppBarStudiesState extends State<CampusSliverAppBarStudies> {
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AdminStudies()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Studies',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.campusColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AdminStudies()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.eClassBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('E-class',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.eClassColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllSocialClasses()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Extra curricula',
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
              if(SchClassConstant.isLecturer){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolResult()));

            }else{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersUploadResult()));

              }},
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Result',
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






class HighSchoolSliverAppBar extends StatefulWidget with PreferredSizeWidget{

  HighSchoolSliverAppBar({
    required this.campusColor,
    required this.campusBgColor,
    required this.deptColor,
    required this.deptBgColor,
    required this.recordsColor,
    required this.recordsBgColor,
    required this.sectionColor,
    required this.sectionBgColor,
  });
  final Color campusColor;
  final Color campusBgColor;
  final Color deptColor;
  final Color deptBgColor;
  final Color recordsColor;
  final Color recordsBgColor;
  final Color sectionColor;
  final Color sectionBgColor;
  @override
  _HighSchoolSliverAppBarState createState() => _HighSchoolSliverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _HighSchoolSliverAppBarState extends State<HighSchoolSliverAppBar> {
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

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateDepartment()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.campusBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Sections',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.campusColor,
                  ),

                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.deptBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Students',
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolAddShowAdmin()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.recordsBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Admins',
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersScreen()));

            },
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.sectionBgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Teachers',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.sectionColor,
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
