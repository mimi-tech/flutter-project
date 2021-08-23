import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/course_widget/divider.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class AdminTabs extends StatefulWidget {
  AdminTabs({
    required this.openEmail,
    required this.viewCourses,
    required this.verify,
  });
  final Function openEmail;
  final Function viewCourses;
  final Function verify;

  @override
  _AdminTabsState createState() => _AdminTabsState();
}

class _AdminTabsState extends State<AdminTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: widget.viewCourses as void Function()?,
              child: Text(
                'View Courses',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kStabcolor,
                ),
              ),
            ),
            VerticalLine(),
            GestureDetector(
              onTap: widget.verify as void Function()?,
              child: Text(
                'Verify',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kStabcolor,
                ),
              ),
            ),
            VerticalLine(),
            GestureDetector(
              onTap: widget.openEmail as void Function()?,
              child: Text(
                'Send mail',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kStabcolor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
