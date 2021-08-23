import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/social/socialContent/FriendsMatch/friends-classes.dart';
import 'package:sparks/social/socialContent/FriendsMatch/friends_all.dart';
import 'package:sparks/social/socialContent/FriendsMatch/friends_live.dart';
import 'package:sparks/social/socialContent/FriendsMatch/friends_tutorial.dart';
import 'package:sparks/social/socialContent/FriendsMatch/frinds_courses.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutor-classes.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutor_courses.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutor_live.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutors_tab.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutors_tutorial.dart';

class SocialFriendsSilverAppBar extends StatefulWidget implements PreferredSizeWidget{
  SocialFriendsSilverAppBar({
    required this.matches,
    required this.friends,
    required this.classroom,
    required this.content,
    required this.all,
  });
  final Color matches;
  final Color friends;
  final Color classroom;
  final Color content;
  final Color all;
  @override
  _SocialFriendsSilverAppBarState createState() => _SocialFriendsSilverAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);


}

class _SocialFriendsSilverAppBarState extends State<SocialFriendsSilverAppBar> {
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
      backgroundColor: kWhitecolor,
      pinned: true,
      title:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            onTap: (){
              // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatchLive()));

            },
            child: Text(kTabLive,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.content,
                fontWeight: FontWeight.bold,

              ),),
          ),
         /* GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatch()));

            },
            child: Text(kTabAll,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.all,
                fontWeight: FontWeight.bold,

              ),),
          ),*/
          GestureDetector(
            onTap: (){
              // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ClassTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatchClasses()));

            },
            child: Text(kTabClasses,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.matches,
                fontWeight: FontWeight.bold,

              ),),
          ),

          GestureDetector(
            onTap: (){
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatchCourses()));

            },
            child: Text(kTabCourses,
              style: GoogleFonts.rajdhani(
                fontSize: kAppbar.sp,
                color: widget.friends,
                fontWeight: FontWeight.bold,

              ),),
          ),


          GestureDetector(
            onTap: (){

              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TutorialTab()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatchTutorial()));

            },
            child: Text(kTabTutorials,
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



