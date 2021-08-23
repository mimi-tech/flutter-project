//TODO: Holds all static variables that can be accessed and initialized from any location within the app.
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user_general.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_bg_enums.dart';

class GlobalVariables {
  //TODO: Check if the user is online/offline
  static bool? isUserOnline;

  //TODO: This variable manages all the account a user has.
  static List<String?> accountType = [];
  static List<Map<String, dynamic>> profileRendering = [];
  static Map<String, dynamic> accountSelected = {};
  static List<Map<String, dynamic>> allMyAccountTypes = [];
  static List<Map<String, dynamic>> updatedAcct = [];
  static String? accountStatus;

  //TODO: For personal registration, these are other variables for the rest of the form fields
  static String? profileImage,
      country,
      state,
      firstName,
      lastName,
      dob,
      gender,
      maritalStatus,
      phoneNumber,
      profileImageDownloadUrl;
  static bool? isCountryOFResidence, isStateOfResidence, amAMentor;
  static List<String?>? spokenLanguages,
      hobbies,
      areaOfInterest,
      specialities,
      userIndustries;
  static File? userProfileImage;

  //TODO: Stores user's UID and TOKEN_ID: Personal registration
  static String? personalUID;
  static List<String?> personalTokenID = [];
  static List<String> userTokenFromDatabase = [];

  //TODO: For personal registration, these are the variables for login details.
  static String? username, email, password;
  static bool? emailVerified;

  //TODO: Returns true or false if a username exist or not.
  static bool? usernameExist;

  //TODO: For personal registration, validate the user's phone number
  static String? userPhoneAuthID;
  static bool? isPhoneNumberVerified;

  //TODO: Holds the current font size based on the custom settings the user is applying on the custom text post.
  static int? customTextPostFontSize;

  //TODO: Holds the text the user is currently typing. This is based on the custom text post.
  static String? customText;

  //TODO: Holds a list of image provider(Photo Album)
  static List<ImageProvider>? gallery;

  //TODO: This variable holds the document snapshot of the login user
  static late SparksUser loggedInUserObject;
  static late SparksUserGeneral basicProfileInfo;

  //TODO: Holds the default background image for a text post.
  static PostCustomBg? postBg;

  //TODO: For camera post, these are all the variables declared to hold values
  static String cameraImageOrVideo = "images/new_images/defaultCameraImg.png";
  static String? cameraImageDescription;
  static String? cameraPostTitle;
  static File? imageFromCamera;

  //TODO: This variable holds a list of maps containing either images/videos
  static List<Map<String, String>?> mediaFiles = [];

  //TODO: holds the error message that comes with phone verification
  static String? phoneAuthException;

  //TODO: Holds the user profile object being viewed
  static late SparksUser viewingProfileInfo;

  //TODO: Holds all sparkUp group the user is given access to a post
  static List<Map<String, dynamic>> allSelectedGroups = [];

  //TODO: Global variable when set to true, rebuilds the entire post feeds
  static bool rebuildEntirePostFeed = false; // Not in use for now.

  //static List<DocumentSnapshot> myIncomingFeedsGlobal = [];
  //static List<Widget> feed = [];

}
