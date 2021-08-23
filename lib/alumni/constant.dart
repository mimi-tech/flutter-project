import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/alumnischoollisting.dart';

import 'activities_admin.dart';
import 'activities_members.dart';
import 'activities_myset.dart';
import 'color/colors.dart';
import 'dimens/dimens.dart';
import 'strings.dart';

class Constant {
  static final textstylesfonts = TextStyle(
    fontSize: kMyfonts.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kAWhite,
  );
}

class NavBar extends StatelessWidget {
  NavBar({
    this.bgMembers,
    this.bgMySet,
    this.bgChapter,
    this.bgAdmin,
    required this.membersColor,
    required this.mySetColor,
    required this.chapterColor,
    required this.adminColor,
  });

  final Color? bgMembers;
  final Color? bgMySet;
  final Color? bgChapter;
  final Color? bgAdmin;
  final Color membersColor;
  final Color mySetColor;
  final Color chapterColor;
  final Color adminColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: Members()));
          },
          child: NavBarComponent(
            bgColour: bgMembers,
            colour: membersColor,
            text: KAppBarMembers,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                PageTransition(type: PageTransitionType.fade, child: MySet()));
          },
          child: NavBarComponent(
            bgColour: bgMySet,
            colour: mySetColor,
            text: KAppBarMySet,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: SchoolListing()));
          },
          child: NavBarComponent(
            bgColour: bgChapter,
            colour: chapterColor,
            text: KAppBarChapter,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: ActivitiesAdmin()));
          },
          child: NavBarComponent(
            bgColour: bgAdmin,
            colour: adminColor,
            text: KAppBarAdmin,
          ),
        ),
      ],
    );
  }
}

class NavBarComponent extends StatelessWidget {
  NavBarComponent({required this.colour, required this.bgColour, this.text});

  final Color colour;
  final Color? bgColour;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: bgColour,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text!,
            style: TextStyle(
                fontFamily: "Rajdhani",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colour),
          ),
        ),
      ),
    );
  }
}
