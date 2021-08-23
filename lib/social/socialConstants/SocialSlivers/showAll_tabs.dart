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

class ShowAllSliverAppBar extends StatefulWidget implements PreferredSizeWidget{
  ShowAllSliverAppBar({
    required this.matches,
    required this.friends,
    required this.classroom,
    required this.content,
  });
  final Color matches;
  final Color friends;
  final Color classroom;
  final Color content;
  @override
  _ShowAllSliverAppBarState createState() => _ShowAllSliverAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);


}

class _ShowAllSliverAppBarState extends State<ShowAllSliverAppBar> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  @override
  Widget build(BuildContext context) {

    return  SliverAppBar(
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0),
          )
      ),
      automaticallyImplyLeading: false,
      backgroundColor: kBlackcolor,
      pinned: true,
      title:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassTab()));

            },
            child: Text(kTabAllClasses,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.matches,
                fontWeight: FontWeight.bold,

              ),),
          ),

          GestureDetector(
            onTap: (){
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseTab()));

            },
            child: Text(kTabAllCourses,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.friends,
                fontWeight: FontWeight.bold,

              ),),
          ),


          GestureDetector(
            onTap: (){

              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TutorialTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TutorialTab()));

            },
            child: Text(kTabAllTutorials,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.classroom,
                fontWeight: FontWeight.bold,

              ),),
          ),


        ],
      ),


    );




  }
}



