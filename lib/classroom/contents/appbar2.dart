import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/class/class_content_post.dart';
import 'package:sparks/classroom/contents/live/content_live_post.dart';
import 'package:sparks/classroom/contents/live/courses.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live/published.dart';

class SilverAppBarSecond extends StatefulWidget implements PreferredSizeWidget {
  SilverAppBarSecond({
    required this.tutorialColor,
    required this.coursesColor,
    required this.expertColor,
    required this.eventsColor,
    required this.publishColor,
  });
  final Color tutorialColor;
  final Color coursesColor;
  final Color expertColor;
  final Color eventsColor;
  final Color publishColor;

  @override
  _SilverAppBarSecondState createState() => _SilverAppBarSecondState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _SilverAppBarSecondState extends State<SilverAppBarSecond> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      )),
      backgroundColor: kWhitecolor,
      pinned: true,
      automaticallyImplyLeading: false,
      elevation: 40.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //TODO:New matches tab
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: LiveContent()));
            },
            child: Text(
              'Tutorial',
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: widget.tutorialColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),

          //TODO:New matches tab

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: Courses()));
            },
            child: Text(
              kScourses,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: widget.coursesColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),
          //TODO:New matches tab

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ClassContentPost()));
            },
            child: Text(
              kSexpertclass,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: widget.expertColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),
          /* GestureDetector(
            child: Text(kSevents,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: widget.eventsColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'
              ),),
          ),*/
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: PublishedLive()));
            },
            child: Text(
              kPublish2,
              style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                fontSize: kSappbar2.sp,
                fontWeight: FontWeight.bold,
                color: widget.publishColor,
              )),
            ),
          )
        ],
      ),
    );
  }
}
