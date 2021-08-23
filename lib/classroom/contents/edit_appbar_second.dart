import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/course_widget/replace_lecture.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditAppBarSecond extends StatelessWidget implements PreferredSizeWidget {
  EditAppBarSecond({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackcolor, size: 10.0),
      elevation: 4.0,
      backgroundColor: kWhitecolor,
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 20.sp,
          color: kBlackcolor,
          fontFamily: 'Rajdhani',
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}
