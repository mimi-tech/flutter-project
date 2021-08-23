import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Constants {
  static String? courseJobProfile;
  static String? courseTopic;
  static String? courseDesc;
  static String? courseTarget;
  static String? courseEdit;
  static String? kSCourseObj;
  static String? kSCourseReq;
  static String? kSCourseLectureTitle;
  static String? kSCourseLectureSections;
  static String? kCourseDocId;
  static String? kCourseName;
  static String? kCourseSubTopic;
  static String? searchText;
  static String? coursePurpose;
  static String? courseThumbnailUrl;
  static String? courseCongMessage;
  static String? courseWelcomeMessage;
  static String? coursePromotionUrl;
  static String? courseAmount;

  static UploadTask? uploadTask;
  static UploadTask? uploadImageTask;
  static UploadTask? courseThumbnail;
  static UploadTask? coursePromotion;
  static TextEditingController searchController = new TextEditingController();
  static File? promotionThumbnail;
  static File? promotionVideoFile;

  /*courses constants */
  static String? docId;
  static String? courseEditThumbnail;
  static String? courseEditVideo;
  static String? courseEditCongrat;
  static String? courseEditWelcome;
  static String? courseEditAmt;
  static bool? courseVerify;

  ///course job title decoration
  static final kJobDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      hintText: kSJobProfileDesc,
      hintStyle: TextStyle(
        fontSize: kFontsize.sp,
        color: kTextcolorhintcolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kMaincolor)));

  ///course job title decoration
  static final kMessageDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      hintText: kSJobProfileDesc,
      hintStyle: TextStyle(
        fontSize: kFontsize.sp,
        color: kTextcolorhintcolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kMaincolor)));

  ///course topic

  static final kTopicDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kMaincolor)));

  ///create post input
  static final kPostDecoration = InputDecoration(
      hintText: 'Say something about this post',
      hintStyle: GoogleFonts.rajdhani(
        fontSize: kFontsize.sp,
        fontWeight: FontWeight.w500,
        color: kHintColor,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kFbColor)));

  //uploading assignment
  static final kAssignmentDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      hintText: 'Say something about this assignment',
      hintStyle: GoogleFonts.pacifico(
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: kBlackcolor,
          fontSize: kFontSize14.sp,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kPlaylistborder)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kMaincolor)));

  static final kCommentTextFieldDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      hintText: 'Type your comment here...',
      filled: true,
      hintStyle: GoogleFonts.pacifico(
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: kWhitecolor,
          fontSize: kFontSize14.sp,
        ),
      ),
      border: InputBorder.none,
      fillColor: kWhitecolor);

  ///who is this course for
  static final kCourseTargetDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: kSCourseTarget,
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

  ///who is this result for
  static final kResultDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: 'Say something on this result...',
      hintStyle: GoogleFonts.pacifico(
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: kBlackcolor,
          fontSize: kFontSize14.sp,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kAshthumbnailcolor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kAshthumbnailcolor)));

  ///the course objective
  static final kCourseObjDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: kSCourseobj2,
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

  ///the course requirements
  static final kCourseReqDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: kSCourseRequirement2,
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
  static final searchDecoration = InputDecoration(
    fillColor: kWhitecolor,
    filled: true,
    hintStyle: TextStyle(
      fontSize: kFontsize.sp,
      color: kTextcolorhintcolor,
      fontFamily: 'Rajdhani',
      fontWeight: FontWeight.bold,
    ),
    hintText: "Search",
    prefixIcon: Icon(
      Icons.search,
      color: kMaincolor,
    ),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: kMaincolor)),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
  );
}
