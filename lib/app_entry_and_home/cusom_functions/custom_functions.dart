import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/models/bookmark.dart';
import 'package:sparks/app_entry_and_home/models/camera_post_model.dart';
import 'package:sparks/app_entry_and_home/models/comment.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_mm.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_tt.dart';
import 'package:sparks/app_entry_and_home/models/notification_card_model.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/models/text_post_model.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/camera_post.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/post_bg_image_choice.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/video_slider.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/camera_card.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/notification_card.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/social_card.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/text_post_card.dart';
import 'package:sparks/app_entry_and_home/reusables/comment_card.dart';
import 'package:sparks/app_entry_and_home/reusables/manage_account.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_bg_enums.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_type_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomFunctions {
  //TODO: Create an object for each language in the language asset list.
  List<LanguageModel> languageObject(List<String> langAsset) {
    List<LanguageModel> langObject = [];

    for (int i = 0; i < langAsset.length; i++) {
      LanguageModel newLangObject =
          LanguageModel(languageName: langAsset[i], isChecked: false);
      langObject.add(newLangObject);
    }

    return langObject;
  }

  //TODO: Create an object for each hobby in the hobby asset list.
  List<HobbiesModel> hobbyObject(List<String> hobbyAsset) {
    List<HobbiesModel> hobbyObject = [];

    for (int i = 0; i < hobbyAsset.length; i++) {
      HobbiesModel newHobbyObject =
          HobbiesModel(hobby: hobbyAsset[i], isChecked: false);
      hobbyObject.add(newHobbyObject);
    }

    return hobbyObject;
  }

  //TODO: Create an object for each speciality in the merged asset list.
  //This was the previous function that creates a list of specialities.
  List<SpecialtiesModel> specialityObject(List<String> mergeAsset) {
    List<SpecialtiesModel> specObject = [];

    for (int i = 0; i < mergeAsset.length; i++) {
      SpecialtiesModel newSpecObject =
          SpecialtiesModel(specialities: mergeAsset[i], isChecked: false);
      specObject.add(newSpecObject);
    }

    return specObject;
  }

  //TODO: This is the new function that generates a list of specialities.
  List<SpecialtiesModel> newSpecialityObject(List<String> newSpecialitiesList) {
    List<SpecialtiesModel> specObject = [];

    for (int i = 0; i < newSpecialitiesList.length; i++) {
      SpecialtiesModel newSpecObject = SpecialtiesModel(
          specialities: newSpecialitiesList[i], isChecked: false);
      specObject.add(newSpecObject);
    }

    return specObject;
  }

  //TODO: Create an object for each interest in the merged asset list.
  //This was the previous function that creates a list of interest.
  List<InterestModel> interestObject(List<String> mergeAsset) {
    List<InterestModel> intObject = [];

    for (int i = 0; i < mergeAsset.length; i++) {
      InterestModel newIntObject =
          InterestModel(interest: mergeAsset[i], isChecked: false);
      intObject.add(newIntObject);
    }

    return intObject;
  }

  //TODO: This is the new function that generates a list of interests
  List<InterestModel> newInterestObject(List<String> newInterestList) {
    List<InterestModel> intObject = [];

    for (int i = 0; i < newInterestList.length; i++) {
      InterestModel newIntObject =
          InterestModel(interest: newInterestList[i], isChecked: false);
      intObject.add(newIntObject);
    }

    return intObject;
  }

  //TODO: Create a method that takes a list of lists String and returns a list of maps.
  static List<Map<String, List<String>>> userAlumniDates(
      List<List<String>> dates) {
    List<Map<String, List<String>>> userAlumni = [];

    //Iterate over these list of lists.
    for (List<String> list in dates) {
      if (list != null) {
        //Create a map.
        Map<String, List<String>> myDates =
            CustomFunctions.createAlumniMap(list[0], list[1], list[2]);
        userAlumni.add(myDates);
      }
    }

    return userAlumni;
  }

  //TODO: Creates a map that accepts strings of text as arguments.
  static Map<String, List<String>> createAlumniMap(
      String categoryName, String from, String to) {
    List<String> fromTo = [];
    fromTo.add(from);
    fromTo.add(to);

    var school = {categoryName: fromTo};

    return school;
  }

  //TODO: This method populates the home menu with content strictly for home menu item.

  //TODO: Returns the custom background the user selected for a particular post.
  static Widget getPostBackground(PostCustomBg userChoice) {
    Widget myPostBackground;

    switch (userChoice) {
      case PostCustomBg.POSTBGIMAGE1:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/bg3.jpg",
          fontColor: kWhiteColour,
          fontFamily: 'NanumGothic',
        );
        break;
      case PostCustomBg.POSTBGIMAGE2:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/bgr.jpg",
          fontColor: kWhiteColour,
          fontFamily: 'NanumGothic',
        );
        break;
      case PostCustomBg.POSTBGIMAGE3:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/bgr2.jpg",
          fontColor: kWhiteColour,
          fontFamily: 'NanumGothic',
        );
        break;
      case PostCustomBg.POSTBGIMAGE4:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/bgr1.png",
          fontColor: kLight_orange,
          fontFamily: 'Lobster',
        );
        break;
      case PostCustomBg.POSTBGIMAGE5:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/orange_bg.png",
          fontColor: kWhiteColour,
          fontFamily: 'NanumGothicB',
        );
        break;
      case PostCustomBg.POSTBGIMAGE6:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/dark_red_bg.png",
          fontColor: kResendColor,
          fontFamily: 'Pacifico',
        );
        break;
      case PostCustomBg.POSTBGIMAGE7:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl:
              "images/app_entry_and_home/post_bg/leaf_green_bg.png",
          fontColor: kLight_orange,
          fontFamily: 'Lobster',
        );
        break;
      case PostCustomBg.POSTBGIMAGE8:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "images/app_entry_and_home/post_bg/white_bg.png",
          fontColor: kBlackColour,
          fontFamily: 'Lobster',
        );
        break;
      default:
        myPostBackground = PostBgImageChoice(
          customBgImageUrl: "",
          fontColor: kBlackColour,
          fontFamily: 'Lobster',
        );
    }

    return myPostBackground;
  }

  //TODO: Gets the type of post the user wants to make and returns the desired view.
  static Widget? getPostType(PostType postType, PostCustomBg userChoice) {
    Widget? widgetBasedOnPostType;

    switch (postType) {
      case PostType.TEXT_POST:
        widgetBasedOnPostType = getPostBackground(userChoice);
        break;
      case PostType.CAMERA_POST:
        break;
      default:
        widgetBasedOnPostType = CameraPost();
    }

    return widgetBasedOnPostType;
  }

  //TODO: This function is tried to the text post, it looks at what the user has selected, get the background colour/image, font family and font size. This will aid the app to make a post that is exactly the way the user customized it.
  static Map<String, dynamic> getTextPostCustomSettings(PostCustomBg postBg) {
    Map<String, dynamic> textPostSettings = {};

    switch (postBg) {
      case PostCustomBg.POSTBGIMAGE5:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/orange_bg.png",
          "Font family": "NanumGothicB",
          "Font colour": Color(0xFFFFFFFF),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE6:
        textPostSettings = {
          "Background image":
              "images/app_entry_and_home/post_bg/dark_red_bg.png",
          "Font family": "Pacifico",
          "Font colour": Color(0xFFFFFFFF),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE7:
        textPostSettings = {
          "Background image":
              "images/app_entry_and_home/post_bg/leaf_green_bg.png",
          "Font family": "Lobster",
          "Font colour": Color(0xFFA60F00),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE1:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/bg3.jpg",
          "Font family": "NanumGothic",
          "Font colour": Color(0xFFFFFFFF),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE2:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/bgr.jpg",
          "Font family": "NanumGothic",
          "Font colour": Color(0xFFFFFFFF),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE3:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/bgr2.jpg",
          "Font family": "NanumGothic",
          "Font colour": Color(0xFFFFFFFF),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE4:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/bgr1.png",
          "Font family": "Lobster",
          "Font colour": Color(0xFFA60F00),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
        break;
      case PostCustomBg.POSTBGIMAGE8:
        textPostSettings = {
          "Background image": "images/app_entry_and_home/post_bg/white_bg.png",
          "Font family": "Lobster",
          "Font colour": Color(0xFF000000),
          "Font size": GlobalVariables.customTextPostFontSize,
          "User post": GlobalVariables.customText,
        };
    }

    return textPostSettings;
  }

  //TODO: This function calculates the age of a feed.
  static String _getFeedAge(DateTime fAge) {
    String age = timeago.format(fAge);
    return age;
  }

  //TODO: Render the appropriate widget based on the feed type that is coming in. Eg of types include text, camera, image etc
  static Widget feedWidget(
      BuildContext context, Map<String, dynamic> feedDocuments) {
    late Widget appropriateWidget;

    try {
      if (feedDocuments["postT"] == "Text") {
        TextPostModel textFeed = TextPostModel.fromJson(feedDocuments);

        //TODO: Display how old this feed is.
        String feedAge = _getFeedAge(textFeed.ptc!);

        appropriateWidget = TextPostCard(
          authorId: textFeed.aID,
          postId: textFeed.postId,
          authorProfileImage: textFeed.auPimg,
          firstname: textFeed.nm!["fn"],
          lastname: textFeed.nm!["ln"],
          authorMainSpeciality: textFeed.auSpec,
          howOldIstheFeed: feedAge,
          textBgImage: textFeed.bgImg,
          postType: textFeed.postT,
          mainText: textFeed.text,
          fontSize: textFeed.fontS,
          textColor: textFeed.txtC,
          fontFamily: textFeed.fonFa,
          likePost: textFeed.likeP,
          likeCount: textFeed.nOfLikes,
          commentCount: textFeed.nOfCmts,
          shareCount: textFeed.nOfShs,
          cLocation: textFeed.cln,
          deletePostID: textFeed.delID,
        );
      } else if (feedDocuments["postT"] == "Camera") {
        CameraPostModel cameraPostModel =
            CameraPostModel.fromJson(feedDocuments);

        //TODO: Display how old this feed is.
        String feedAge = _getFeedAge(cameraPostModel.ptc!);

        appropriateWidget = CameraCard(
          cameraPostModel: cameraPostModel,
          feedAge: feedAge,
        );
      }
    } catch (e) {
      e.toString();
    }

    return appropriateWidget;
  }

  //TODO: A slider that holds either images or videos
  static Widget? createSlider(BuildContext context, List<String> sliderURLS) {
    CarouselSlider? cSlider;
    List<AspectRatio> imgs = [];
    VideoSlider? playVideo;

    //TODO: Check if it is an image or a video and render the corresponding slider
    for (String sUrl in sliderURLS) {
      String fileType = sUrl.split("?").first;
      if ((fileType.endsWith(".jpg")) ||
          (fileType.endsWith(".png")) ||
          (fileType.endsWith(".gif")) ||
          (fileType.endsWith(".jpeg"))) {
        AspectRatio ar = AspectRatio(
          aspectRatio: 4 / 3,
          child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                backgroundColor: kGreyLightShade,
                value: progress.progress,
              ),
            ),
            imageUrl: sUrl,
            fit: BoxFit.cover,
          ),
        );
        imgs.add(ar);
      } else if (fileType.endsWith(".mp4")) {
        playVideo = VideoSlider(
          videoURL: sUrl,
        );
      }
    }

    //TODO: Create a slider using carousel-slider
    if (imgs.isNotEmpty) {
      if (imgs.length == 1) {
        cSlider = CarouselSlider(
          items: imgs,
          options: CarouselOptions(
            aspectRatio: 4 / 3,
            autoPlay: false,
            autoPlayCurve: Curves.easeIn,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            scrollDirection: Axis.horizontal,
          ),
        );
      } else {
        cSlider = CarouselSlider(
          items: imgs,
          options: CarouselOptions(
            aspectRatio: 4 / 3,
            autoPlay: true,
            autoPlayCurve: Curves.easeIn,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            scrollDirection: Axis.horizontal,
          ),
        );
      }
    } else if (playVideo != null) {
      return playVideo;
    }

    return cSlider;
  }

  //TODO: Returns a list of widget that contains the user account types/the active account
  static List<ManageAccount> userAccountManager(BuildContext context,
      List<Map<String, dynamic>> uAccountTypes, String userUid) {
    List<ManageAccount> uManager = [];
    List<Map<String, dynamic>> listOfUpdatedAccount = [];

    for (Map<String, dynamic> uAccount in uAccountTypes) {
      Widget accountWidget = ManageAccount(
        accountName: uAccount["act"],
        activeAccount: uAccount["dp"],
        accountClicked: () {
          Navigator.of(context).pop();
          Map<String, dynamic> updatingAccount = {};

          ///Loop through all account(s) and make the selected account active
          for (Map<String, dynamic> uAc in uAccountTypes) {
            if (uAccount["act"] == uAc["act"]) {
              updatingAccount = {
                "act": uAccount["act"],
                "dp": true,
              };

              listOfUpdatedAccount.add(updatingAccount);
            } else {
              updatingAccount = {
                "act": uAc["act"],
                "dp": false,
              };

              listOfUpdatedAccount.add(updatingAccount);
            }
          }

          ///Reset this static variable to empty. It holds all accounts created by the user.
          GlobalVariables.allMyAccountTypes.clear();
          GlobalVariables.updatedAcct = listOfUpdatedAccount;

          //TODO: Make this account active and load the appropriate home screen.
          DatabaseService(loggedInUserID: userUid)
              .makeThisAccountActive(listOfUpdatedAccount);
          Navigator.pushNamed(context, SparksLandingScreen.id);
        },
      );

      uManager.add(accountWidget as ManageAccount);
    }

    return uManager;
  }

  //TODO: Fetches the profile info of this user using the user's id
  static Future<DocumentSnapshot<Map<String, dynamic>>> viewingThisUserProfile(
      String? userProfileId, String profileAccount) async {
    DocumentSnapshot<Map<String, dynamic>> profileDocument =
        await DatabaseService(loggedInUserID: userProfileId)
            .loggedInUserProfileWithDefaultAccount(profileAccount);

    return profileDocument;
  }

  //TODO: Formats a number and returns a string
  /// Logic to format large numbers (e.g. 1000 to 1k, 1000000 to 1M)
  static String numberFormatter(int? num) {
    String formattedNum;

    if (num == null) {
      formattedNum = "0";
      return formattedNum;
    }

    /// Logic to convert 1 Billion to '1B'
    if (num >= 1000000000) {
      formattedNum = (num / 1000000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 Billion and then add 'B' at the end
      double remainder = num.remainder(1000000000);
      if (remainder >= 100000000) {
        remainder = remainder / 100000000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'B';
      } else {
        formattedNum += 'B';
      }
    } else if (num >= 1000000) {
      /// Logic to convert 1 Million to '1M'
      formattedNum = (num / 1000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 million and then add 'M' at the end
      double remainder = num.remainder(1000000);
      if (remainder >= 100000) {
        remainder = remainder / 100000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'M';
      } else {
        formattedNum += 'M';
      }
    } else if (num >= 1000) {
      /// Logic to convert 1 thousand to '1k'
      formattedNum = (num / 1000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 thousand and then add 'k' at the end
      double remainder = num.remainder(1000);
      if (remainder >= 100) {
        remainder = remainder / 100;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'k';
      } else {
        formattedNum += 'k';
      }
    } else {
      return num.toString();
    }
    return formattedNum;
  }

  //TODO: Return true or false if the user id is found inside the like post collection or not.
  static Future<bool> isPostLiked(
      String? authorId, String? loggedInID, String? postID) async {
    bool likeAndUnlike;

    bool? isUserIdFound = await DatabaseService(loggedInUserID: loggedInID)
        .checkUserIdInLikedCollection(authorId, postID);

    if (isUserIdFound == true) {
      likeAndUnlike = true;
    } else {
      likeAndUnlike = false;
    }

    return likeAndUnlike;
  }

  //TODO: Return true or false if the user id is found inside the like comment collection or not
  static Future<bool> isCommentLiked(String? authorId, String? loggedInID,
      String? postID, String? commentID) async {
    bool likeAndUnlike;

    bool? isUserIdFound = await DatabaseService(loggedInUserID: loggedInID)
        .checkUserIdInLikedCommentCollection(authorId, postID, commentID);

    if (isUserIdFound == true) {
      likeAndUnlike = true;
    } else {
      likeAndUnlike = false;
    }

    return likeAndUnlike;
  }

  //TODO: Create a comment widget from the comment model being passed
  static Widget createCommentCard(CommentModel commentModel) {
    String dateOfComment = _getFeedAge(commentModel.tOfPst!);

    return CommentCard(
      authorPimg: commentModel.pimg,
      authorFullname: commentModel.nm,
      authorSpec: commentModel.auSpec,
      comment: commentModel.comment,
      numOfLikes: commentModel.nOfLikes,
      numOfReplies: commentModel.nOfRpy,
      authorId: commentModel.auID,
      commentId: commentModel.commID,
      howOldIsTheComment: dateOfComment,
      postId: commentModel.postID,
    );
  }

  //TODO: Create a notification widget from the notification model being passed
  static Widget? createNotificationCard(
      NotificationCardModel notificationCardModel) {
    DateTime howLong =
        DateTime.fromMillisecondsSinceEpoch(notificationCardModel.cts!);
    String dateOfNotification = _getFeedAge(howLong);
    Widget? customNotificationCard;

    //TODO: Check the type of notification and render the notification card accordingly
    if (notificationCardModel.notTye == "comment") {
      customNotificationCard = HomeNotificationCard(
        authorId: notificationCardModel.auId,
        postId: notificationCardModel.postId,
        ownOfPostCommentId: notificationCardModel.ptOwn,
        authorComment: notificationCardModel.comm,
        authorPimg: notificationCardModel.pimg,
        authorFN: notificationCardModel.nm,
        notificationID: notificationCardModel.notID,
        notificationStatus: notificationCardModel.notSts,
        notificationType: "commented on your comment.",
        whenCreated: dateOfNotification,
      );
    }
    return customNotificationCard;
  }

  //TODO: Add a user's bookmark to the post bookmark collection
  static addBookmark(
      String? authorId, String? postId, SparksBookmark sparksBookmark) {
    DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .addNewBookmark(authorId, postId, sparksBookmark);
  }

  //TODO: Delete a user's bookmark from post bookmark collection
  static deleteBookmark(String? authorId, String? postId) {
    DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .deleteBookmark(authorId, postId);
  }

  //TODO: Check if a user has bookmarked any post, if yes return true else false
  static Future<bool> isPostBookmarked(String? authorId, String? postId) async {
    bool isPostBookmarked = false;
    isPostBookmarked = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .isPostBookmarked(authorId, postId);

    return isPostBookmarked;
  }

  //TODO: Format a notification counter from an integer to a string
  static String notificationCounterFormatter(int notificationCounter) {
    String formattedCounter = "";

    if (notificationCounter == 0) {
      formattedCounter = "";
    } else if ((notificationCounter > 0) && (notificationCounter <= 9)) {
      formattedCounter = "$notificationCounter";
    } else if (notificationCounter > 9) {
      formattedCounter = "9+";
    }

    return formattedCounter;
  }

  //TODO: Make a call to the database class to fetch the post tired to the notification being clicked
  static Future<dynamic> getNotificationRelatedPost(
      String? postOwner, String? postId) async {
    return await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .postConnectedToNotification(postOwner, postId);
  }

  //TODO: Store the user avatar locally on the user's device
  // static Future<String> saveUserAvatarPath(Image userAvatar) async {
  //   final completer = Completer<String>();
  //
  //   userAvatar.image
  //       .resolve(ImageConfiguration())
  //       .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) async {
  //     final byteData = await (imageInfo.image
  //         .toByteData(format: ImageByteFormat.png) as Future<ByteData>);
  //     final pngData = byteData.buffer.asUint8List();
  //
  //     final fileName = pngData.hashCode;
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = "${directory.path}/$fileName";
  //     final file = File(filePath);
  //     await file.writeAsBytes(pngData);
  //
  //     completer.complete(filePath);
  //   }));
  //
  //   return completer.future;
  // }

  //TODO: Creating a list social cards to be rendered on the social screen
  static List<SocialCard> createSocialCard(
      List<Map<String, dynamic>?> cardDetails, List<String?> statusInfo) {
    List<SocialCard> profileCards = [];

    for (int i = 0; i < cardDetails.length; i++) {
      Widget personalProfileCard = SocialCard(
        profileImg: cardDetails[i]!["pimg"],
        fullName:
            "${cardDetails[i]!['nm']['ln']} ${cardDetails[i]!['nm']['fn']}",
        discipline: cardDetails[i]!["spec"][0],
        currentStatus: statusInfo[i],
        profileId: cardDetails[i]!['id'],
      );

      profileCards.add(personalProfileCard as SocialCard);
    }

    return profileCards;
  }

  //TODO: Creating a spark up request object ( friend )
  /*
  * requestingUserId - the sender's uid
  * requestTo - the receiver's uid
  * requestingUserStatus - returns the current status of the sender eg FRIEND | TUTOR | MENTOR
  * */
  static List<CreateSparkUp> creatingFriendRequestData(
      String? requestingUserId,
      String? requestTo,
      String? requestingUserStatus,
      Map<String, String?>? fName,
      String? pImg,
      String? email) {
    List<CreateSparkUp> sparkUpRequestObject = [];

    if (requestingUserStatus == "FRIEND") {
      // Request object created
      CreateSparkUp requestSentObject = CreateSparkUp(
        sid: requestingUserId,
        reqTo: requestTo,
        stsT: requestingUserStatus,
        reqSt: DateTime.now(),
        reqCom: null,
        fId: requestTo,
        nm: fName,
        em: email,
        pimg: pImg,
        sUpTy: "REQUEST SENT",
      );

      // Received object created
      CreateSparkUp receivedSentObject = CreateSparkUp(
        sid: requestingUserId,
        reqTo: requestTo,
        stsT: requestingUserStatus,
        reqSt: DateTime.now(),
        reqCom: null,
        fId: requestingUserId,
        nm: fName,
        em: email,
        pimg: pImg,
        sUpTy: "RECEIVED",
      );

      sparkUpRequestObject.add(requestSentObject);
      sparkUpRequestObject.add(receivedSentObject);
    } else if ((requestingUserStatus == "TUTOR") ||
        (requestingUserStatus == "MENTOR")) {
      // Request object created
      CreateSparkUp requestSentObject = CreateSparkUp(
        sid: requestingUserId,
        reqTo: requestTo,
        stsT: "FRIEND",
        reqSt: DateTime.now(),
        reqCom: null,
        fId: requestTo,
        nm: fName,
        em: email,
        pimg: pImg,
        sUpTy: "REQUEST SENT",
      );

      // Received object created
      CreateSparkUp receivedSentObject = CreateSparkUp(
        sid: requestingUserId,
        reqTo: requestTo,
        stsT: "FRIEND",
        reqSt: DateTime.now(),
        reqCom: null,
        fId: requestingUserId,
        nm: fName,
        em: email,
        pimg: pImg,
        sUpTy: "RECEIVED",
      );

      sparkUpRequestObject.add(requestSentObject);
      sparkUpRequestObject.add(receivedSentObject);
    }

    return sparkUpRequestObject;
  }

  //TODO: Creating a spark up request object ( tutor | tutee )
  static List<CreateSparkUpTT> creatingTutorTuteeRequestData(
      String? requestingUserId,
      String? requestTo,
      String? requestingUserStatus,
      Map<String, String?>? fName,
      String? pImg,
      String? email) {
    List<CreateSparkUpTT> sparkUpRequestObject = [];

    // Request object created
    CreateSparkUpTT requestSentObject = CreateSparkUpTT(
      sid: requestingUserId,
      recId: requestTo,
      stsT: requestingUserStatus,
      reqSt: DateTime.now(),
      reqCom: null,
      asA: "TUTOR",
      tuId: requestTo,
      nm: fName,
      em: email,
      pimg: pImg,
      sUpTy: "REQUEST SENT",
    );

    // Received object created
    CreateSparkUpTT receivedSentObject = CreateSparkUpTT(
      sid: requestingUserId,
      recId: requestTo,
      stsT: requestingUserStatus,
      reqSt: DateTime.now(),
      reqCom: null,
      asA: "TUTEE",
      tuId: requestingUserId,
      nm: fName,
      em: email,
      pimg: pImg,
      sUpTy: "RECEIVED",
    );

    sparkUpRequestObject.add(requestSentObject);
    sparkUpRequestObject.add(receivedSentObject);

    return sparkUpRequestObject;
  }

  //TODO: Creating a spark up request object ( Mentor | Mentee )
  static List<CreateSparkUpMM> creatingMentorMenteeRequestData(
      String? requestingUserId,
      String? requestTo,
      String? requestingUserStatus,
      Map<String, String?>? fName,
      String? pImg,
      String? email) {
    List<CreateSparkUpMM> sparkUpRequestObject = [];

    // Request object created
    CreateSparkUpMM requestSentObject = CreateSparkUpMM(
      sid: requestingUserId,
      recId: requestTo,
      stsT: requestingUserStatus,
      reqSt: DateTime.now(),
      reqCom: null,
      asA: "MENTOR",
      meId: requestTo,
      nm: fName,
      em: email,
      pimg: pImg,
      sUpTy: "REQUEST SENT",
    );

    // Received object created
    CreateSparkUpMM receivedSentObject = CreateSparkUpMM(
      sid: requestingUserId,
      recId: requestTo,
      stsT: requestingUserStatus,
      reqSt: DateTime.now(),
      reqCom: null,
      asA: "MENTEE",
      meId: requestingUserId,
      nm: fName,
      em: email,
      pimg: pImg,
      sUpTy: "RECEIVED",
    );

    sparkUpRequestObject.add(requestSentObject);
    sparkUpRequestObject.add(receivedSentObject);

    return sparkUpRequestObject;
  }

  //TODO: Generate a list of list that holds users ids from a particular group.
  /*
  * Parameters: List of maps containing the groups selected by the user
  * */
  static Future<List<List<String?>>> listOfIDs(
      List<Map<String, dynamic>> listOfSelectedGroups) async {
    List<List<String?>> groupUIDS = [];

    //Loop through the list
    for (Map<String, dynamic> mGroups in listOfSelectedGroups) {
      switch (mGroups["GroupName"]) {
        case "Friends":
          List<String?> listOfFriendsID =
              []; // holds all friends ids in friends group
          groupUIDS.add([
            GlobalVariables.loggedInUserObject.id
          ]); // Add the author's id to the list of list
          late DocumentSnapshot lastDocument;

          if (mGroups["GroupSize"] > 10000) {
            double dividend = mGroups["GroupSize"] / 10000;

            int cDividend = dividend.floor();
            int mod = mGroups["GroupSize"] %
                10000; // The remainder that is less than 10,000

            if (mod > 0) {
              QuerySnapshot querySnapshot = await DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .allDocumentsInGroup(mGroups["GroupName"], mod);

              List<DocumentSnapshot> fids = querySnapshot.docs;
              for (DocumentSnapshot documentSnapshot in fids) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String? fUID = data[
                    "fId"]; //get the uid of every friend in this documentSnapshot
                listOfFriendsID.add(fUID);
              }

              groupUIDS.add(
                  listOfFriendsID); //add the list of friends fids to the list of list called groupUIDS

              lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                  1]; //get the last document from this querySnapshot

              //Fetch the remaining set of friends id associated with this group
              for (int x = 0; x < cDividend; x++) {
                QuerySnapshot querySnapshot = await DatabaseService(
                        loggedInUserID: GlobalVariables.loggedInUserObject.id)
                    .getTheNextTenThousandDocInGroup(
                        mGroups["GroupName"], lastDocument, 10000);

                List<DocumentSnapshot> fids = querySnapshot.docs;
                for (DocumentSnapshot documentSnapshot in fids) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String? fUID = data[
                      "fId"]; //get the uid of every friend in this documentSnapshot
                  listOfFriendsID.add(fUID);
                }

                groupUIDS.add(
                    listOfFriendsID); //add the list of friends fids to the list of list called groupUIDS

                lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                    1]; //get the last document from this querySnapshot
              }
            } else {
              for (int x = 0; x < cDividend; x++) {
                if (x == 0) {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .allDocumentsInGroup(mGroups["GroupName"], 10000);

                  List<DocumentSnapshot> fids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in fids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? fUID = data[
                        "fId"]; //get the uid of every friend in this documentSnapshot
                    listOfFriendsID.add(fUID);
                  }

                  groupUIDS.add(
                      listOfFriendsID); //add the list of friends fids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                } else {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .getTheNextTenThousandDocInGroup(
                          mGroups["GroupName"], lastDocument, 10000);

                  List<DocumentSnapshot> fids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in fids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? fUID = data[
                        "fId"]; //get the uid of every friend in this documentSnapshot
                    listOfFriendsID.add(fUID);
                  }

                  groupUIDS.add(
                      listOfFriendsID); //add the list of friends fids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                }
              }
            }
          } else {
            //When mGroups["GroupSize"] is less than 10,000
            QuerySnapshot querySnapshot = await DatabaseService(
                    loggedInUserID: GlobalVariables.loggedInUserObject.id)
                .allDocumentsInGroup(
                    mGroups["GroupName"], mGroups["GroupSize"]);

            List<DocumentSnapshot> fids = querySnapshot.docs;
            for (DocumentSnapshot documentSnapshot in fids) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              String? fUID = data[
                  "fId"]; //get the uid of every friend in this documentSnapshot
              listOfFriendsID.add(fUID);
            }

            groupUIDS.add(
                listOfFriendsID); //add the list of friends fids to the list of list called groupUIDS
          }

          break;
        case "Tutors":
          List<String?> listOfTutorsID =
              []; // holds all tutors ids in tutors group
          groupUIDS.add([
            GlobalVariables.loggedInUserObject.id
          ]); // Add the author's id to the list of list
          late DocumentSnapshot lastDocument;

          if (mGroups["GroupSize"] > 10000) {
            double dividend = mGroups["GroupSize"] / 10000;

            int cDividend = dividend.floor();
            int mod = mGroups["GroupSize"] %
                10000; // The remainder that is less than 10,000

            if (mod > 0) {
              QuerySnapshot querySnapshot = await DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .allDocumentsInGroup(mGroups["GroupName"], mod);

              List<DocumentSnapshot> tutorID = querySnapshot.docs;
              for (DocumentSnapshot documentSnapshot in tutorID) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String? tUID = data[
                    "tuId"]; //get the uid of every tutors in this documentSnapshot
                listOfTutorsID.add(tUID);
              }

              groupUIDS.add(
                  listOfTutorsID); //add the list of tutors tuids to the list of list called groupUIDS

              lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                  1]; //get the last document from this querySnapshot

              //Fetch the remaining set of tutors id associated with this group
              for (int x = 0; x < cDividend; x++) {
                QuerySnapshot querySnapshot = await DatabaseService(
                        loggedInUserID: GlobalVariables.loggedInUserObject.id)
                    .getTheNextTenThousandDocInGroup(
                        mGroups["GroupName"], lastDocument, 10000);

                List<DocumentSnapshot> tuids = querySnapshot.docs;
                for (DocumentSnapshot documentSnapshot in tuids) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String? tUID = data[
                      "tuId"]; //get the uid of every tutor in this documentSnapshot
                  listOfTutorsID.add(tUID);
                }

                groupUIDS.add(
                    listOfTutorsID); //add the list of tutors tuids to the list of list called groupUIDS

                lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                    1]; //get the last document from this querySnapshot
              }
            } else {
              for (int x = 0; x < cDividend; x++) {
                if (x == 0) {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .allDocumentsInGroup(mGroups["GroupName"], 10000);

                  List<DocumentSnapshot> tuids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in tuids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? tUID = data[
                        "tuId"]; //get the uid of every tutor in this documentSnapshot
                    listOfTutorsID.add(tUID);
                  }

                  groupUIDS.add(
                      listOfTutorsID); //add the list of tutors tuids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                } else {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .getTheNextTenThousandDocInGroup(
                          mGroups["GroupName"], lastDocument, 10000);

                  List<DocumentSnapshot> tuids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in tuids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? tUID = data[
                        "tuId"]; //get the uid of every tutor in this documentSnapshot
                    listOfTutorsID.add(tUID);
                  }

                  groupUIDS.add(
                      listOfTutorsID); //add the list of tutors tuids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                }
              }
            }
          } else {
            //When mGroups["GroupSize"] is less than 10,000
            QuerySnapshot querySnapshot = await DatabaseService(
                    loggedInUserID: GlobalVariables.loggedInUserObject.id)
                .allDocumentsInGroup(
                    mGroups["GroupName"], mGroups["GroupSize"]);

            List<DocumentSnapshot> tuids = querySnapshot.docs;
            for (DocumentSnapshot documentSnapshot in tuids) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              String? tUID = data[
                  "tuId"]; //get the uid of every tutor in this documentSnapshot
              listOfTutorsID.add(tUID);
            }

            groupUIDS.add(
                listOfTutorsID); //add the list of tutors tuids to the list of list called groupUIDS
          }

          break;
        case "Mentors":
          List<String?> listOfMentorsID =
              []; // holds all mentors ids in mentors group
          groupUIDS.add([
            GlobalVariables.loggedInUserObject.id
          ]); // Add the author's id to the list of list
          late DocumentSnapshot lastDocument;

          if (mGroups["GroupSize"] > 10000) {
            double dividend = mGroups["GroupSize"] / 10000;

            int cDividend = dividend.floor();
            int mod = mGroups["GroupSize"] %
                10000; // The remainder that is less than 10,000

            if (mod > 0) {
              QuerySnapshot querySnapshot = await DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .allDocumentsInGroup(mGroups["GroupName"], mod);

              List<DocumentSnapshot> menids = querySnapshot.docs;
              for (DocumentSnapshot documentSnapshot in menids) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String? meUID = data[
                    "meId"]; //get the uid of every mentor in this documentSnapshot
                listOfMentorsID.add(meUID);
              }

              groupUIDS.add(
                  listOfMentorsID); //add the list of mentors menids to the list of list called groupUIDS

              lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                  1]; //get the last document from this querySnapshot

              //Fetch the remaining set of mentors id associated with this group
              for (int x = 0; x < cDividend; x++) {
                QuerySnapshot querySnapshot = await DatabaseService(
                        loggedInUserID: GlobalVariables.loggedInUserObject.id)
                    .getTheNextTenThousandDocInGroup(
                        mGroups["GroupName"], lastDocument, 10000);

                List<DocumentSnapshot> menids = querySnapshot.docs;
                for (DocumentSnapshot documentSnapshot in menids) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String? meUID = data[
                      "meId"]; //get the uid of every mentor in this documentSnapshot
                  listOfMentorsID.add(meUID);
                }

                groupUIDS.add(
                    listOfMentorsID); //add the list of mentors menids to the list of list called groupUIDS

                lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                    1]; //get the last document from this querySnapshot
              }
            } else {
              for (int x = 0; x < cDividend; x++) {
                if (x == 0) {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .allDocumentsInGroup(mGroups["GroupName"], 10000);

                  List<DocumentSnapshot> menids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in menids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? meUID = data[
                        "meId"]; //get the uid of every mentor in this documentSnapshot
                    listOfMentorsID.add(meUID);
                  }

                  groupUIDS.add(
                      listOfMentorsID); //add the list of mentors menids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                } else {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .getTheNextTenThousandDocInGroup(
                          mGroups["GroupName"], lastDocument, 10000);

                  List<DocumentSnapshot> menids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in menids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? meUID = data[
                        "meId"]; //get the uid of every mentor in this documentSnapshot
                    listOfMentorsID.add(meUID);
                  }

                  groupUIDS.add(
                      listOfMentorsID); //add the list of mentors menids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                }
              }
            }
          } else {
            //When mGroups["GroupSize"] is less than 10,000
            QuerySnapshot querySnapshot = await DatabaseService(
                    loggedInUserID: GlobalVariables.loggedInUserObject.id)
                .allDocumentsInGroup(
                    mGroups["GroupName"], mGroups["GroupSize"]);

            List<DocumentSnapshot> menids = querySnapshot.docs;
            for (DocumentSnapshot documentSnapshot in menids) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              String? meUID = data[
                  "meId"]; //get the uid of every mentor in this documentSnapshot
              listOfMentorsID.add(meUID);
            }

            groupUIDS.add(
                listOfMentorsID); //add the list of mentors menids to the list of list called groupUIDS
          }

          break;
        case "Tutees":
          List<String?> listOfTuteesID =
              []; // holds all tutees ids in tutees group
          groupUIDS.add([
            GlobalVariables.loggedInUserObject.id
          ]); // Add the author's id to the list of list
          late DocumentSnapshot lastDocument;

          if (mGroups["GroupSize"] > 10000) {
            double dividend = mGroups["GroupSize"] / 10000;

            int cDividend = dividend.floor();
            int mod = mGroups["GroupSize"] %
                10000; // The remainder that is less than 10,000

            if (mod > 0) {
              QuerySnapshot querySnapshot = await DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .allDocumentsInGroup(mGroups["GroupName"], mod);

              List<DocumentSnapshot> tuteeID = querySnapshot.docs;
              for (DocumentSnapshot documentSnapshot in tuteeID) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String? teUID = data[
                    "tuId"]; //get the uid of every tutees in this documentSnapshot
                listOfTuteesID.add(teUID);
              }

              groupUIDS.add(
                  listOfTuteesID); //add the list of tutees tuids to the list of list called groupUIDS

              lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                  1]; //get the last document from this querySnapshot

              //Fetch the remaining set of tutees id associated with this group
              for (int x = 0; x < cDividend; x++) {
                QuerySnapshot querySnapshot = await DatabaseService(
                        loggedInUserID: GlobalVariables.loggedInUserObject.id)
                    .getTheNextTenThousandDocInGroup(
                        mGroups["GroupName"], lastDocument, 10000);

                List<DocumentSnapshot> tuteeID = querySnapshot.docs;
                for (DocumentSnapshot documentSnapshot in tuteeID) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String? teUID = data[
                      "tuId"]; //get the uid of every tutee in this documentSnapshot
                  listOfTuteesID.add(teUID);
                }

                groupUIDS.add(
                    listOfTuteesID); //add the list of tutees tuids to the list of list called groupUIDS

                lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                    1]; //get the last document from this querySnapshot
              }
            } else {
              for (int x = 0; x < cDividend; x++) {
                if (x == 0) {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .allDocumentsInGroup(mGroups["GroupName"], 10000);

                  List<DocumentSnapshot> tuteeID = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in tuteeID) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? teUID = data[
                        "tuId"]; //get the uid of every tutee in this documentSnapshot
                    listOfTuteesID.add(teUID);
                  }

                  groupUIDS.add(
                      listOfTuteesID); //add the list of tutees tuids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                } else {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .getTheNextTenThousandDocInGroup(
                          mGroups["GroupName"], lastDocument, 10000);

                  List<DocumentSnapshot> tuteeID = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in tuteeID) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? teUID = data[
                        "tuId"]; //get the uid of every tutee in this documentSnapshot
                    listOfTuteesID.add(teUID);
                  }

                  groupUIDS.add(
                      listOfTuteesID); //add the list of tutees tuids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                }
              }
            }
          } else {
            //When mGroups["GroupSize"] is less than 10,000
            QuerySnapshot querySnapshot = await DatabaseService(
                    loggedInUserID: GlobalVariables.loggedInUserObject.id)
                .allDocumentsInGroup(
                    mGroups["GroupName"], mGroups["GroupSize"]);

            List<DocumentSnapshot> tuteeID = querySnapshot.docs;
            for (DocumentSnapshot documentSnapshot in tuteeID) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              String? teUID = data[
                  "tuId"]; //get the uid of every tutee in this documentSnapshot
              listOfTuteesID.add(teUID);
            }

            groupUIDS.add(
                listOfTuteesID); //add the list of tutees tuids to the list of list called groupUIDS
          }

          break;
        case "Mentees":
          List<String?> listOfMenteesID =
              []; // holds all mentees ids in mentees group
          groupUIDS.add([
            GlobalVariables.loggedInUserObject.id
          ]); // Add the author's id to the list of list
          late DocumentSnapshot lastDocument;

          if (mGroups["GroupSize"] > 10000) {
            double dividend = mGroups["GroupSize"] / 10000;

            int cDividend = dividend.floor();
            int mod = mGroups["GroupSize"] %
                10000; // The remainder that is less than 10,000

            if (mod > 0) {
              QuerySnapshot querySnapshot = await DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .allDocumentsInGroup(mGroups["GroupName"], mod);

              List<DocumentSnapshot> metids = querySnapshot.docs;
              for (DocumentSnapshot documentSnapshot in metids) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String? metUID = data[
                    "meId"]; //get the uid of every mentee in this documentSnapshot
                listOfMenteesID.add(metUID);
              }

              groupUIDS.add(
                  listOfMenteesID); //add the list of mentees menids to the list of list called groupUIDS

              lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                  1]; //get the last document from this querySnapshot

              //Fetch the remaining set of mentees id associated with this group
              for (int x = 0; x < cDividend; x++) {
                QuerySnapshot querySnapshot = await DatabaseService(
                        loggedInUserID: GlobalVariables.loggedInUserObject.id)
                    .getTheNextTenThousandDocInGroup(
                        mGroups["GroupName"], lastDocument, 10000);

                List<DocumentSnapshot> metids = querySnapshot.docs;
                for (DocumentSnapshot documentSnapshot in metids) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String? metUID = data[
                      "meId"]; //get the uid of every mentor in this documentSnapshot
                  listOfMenteesID.add(metUID);
                }

                groupUIDS.add(
                    listOfMenteesID); //add the list of mentees menids to the list of list called groupUIDS

                lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                    1]; //get the last document from this querySnapshot
              }
            } else {
              for (int x = 0; x < cDividend; x++) {
                if (x == 0) {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .allDocumentsInGroup(mGroups["GroupName"], 10000);

                  List<DocumentSnapshot> metids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in metids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? metUID = data[
                        "meId"]; //get the uid of every mentee in this documentSnapshot
                    listOfMenteesID.add(metUID);
                  }

                  groupUIDS.add(
                      listOfMenteesID); //add the list of mentees menids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                } else {
                  QuerySnapshot querySnapshot = await DatabaseService(
                          loggedInUserID: GlobalVariables.loggedInUserObject.id)
                      .getTheNextTenThousandDocInGroup(
                          mGroups["GroupName"], lastDocument, 10000);

                  List<DocumentSnapshot> metids = querySnapshot.docs;
                  for (DocumentSnapshot documentSnapshot in metids) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String? metUID = data[
                        "meId"]; //get the uid of every mentor in this documentSnapshot
                    listOfMenteesID.add(metUID);
                  }

                  groupUIDS.add(
                      listOfMenteesID); //add the list of mentees menids to the list of list called groupUIDS

                  lastDocument = querySnapshot.docs[querySnapshot.docs.length -
                      1]; //get the last document from this querySnapshot
                }
              }
            }
          } else {
            //When mGroups["GroupSize"] is less than 10,000
            QuerySnapshot querySnapshot = await DatabaseService(
                    loggedInUserID: GlobalVariables.loggedInUserObject.id)
                .allDocumentsInGroup(
                    mGroups["GroupName"], mGroups["GroupSize"]);

            List<DocumentSnapshot> metids = querySnapshot.docs;
            for (DocumentSnapshot documentSnapshot in metids) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              String? metUID = data[
                  "meId"]; //get the uid of every mentor in this documentSnapshot
              listOfMenteesID.add(metUID);
            }

            groupUIDS.add(
                listOfMenteesID); //add the list of mentors menids to the list of list called groupUIDS
          }

          break;
      }
    }

    return groupUIDS;
  }
}
