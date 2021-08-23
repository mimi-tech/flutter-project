import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LectureDialog extends StatelessWidget {
  LectureDialog(
      {required this.title, required this.bgColor, required this.upload});
  final String title;
  final Color bgColor;
  final Function upload;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: upload as void Function()?,
      color: bgColor,
      child: Text(title,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: kWhitecolor,
              fontSize: kFontsize.sp,
            ),
          )),
    );
  }
}

class CoursePublishBtn extends StatelessWidget {
  CoursePublishBtn({required this.publish, required this.title});
  final Function publish;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(50),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: publish as void Function()?,
          color: kFbColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: 22.sp,
              ),
            ),
          )),
    );
  }
}
