import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/class/class_content_post.dart';
import 'package:sparks/social/socialContent/NewMatches/new_matches_live.dart';

class SilverAppBar extends StatefulWidget implements PreferredSizeWidget {
  SilverAppBar({
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
  _SilverAppBarState createState() => _SilverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _SilverAppBarState extends State<SilverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      )),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //TODO:New matches tab
          GestureDetector(
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SocialNewMatchesLive()));
            },
            child: Text(
              kSnewmatches,
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.matches,
                fontFamily: 'Rajdhani',
                shadows: [
                  Shadow(
                    blurRadius: kSblur,
                    color: kBlackcolor,
                    offset: Offset(kshadowoffset, kshadowoffset),
                  ),
                ],
              ),
            ),
          ),

          //TODO:friends tab
          GestureDetector(
            child: Text(
              kSFriends,
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.friends,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rajdhani',
                shadows: [
                  Shadow(
                    blurRadius: kSblur,
                    color: kBlackcolor,
                    offset: Offset(kshadowoffset, kshadowoffset),
                  ),
                ],
              ),
            ),
          ),

          //TODO:New matches tab

          GestureDetector(
            child: Text(
              kSclassroom,
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.classroom,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rajdhani',
                shadows: [
                  Shadow(
                    blurRadius: kSblur,
                    color: kBlackcolor,
                    offset: Offset(kshadowoffset, kshadowoffset),
                  ),
                ],
              ),
            ),
          ),
          //TODO:New matches tab

          GestureDetector(
            child: Text(
              kScontent,
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.content,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rajdhani',
                shadows: [
                  Shadow(
                    blurRadius: kSblur,
                    color: kBlackcolor,
                    offset: Offset(kshadowoffset, kshadowoffset),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor: kSappbarbacground,
      floating: true,
      snap: true,
      pinned: false,
    );
  }
}
