import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sparks/classroom/courseAdmin/admin_page.dart';
import 'package:sparks/classroom/courseAnalysis/daily_analysis.dart';
import 'package:sparks/classroom/expertAdmin/sparks_classes_analysis/daily.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AnalysisSilverAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  AnalysisSilverAppBar({
    required this.matches,
    required this.friends,
  });
  final Color matches;
  final Color friends;

  @override
  _AnalysisSilverAppBarState createState() => _AnalysisSilverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _AnalysisSilverAppBarState extends State<AnalysisSilverAppBar> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AllCoursesAnalysis()));
            },
            child: Text(
              kCourse.toUpperCase(),
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AllClassesAnalysis()));
            },
            child: Text(
              kEx.toUpperCase(),
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.friends,
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
        ],
      ),
      backgroundColor: kSappbarbacground,
      floating: true,
      snap: true,
      pinned: false,
    );
  }
}
