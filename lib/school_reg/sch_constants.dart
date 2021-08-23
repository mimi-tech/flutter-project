import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class Constants {
  static String? companyUserName;
  static String? companyName;
  static File? logoImage;
  static String? selectedCountry;
  static String? selectedState;
  static String? companyCity;
  static String? companyStreet;
  static String? companyPhone;
  static String? companyEmail;
  static String? companyPassword;
  static String? companyPin;
  static String? schoolCurrentUser;
  static String? schoolAddress;
  static late String verificationId;
  static String? mobilePin;
  static String? firstName;
  static String? lastName;
  static bool isCampus = false;

  static final companyDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kComplinecolor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: kComplinecolor)));
  static final textStyle = TextStyle(
    fontSize: kFontsize.sp,
    fontFamily: 'Rajdhani',
    color: kWhitecolor,
  );
}
