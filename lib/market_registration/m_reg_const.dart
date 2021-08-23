import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//COLORS FOR THE MARKET REGISTRATION ACTIVITY

// Color for the form header
const kFormHeaderColor = Color(0xff1E141D);

// Color for the form container body
const kFormBodyColor = Color(0xff444444);

// Color overwriting default color of the TextFields
const kFormPrimaryColor = Color(0xffF9F4F4);

// Color for the filled content in the TextFields
const kFromContentColor = Colors.white;

// STYLING FOR THE MARKET REGISTRATION ACTIVITY

// TextStyle of the header of the form
final kFormHeaderTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Color(0xffFF9C8A),
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(20),
  ),
);

// TextStyle overwriting the default styles of the TextFields
final kFormOverrideTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: kFormPrimaryColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  ),
);

// TextStyle for the filled content in the TextFields
final kFormContentTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: kFromContentColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  ),
);

// TextStyle for the 'SIGN UP' button
final kMFormSignUpTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: kFromContentColor,
    fontSize: ScreenUtil().setSp(20),
    fontWeight: FontWeight.w700,
  ),
);

// TextStyle for the 'Take a tour' button
final kMTourButton = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(18),
  ),
);

// TextStyle for the email verification message text
final KMEmailVerTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(18),
  ),
);

// TextStyle for the stylish 'Sparks Market' text
final kMRegSparksMarket = GoogleFonts.berkshireSwash(
  textStyle: TextStyle(
    color: Color(0xffFF9480),
    fontWeight: FontWeight.w400,
    fontSize: ScreenUtil().setSp(18),
  ),
);

// TextStyle for the 'Resend Email' button
final kMRegResendEmailTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: kFromContentColor,
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w700,
  ),
);

// TextStyle for secondary text
final kMRegSecTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      color: Color(0xffB9A5A3),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w600),
);
