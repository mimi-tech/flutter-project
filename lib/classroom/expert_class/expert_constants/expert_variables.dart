import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ExpertConstants {
  static String? name;
  static String? job;
  static String? topic;
  static String? subTopic;
  static String? description;
  static List<String?> requirementItems = <String?>[];
  static List<String> language = <String>[];

  static List<dynamic> expertCompany = <dynamic>[];
  static List<dynamic> expertKey = <dynamic>[];
  static List<dynamic> expertAdminDetails = <dynamic>[];

  static String? welcome;
  static String? cong;
  static String? amount;
  static String? promotionalUrl;
  static String? thumbnailUrl;
  static String? note;

  static File? imageFile;
  static File? videoFile;

  static String? classId;

  ///course job title decoration
  static final keyDecoration = InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kMaincolor)));

  ///the course requirements
  static final kClassReqDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: 'Add class requirement',
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
