import 'dart:io';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/models/spark_up.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/who_see_post_card.dart';
import 'package:sparks/app_entry_and_home/services/storageService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/text_post_model.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_bg_enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SendingPostRequest {
  SparkUp? sparkUpModel;

  //Choose who get to see your post
  Widget whoSeePostWidget(
      BuildContext context, Future<SparkUp>? mySparkUPGroup) {
    bool whoSeeCheck = false;
    bool whoSeeCheck1 = false;
    bool whoSeeCheck2 = false;
    bool whoSeeCheck3 = false;
    bool whoSeeCheck4 = false;

    //Clear the global variable list that holds the selected groups
    GlobalVariables.allSelectedGroups.clear();

    Widget seeMyPost = Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.9,
            color: kWhiteColour,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "Select Who Sees Your Post",
                      style: Theme.of(context).textTheme.headline6!.apply(
                            fontSizeFactor: 0.8,
                            fontWeightDelta: 2,
                            color: kHintColor,
                          ),
                    ),
                  ),
                ),
                Divider(
                  color: kHintColor,
                ),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: AutoScrollController(),
                    child: FutureBuilder<SparkUp>(
                      future: mySparkUPGroup,
                      builder: (context, snapshot) {
                        if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                            (snapshot.hasData == true)) {
                          sparkUpModel = snapshot.data;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //FRIENDS
                              WhoSeePostCard(
                                sparKGroup: "FRIENDS",
                                sparkGroupSize: sparkUpModel!.numF == null
                                    ? 0
                                    : sparkUpModel!.numF,
                                checked: whoSeeCheck,
                                isSelected: whoSeeCheck,
                                isChecked: (value) {
                                  setState(() {
                                    whoSeeCheck = value ? true : false;

                                    //Add group to this collection
                                    if (whoSeeCheck == true) {
                                      GlobalVariables.allSelectedGroups.add({
                                        "GroupName": "Friends",
                                        "GroupSize": sparkUpModel!.numF,
                                      });
                                    } else {
                                      //Remove group from this collection
                                      try {
                                        if (GlobalVariables
                                            .allSelectedGroups.isNotEmpty) {
                                          for (Map<String, dynamic> sGroup
                                              in GlobalVariables
                                                  .allSelectedGroups) {
                                            if (sGroup
                                                .containsValue("Friends")) {
                                              GlobalVariables.allSelectedGroups
                                                  .remove(sGroup);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        e.toString();
                                      }
                                    }
                                  });
                                },
                              ),
                              //TUTORS
                              WhoSeePostCard(
                                sparKGroup: "TUTORS",
                                sparkGroupSize: sparkUpModel!.numT,
                                checked: whoSeeCheck1,
                                isSelected: whoSeeCheck1,
                                isChecked: (value) {
                                  setState(() {
                                    whoSeeCheck1 = value ? true : false;

                                    //Add group to this collection
                                    if (whoSeeCheck1 == true) {
                                      GlobalVariables.allSelectedGroups.add({
                                        "GroupName": "Tutors",
                                        "GroupSize": sparkUpModel!.numT,
                                      });
                                    } else {
                                      //Remove group from this collection
                                      try {
                                        if (GlobalVariables
                                            .allSelectedGroups.isNotEmpty) {
                                          for (Map<String, dynamic> sGroup
                                              in GlobalVariables
                                                  .allSelectedGroups) {
                                            if (sGroup
                                                .containsValue("Tutors")) {
                                              GlobalVariables.allSelectedGroups
                                                  .remove(sGroup);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        e.toString();
                                      }
                                    }
                                  });
                                },
                              ),
                              //MENTORS
                              WhoSeePostCard(
                                sparKGroup: "MENTORS",
                                sparkGroupSize: sparkUpModel!.numM,
                                checked: whoSeeCheck2,
                                isSelected: whoSeeCheck2,
                                isChecked: (value) {
                                  setState(() {
                                    whoSeeCheck2 = value ? true : false;

                                    //Add group to this collection
                                    if (whoSeeCheck2 == true) {
                                      GlobalVariables.allSelectedGroups.add({
                                        "GroupName": "Mentors",
                                        "GroupSize": sparkUpModel!.numM,
                                      });
                                    } else {
                                      //Remove group from this collection
                                      try {
                                        if (GlobalVariables
                                            .allSelectedGroups.isNotEmpty) {
                                          for (Map<String, dynamic> sGroup
                                              in GlobalVariables
                                                  .allSelectedGroups) {
                                            if (sGroup
                                                .containsValue("Mentors")) {
                                              GlobalVariables.allSelectedGroups
                                                  .remove(sGroup);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        e.toString();
                                      }
                                    }
                                  });
                                },
                              ),
                              //TUTEES
                              WhoSeePostCard(
                                sparKGroup: "TUTEES",
                                sparkGroupSize: sparkUpModel!.numTe,
                                checked: whoSeeCheck3,
                                isSelected: whoSeeCheck3,
                                isChecked: (value) {
                                  setState(() {
                                    whoSeeCheck3 = value ? true : false;

                                    //Add group to this collection
                                    if (whoSeeCheck3 == true) {
                                      GlobalVariables.allSelectedGroups.add({
                                        "GroupName": "Tutees",
                                        "GroupSize": sparkUpModel!.numTe,
                                      });
                                    } else {
                                      //Remove group from this collection
                                      try {
                                        if (GlobalVariables
                                            .allSelectedGroups.isNotEmpty) {
                                          for (Map<String, dynamic> sGroup
                                              in GlobalVariables
                                                  .allSelectedGroups) {
                                            if (sGroup
                                                .containsValue("Tutees")) {
                                              GlobalVariables.allSelectedGroups
                                                  .remove(sGroup);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        e.toString();
                                      }
                                    }
                                  });
                                },
                              ),
                              //MENTEE
                              WhoSeePostCard(
                                sparKGroup: "MENTEES",
                                sparkGroupSize: sparkUpModel!.numMe,
                                checked: whoSeeCheck4,
                                isSelected: whoSeeCheck4,
                                isChecked: (value) {
                                  setState(() {
                                    whoSeeCheck4 = value ? true : false;

                                    //Add group to this collection
                                    if (whoSeeCheck4 == true) {
                                      GlobalVariables.allSelectedGroups.add({
                                        "GroupName": "Mentees",
                                        "GroupSize": sparkUpModel!.numMe,
                                      });
                                    } else {
                                      //Remove group from this collection
                                      try {
                                        if (GlobalVariables
                                            .allSelectedGroups.isNotEmpty) {
                                          for (Map<String, dynamic> sGroup
                                              in GlobalVariables
                                                  .allSelectedGroups) {
                                            if (sGroup
                                                .containsValue("Mentees")) {
                                              GlobalVariables.allSelectedGroups
                                                  .remove(sGroup);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        e.toString();
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        }

                        return Center(
                          child: Text("Loading..."),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FlatButton(
                      color: kProfile,
                      onPressed: () {
                        Navigator.pop(
                            context, GlobalVariables.allSelectedGroups);
                      },
                      child: Text(
                        kClose,
                        style: TextStyle(
                          color: kWhiteColour,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          fontSize: kFont_size_18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return seeMyPost;
  }

  //Sending a post request if and only if the type of post created is of type PostType.TEXT_POST
  sendTextPostRequest(BuildContext context, PostCustomBg defaultPostBg) async {
    Map<String, dynamic> textPostSettings =
        CustomFunctions.getTextPostCustomSettings(defaultPostBg);

    if ((textPostSettings['User post'] == "") ||
        (textPostSettings['User post'] == null)) {
      //TODO; Display a toast.
      Fluttertoast.showToast(
        msg: kText_Post_Error_Mgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: kLight_orange,
        textColor: kWhiteColour,
        fontSize: kSize_16.sp,
      );
    } else if ((GlobalVariables.allSelectedGroups.isEmpty) ||
        (GlobalVariables.allSelectedGroups == null)) {
      //TODO; Display a toast.
      Fluttertoast.showToast(
        msg: kWho_see_my_post,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: kLight_orange,
        textColor: kWhiteColour,
        fontSize: kSize_16.sp,
      );
    } else {
      //TODO: A list of list containing uids that is less than or equal to 10,000. Eg list of friends uid etc
      List<List<String?>> listOfGroupUIDs =
          await CustomFunctions.listOfIDs(GlobalVariables.allSelectedGroups);

      //TODO: Generate an id that serves as a delete key for a particular post.
      String postDeleteID = DateTime.now().millisecondsSinceEpoch.toString();

      //Push the every post to the database
      for (List<String?> groupOfIds in listOfGroupUIDs) {
        //TODO: Create an object model from post created.
        TextPostModel textPostModel = TextPostModel(
          aID: GlobalVariables.loggedInUserObject.id,
          nm: GlobalVariables.loggedInUserObject.nm,
          auPimg: GlobalVariables.loggedInUserObject.pimg,
          auSpec: GlobalVariables.loggedInUserObject.spec![0],
          friID:
              groupOfIds, // friID represents both friend id, tutor id, mentor id, tutee id and mentee id
          text: textPostSettings["User post"],
          txtC: textPostSettings["Font colour"].value,
          bgImg: textPostSettings["Background image"],
          fontS: textPostSettings["Font size"],
          fonFa: textPostSettings["Font family"],
          cln: {
            "cty": GlobalVariables.loggedInUserObject.addr!["cty"],
            "st": GlobalVariables.loggedInUserObject.addr!["st"]
          },
          postT: "Text",
          postId: "",
          nOfLikes: 0,
          nOfCmts: 0,
          nOfShs: 0,
          likeP: false,
          delID: postDeleteID,
          ptc: DateTime.now(),
        );

        //TODO: Push/upload user's post to the database.
        DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .createNewUserTextPost(textPostModel);
      }

      //TODO: show a success message to the user when the post button is clicked.
      Fluttertoast.showToast(
        msg: kText_Post_Success_mgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: kToastSuccessColour,
        textColor: kWhiteColour,
        fontSize: kSize_16.sp,
      );

      Navigator.pushNamed(context, SparksLandingScreen.id);
    }
  }

  //Sending a post request if and only if the type of post created is of type PostType.CAMERA_POST
  sendingCameraPostRequest(
      BuildContext context, File? mainFile, String? fileAbsPath) async {
    if (mainFile == null) {
      //TODO; Display a toast.
      Fluttertoast.showToast(
        msg: kCamera_post_err_mgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: kLight_orange,
        textColor: kWhiteColour,
        fontSize: kSize_16.sp,
      );
    } else {
      //TODO: A list of list containing uids that is less than or equal to 10,000. Eg list of friends uid etc
      List<List<String?>> listOfGroupUIDs =
          await CustomFunctions.listOfIDs(GlobalVariables.allSelectedGroups);

      //TODO: Generate an id that serves as a delete key for a particular post.
      String postDeleteID = DateTime.now().millisecondsSinceEpoch.toString();

      //TODO: Get the file name as a string
      String mediaFileName = fileAbsPath!.split("/").last;

      //TODO: Upload the media file to firebase cloud storage.
      StorageService(userID: GlobalVariables.loggedInUserObject.id)
          .uploadMediaFile(
        mediaFileName,
        mainFile,
        postDeleteID,
        listOfGroupUIDs,
      );

      //TODO: show a success message to the user when the post button is clicked.
      Fluttertoast.showToast(
        msg: kText_Post_Success_mgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: kToastSuccessColour,
        textColor: kWhiteColour,
        fontSize: kSize_16.sp,
      );

      Navigator.pushNamed(context, SparksLandingScreen.id);
    }
  }
}
