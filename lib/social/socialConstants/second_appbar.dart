import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/social/socialContent/FriendsMatch/friends_live.dart';

import 'package:sparks/social/socialContent/MentorMatch/mentor_live.dart';
import 'package:sparks/social/socialContent/NewMatches/new_matches.dart';
import 'package:sparks/social/socialContent/TutorMatch/tutors_tab.dart';
import 'package:sparks/social/usersTabs/class_tab.dart';
class SocialSilverAppBar extends StatefulWidget implements PreferredSizeWidget{
  SocialSilverAppBar({
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
  _SocialSilverAppBarState createState() => _SocialSilverAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);


}

class _SocialSilverAppBarState extends State<SocialSilverAppBar> {
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


      title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ClassTab()));

                  },
                  child: Text(kAll,
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: kMaincolor,
                      fontWeight: FontWeight.bold,

                    ),),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SocialNewMatches()));

                  },
                  child: Text(kSnewmatches,
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.matches,
                      fontWeight: FontWeight.bold,

                    ),),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SocialTutorsMatch()));

                  },
                  child: Text(kTutors,
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.friends,
                      fontWeight: FontWeight.bold,

                    ),),
                ),


                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialMentorMatchLive()));

                  },
                  child: Text(kMentors,
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.classroom,
                      fontWeight: FontWeight.bold,

                    ),),
                ),

                GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialFriendsMatchLive()));

                        },
                  child: Text(kAllFriends,
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.content,
                      fontWeight: FontWeight.bold,

                    ),),
                ),
              ],
            ),


        );




  }
}



class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar({required this.title});
  final String title;
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);


}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kStatusbar,
      title: Text(widget.title,
        style: GoogleFonts.rajdhani(
          fontSize: kFontSize14.sp,
          color: kWhitecolor,
          fontWeight: FontWeight.bold,

        ),),
    );
  }
}
