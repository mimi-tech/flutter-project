import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadVariables {
  static String? title;
  static String? description;
  static String? category = '';
  static String publicPrivate = 'public';
  static String? childrenAdult;
  static int? contactCount;
  static bool isChecked = true;
  static bool isPrivate = false;
  static bool showUserSelectionTrue = false;
  static bool showUserSelectionFalse = true;
  static File? thumbnail;
  static File? endScreen;
  static String playlistVisibility = 'public';
  static String? playlistId;
  static bool? pVPublic = true;
  static bool pvPrivate = false;
  static File? uploadVideourl;
  static UploadTask? uploadTask;
  static File? fileName;
  static String? url;
  static String uploadedVideoName = '';
  static File? uploadVideofile;
  static String? playlistTitle;
  static String? currentUser;
  static String? videoUrlSelected;
  static File? videoFileSelected;
  static String? pdk;
  static String? ageRestriction;
  static String? playlistUrl1;
  static String? playlistUrl2;
  static String? selectedVideo;
/*check if the video player has reach to the end*/
  static bool videoEnded = false;
  static int limit = 15;

/*content constants*/
  static int? viDi;
  static String? downloadVideoUrl;
  static bool? monVal = false;
  static bool monValError = false;
  static int? downloadIndex;
  static int? selectedDocIndex;
  static bool showSilverAppbar = true;
  static bool checkUserContent = false;
  static String? searchText;
  static TextEditingController searchController = TextEditingController();
  static bool highlightAgeLimit = false;

/*content constants for edit*/
  static String? cThumbnail;
  static String? cEndScreen;
  static String? cTitle;
  static String? cDesc;
  static String? cVideo;
  static String? cDocumentId;
  static String? cVisibility;
  static String? cLimit;
  static String? cAge;

  ///title decoration
  static final kTextFieldDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
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

  ///description
  static final kDescFieldDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
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

  static final kCateFieldDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kFbColor,
      ),
      hintText: kuploadcatehint,
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

  static final editContentDecoration = InputDecoration(
      errorStyle: TextStyle(
        fontSize: kErrorfont.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: Colors.red,
      ),
      hintText: kAddtitle,
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

  static final uploadfontsize = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kBlackcolor,
  );

  static final uploadbtnfontsize = TextStyle(
    fontSize: kFontsize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kWhitecolor,
  );
}
