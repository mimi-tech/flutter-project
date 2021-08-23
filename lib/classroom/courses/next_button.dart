import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseNextButton extends StatelessWidget {
  CourseNextButton({required this.next});
  final Function next;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(50),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: kFbColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            kNextbtn,
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

class Btn extends StatelessWidget {
  Btn({
    required this.next,
    required this.title,
    required this.bgColor,
  });
  final Function next;
  final String title;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(50),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: bgColor,
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

class BtnSecond extends StatelessWidget {
  BtnSecond({
    required this.next,
    required this.title,
    required this.bgColor,
  });
  final Function next;
  final String title;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          )),
    );
  }
}

class BtnThird extends StatelessWidget {
  BtnThird({
    required this.next,
    required this.title,
    required this.bgColor,
  });
  final Function next;
  final String title;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: bgColor,
          child: Text(
            title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          )),
    );
  }
}

class BtnBorder extends StatelessWidget {
  BtnBorder({
    required this.next,
    required this.title,
    required this.bgColor,
  });
  final Function next;
  final String title;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: bgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: kSelectbtncolor, width: 2),
          ),
          child: Text(
            title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              ),
            ),
          )),
    );
  }
}

class BtnWhiteTextColor extends StatelessWidget {
  BtnWhiteTextColor({
    required this.next,
    required this.title,
    required this.bgColor,
  });
  final Function next;
  final String title;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          elevation: 10,
          onPressed: next as void Function()?,
          color: bgColor,
          child: Text(
            title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              ),
            ),
          )),
    );
  }
}
