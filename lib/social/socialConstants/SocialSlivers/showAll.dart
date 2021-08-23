import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';


import 'package:sparks/social/usersTabs/class_tab.dart';
import 'package:sparks/social/usersTabs/course_tab.dart';
import 'package:sparks/social/usersTabs/tutorials.dart';


class ShowAllSilverAppBar extends StatefulWidget {

  @override
  _ShowAllSilverAppBarState createState() => _ShowAllSilverAppBarState();
}
class _ShowAllSilverAppBarState extends State<ShowAllSilverAppBar> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [


        GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassTab()));

          },
          child: Text(kTabAllClasses,
            style: GoogleFonts.rajdhani(
              fontSize: kAppbar.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseTab()));

          },
          child: Text(kTabAllCourses,
            style: GoogleFonts.rajdhani(
              fontSize: kAppbar.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),


        GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TutorialTab()));

          },
          child: Text(kTabAllTutorials,
            style: GoogleFonts.rajdhani(
              fontSize: kAppbar.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),


      ],
    );





  }
}



