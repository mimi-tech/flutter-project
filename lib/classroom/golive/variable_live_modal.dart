import 'dart:io';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Variables {
  static late AnimationController controller;
  static String? title;
  static String? desc;
  static File? imageURI;
  static DateTime selectedDate = DateTime.now();
  static String? time;
  static DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mma');
  static bool first = true;
  static String? contactroute;
  static bool contactVal = false;
  static bool userselections = false;
  static bool menteesVal = false;
  static bool tuteesVal = false;
  static bool classmateVal = false;
  static bool alumniVal = false;
  static int? contactsVal;
  static int? contactCount;
  static bool fb = false;
  static bool switchControl = false;
  static bool? ischeck;
  static bool showSearch = false;
  static var pref;
  static bool tuteesfb = true;
  static bool scaleFontSize = false;
  static String? onlineUserUid;
  static String? allContacts;

  ///users selections
  static String? usertuteescontacts;
  static String? usercontacts;
  static String contact = '';
  static String mentees = '';
  static String tutees = '';
  static String classmate = '';
  static String Alumni = '';

  Random random = new Random();
  static int? randomNumber;

  ///listview object
  static String? usercontactselection;

  static final textstyles = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kWhitecolor,
  );
  static final textstylesmodal = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kBlackcolor,
  );
  static final textstylescard = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kBlackcolor,
  );
  static final textstyleslistViews = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kBlackcolor,
  );
  static final errortext = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
  );

  //live input decoration
  static final liveTitleDecoration = InputDecoration(
      errorStyle: Variables.errortext,
      hintText: kliveformtitlehint,
      hintStyle: TextStyle(
        fontSize: kFontsize.sp,
        color: kTextcolorhintcolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kAshthumbnailcolor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kAshthumbnailcolor)));

  static final liveDescDecoration = InputDecoration(
      errorStyle: Variables.errortext,
      hintText: kliveformdeschint,
      hintStyle: TextStyle(
        fontSize: kFontsize.sp,
        color: kTextcolorhintcolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kAshthumbnailcolor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kAshthumbnailcolor)));
}
