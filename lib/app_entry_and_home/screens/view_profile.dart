import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_mm.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_tt.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/spark_up_receiver_card.dart';
import 'package:sparks/app_entry_and_home/reusables/photo_manager.dart';
import 'package:sparks/app_entry_and_home/reusables/spark_request.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/spark_up_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ViewProfile extends StatefulWidget {
  static const String id = kView_profile;

  final String? profileId;
  final String? profileStatus;

  ViewProfile({
    this.profileId,
    this.profileStatus,
  });

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String? getSparkUpState = "";
  String? getSparkUpStateTutor = "";
  String? getSparkUpStateMentor = "";
  Widget acceptRequest = Text("Accept spark up request.");
  List<Widget> receivedWidegt = [];
  List<String>? listOfReceivedData = [];

  double width = 460.0;
  double height = 100.0;

  //Variables holding the default text for accepting spark up request ( friend, tutor, mentor )
  String acceptFriend = "Accept";
  String acceptTutor = "Accept";
  String acceptMentor = "Accept";

  //Default button type
  SparkUpRequest buttonType = SparkUpRequest.FRIEND;
  String requestTypeButton = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //TODO: Fetch the state of every current request made ( friend request )
  Future<String?> _getCurrentSparkUpState(String? profileBeenViewed) async {
    String? currentSparkUpState = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .sparkUpRequestState(profileBeenViewed);

    return currentSparkUpState;
  }

  //TODO: check if there is a pending request that needs a response
  Future<List<String>> isRequestPending(
      String? profileUID, String? loggedUserStatus) async {
    List<String> listOfRequestType = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .fetchRequestMarkedReceived(profileUID, loggedUserStatus);

    return listOfRequestType;
  }

  //TODO: Fetch the state of every current request made ( tutor request )
  Future<String?> _getCurrentSparkUpStateForTutor(
      String? profileBeenViewed) async {
    String? currentSparkUpState = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .sparkUpRequestStateForTutor(profileBeenViewed);

    return currentSparkUpState;
  }

  //TODO: Fetch the state of every current request made ( Mentor request )
  Future<String?> _getCurrentSparkUpStateForMentor(
      String? profileBeenViewed) async {
    String? currentSparkUpState = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .sparkUpRequestStateForMentor(profileBeenViewed);

    return currentSparkUpState;
  }

  //TODO: Accepting any spark up request
  _acceptingRequestFromUsers(String statusType) async {
    if (statusType == "Mentor") {
      await DatabaseService(
              loggedInUserID: GlobalVariables.loggedInUserObject.id)
          .acceptingSparkUpRequestMentor(widget.profileId);

      //Subscribing both uid to their respective fcm topics
      String senderToReceiverTopic =
          "${GlobalVariables.loggedInUserObject.id}_mentors";
      String receiverToSenderTopic = "${widget.profileId}_mentees";

      _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
      _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);
    } else if (statusType == "Tutor") {
      await DatabaseService(
              loggedInUserID: GlobalVariables.loggedInUserObject.id)
          .acceptingSparkUpRequestTutor(widget.profileId);

      //Subscribing both uid to their respective fcm topics
      String senderToReceiverTopic =
          "${GlobalVariables.loggedInUserObject.id}_tutors";
      String receiverToSenderTopic = "${widget.profileId}_tutees";

      _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
      _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);
    } else if (statusType == "Friend") {
      await DatabaseService(
              loggedInUserID: GlobalVariables.loggedInUserObject.id)
          .acceptingSparkUpRequest(widget.profileId);

      //Subscribing both uid to their respective fcm topics
      String senderToReceiverTopic =
          "${GlobalVariables.loggedInUserObject.id}_friends";
      String receiverToSenderTopic = "${widget.profileId}_friends";

      _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
      _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);
    }
  }

  //TODO: This function handles all activities associated with sending and accepting spark mentor request
  Future<void> handlingSparkMentorMenteeRequest(
      String? requestResponseState, String requestBtnType) async {
    switch (requestResponseState) {
      case "REQUEST SENT":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .cancelSparkUpRequestMentor(widget.profileId);

        break;
      case "RECEIVED":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .acceptingSparkUpRequestMentor(widget.profileId);

        //Subscribing both uid to their respective fcm topics
        String senderToReceiverTopic =
            "${GlobalVariables.loggedInUserObject.id}_mentors";
        String receiverToSenderTopic = "${widget.profileId}_mentees";

        _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
        _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);

        break;
      case "CONFIRMED":
        break;
      default:
        //TODO: Send a mentor request
        List<CreateSparkUpMM> preparingMentorRequest =
            CustomFunctions.creatingMentorMenteeRequestData(
          GlobalVariables.loggedInUserObject.id,
          widget.profileId,
          widget.profileStatus,
          GlobalVariables.viewingProfileInfo.nm,
          GlobalVariables.viewingProfileInfo.pimg,
          GlobalVariables.viewingProfileInfo.em,
        );

        await DatabaseService(
          loggedInUserID: GlobalVariables.loggedInUserObject.id,
        ).sendingSparkUpRequestMentor(
            preparingMentorRequest, widget.profileId, requestBtnType);

        //TODO: Send a success message after sending the spark up request
        Fluttertoast.showToast(
            msg: kSparkUp_mentor_request_sent,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: kToastSuccessColour,
            textColor: kWhiteColour,
            fontSize: kSize_16.sp);
    }

    Navigator.of(context).pop();
  }

  //TODO: This function handles all activities associated with sending and accepting spark tutor request
  Future<void> handlingSparkTutorTuteeRequest(
      String? requestResponseState, String requestBtnType) async {
    switch (requestResponseState) {
      case "REQUEST SENT":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .cancelSparkUpRequestTutor(widget.profileId);

        break;
      case "RECEIVED":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .acceptingSparkUpRequestTutor(widget.profileId);

        //Subscribing both uid to their respective fcm topics
        String senderToReceiverTopic =
            "${GlobalVariables.loggedInUserObject.id}_tutors";
        String receiverToSenderTopic = "${widget.profileId}_tutees";

        _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
        _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);

        break;
      case "CONFIRMED":
        break;
      default:
        //TODO: Sending tutor request
        List<CreateSparkUpTT> preparingTutorRequest =
            CustomFunctions.creatingTutorTuteeRequestData(
          GlobalVariables.loggedInUserObject.id,
          widget.profileId,
          widget.profileStatus,
          GlobalVariables.viewingProfileInfo.nm,
          GlobalVariables.viewingProfileInfo.pimg,
          GlobalVariables.viewingProfileInfo.em,
        );

        await DatabaseService(
          loggedInUserID: GlobalVariables.loggedInUserObject.id,
        ).sendingSparkUpRequestTutor(
            preparingTutorRequest, widget.profileId, requestBtnType);

        //TODO: Send a success message after sending the spark up request
        Fluttertoast.showToast(
            msg: kSparkUp_tutor_request_sent,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: kToastSuccessColour,
            textColor: kWhiteColour,
            fontSize: kSize_16.sp);
    }

    Navigator.of(context).pop();
  }

  //TODO: This function handles all activities associated with sending and accepting spark friend request
  Future<void> handlingSparkFriendRequest(
      String? requestResponseState, String requestBtnType) async {
    switch (requestResponseState) {
      case "REQUEST SENT":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .cancelSparkUpRequest(widget.profileId);
        break;
      case "RECEIVED":
        await DatabaseService(
                loggedInUserID: GlobalVariables.loggedInUserObject.id)
            .acceptingSparkUpRequest(widget.profileId);

        //Subscribing both uid to their respective fcm topics
        String senderToReceiverTopic =
            "${GlobalVariables.loggedInUserObject.id}_friends";
        String receiverToSenderTopic = "${widget.profileId}_friends";

        _firebaseMessaging.subscribeToTopic(senderToReceiverTopic);
        _firebaseMessaging.subscribeToTopic(receiverToSenderTopic);

        break;
      case "CONFIRMED":
        break;
      default:
        //TODO: Sending friend request
        List<CreateSparkUp> preparingFriendRequest =
            CustomFunctions.creatingFriendRequestData(
          GlobalVariables.loggedInUserObject.id,
          widget.profileId,
          widget.profileStatus,
          GlobalVariables.viewingProfileInfo.nm,
          GlobalVariables.viewingProfileInfo.pimg,
          GlobalVariables.viewingProfileInfo.em,
        );

        await DatabaseService(
          loggedInUserID: GlobalVariables.loggedInUserObject.id,
        ).sendingSparkUpRequest(
            preparingFriendRequest, widget.profileId, requestBtnType);

        //TODO: Send a success message after sending the spark up request
        Fluttertoast.showToast(
            msg: kSparkUp_friend_request_sent,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: kToastSuccessColour,
            textColor: kWhiteColour,
            fontSize: kSize_16.sp);
    }

    Navigator.of(context).pop();
  }

  //TODO: Displays the list of hobbies as a chip
  List<Widget> _seeMyHobbies(BuildContext context, List<String?> myHobbies) {
    List<Widget> addHobbies = [];
    Widget hobbiesLogo = Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        SvgPicture.asset(
          "images/app_entry_and_home/new_images/profile_hobbies_icon.svg",
          width: MediaQuery.of(context).size.width * 0.048,
          height: MediaQuery.of(context).size.height * 0.048,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
      ],
    );
    addHobbies.add(hobbiesLogo);

    for (String? hobbies in myHobbies) {
      Widget userHobby = Row(
        children: <Widget>[
          Chip(
            label: Text(
              hobbies!,
              style: Theme.of(context).textTheme.headline6!.apply(
                    color: kWhiteColour,
                    fontSizeFactor: 0.5,
                    fontSizeDelta: 4,
                  ),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: kHintColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: kBlackColour,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
        ],
      );

      addHobbies.add(userHobby);
    }

    return addHobbies;
  }

  //TODO: Render a bottom sheet for the sole purpose of sending sparks request
  openSparksRequestBottomSheet(BuildContext context, String? userStatus) {
    showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return Container(
            color: Colors.transparent,
            margin: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      kSendSparksRequest,
                      style: Theme.of(context).textTheme.headline6!.apply(
                            fontSizeFactor: 0.5,
                            fontSizeDelta: 6,
                            color: kLight_orange,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //TODO: Setting up the various types of Sparks request
                  userStatus == "FRIEND"
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                            horizontal: 0.5,
                            vertical: 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: FutureBuilder<String?>(
                                  future:
                                      _getCurrentSparkUpState(widget.profileId),
                                  builder: (context, snapshot) {
                                    if ((snapshot.connectionState ==
                                            ConnectionState.done) &&
                                        (snapshot.hasData)) {
                                      getSparkUpState = snapshot.data;
                                    }

                                    return SparksRequestButton(
                                      buttonName: getSparkUpState == "CONFIRMED"
                                          ? "Block Friend"
                                          : getSparkUpState == "RECEIVED"
                                              ? "Accept Friend Request"
                                              : getSparkUpState ==
                                                      "REQUEST SENT"
                                                  ? "Cancel Friend Request"
                                                  : kSendFriendRequest,
                                      fontSize: 5,
                                      requestTypeSent: () async {
                                        setState(() {
                                          if (buttonType ==
                                              SparkUpRequest.FRIEND) {
                                            requestTypeButton = "Friend";
                                          }
                                        });

                                        await handlingSparkFriendRequest(
                                            getSparkUpState, requestTypeButton);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : userStatus == "TUTOR"
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                horizontal: 0.5,
                                vertical: 0.5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: FutureBuilder<String?>(
                                      future: _getCurrentSparkUpState(
                                          widget.profileId),
                                      builder: (context, snapshot) {
                                        if ((snapshot.connectionState ==
                                                ConnectionState.done) &&
                                            (snapshot.hasData)) {
                                          getSparkUpState = snapshot.data;
                                        }

                                        return SparksRequestButton(
                                          buttonName: getSparkUpState ==
                                                  "CONFIRMED"
                                              ? "Block Friend"
                                              : getSparkUpState == "RECEIVED"
                                                  ? "Accept Friend Request"
                                                  : getSparkUpState ==
                                                          "REQUEST SENT"
                                                      ? "Cancel Friend Request"
                                                      : kSendFriendRequest,
                                          fontSize: 5,
                                          requestTypeSent: () async {
                                            setState(() {
                                              if (buttonType ==
                                                  SparkUpRequest.FRIEND) {
                                                requestTypeButton = "Friend";
                                              }
                                            });
                                            await handlingSparkFriendRequest(
                                                getSparkUpState,
                                                requestTypeButton);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: FutureBuilder<String?>(
                                      future: _getCurrentSparkUpStateForTutor(
                                          widget.profileId),
                                      builder: (context, snapshot) {
                                        if ((snapshot.connectionState ==
                                                ConnectionState.done) &&
                                            (snapshot.hasData)) {
                                          getSparkUpStateTutor = snapshot.data;
                                        }

                                        return SparksRequestButton(
                                          buttonName: getSparkUpStateTutor ==
                                                  "CONFIRMED"
                                              ? "Block Tutor"
                                              : getSparkUpStateTutor ==
                                                      "RECEIVED"
                                                  ? "Accept Tutor Request"
                                                  : getSparkUpStateTutor ==
                                                          "REQUEST SENT"
                                                      ? "Cancel Tutor Request"
                                                      : kSendTutorRequest,
                                          fontSize: 5,
                                          requestTypeSent: () async {
                                            buttonType = SparkUpRequest.TUTOR;
                                            setState(() {
                                              if (buttonType ==
                                                  SparkUpRequest.TUTOR) {
                                                requestTypeButton = "Tutor";
                                              }
                                            });
                                            await handlingSparkTutorTuteeRequest(
                                                getSparkUpStateTutor,
                                                requestTypeButton);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : userStatus == "MENTOR"
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 0.5,
                                    vertical: 0.5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: FutureBuilder<String?>(
                                          future: _getCurrentSparkUpState(
                                              widget.profileId),
                                          builder: (context, snapshot) {
                                            if ((snapshot.connectionState ==
                                                    ConnectionState.done) &&
                                                (snapshot.hasData)) {
                                              getSparkUpState = snapshot.data;
                                            }

                                            return SparksRequestButton(
                                              buttonName: getSparkUpState ==
                                                      "CONFIRMED"
                                                  ? "Block Friend"
                                                  : getSparkUpState ==
                                                          "RECEIVED"
                                                      ? "Accept Friend Request"
                                                      : getSparkUpState ==
                                                              "REQUEST SENT"
                                                          ? "Cancel Friend Request"
                                                          : kSendFriendRequest,
                                              fontSize: 5,
                                              requestTypeSent: () async {
                                                setState(() {
                                                  if (buttonType ==
                                                      SparkUpRequest.FRIEND) {
                                                    requestTypeButton =
                                                        "Friend";
                                                  }
                                                });
                                                await handlingSparkFriendRequest(
                                                    getSparkUpState,
                                                    requestTypeButton);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: FutureBuilder<String?>(
                                          future:
                                              _getCurrentSparkUpStateForTutor(
                                                  widget.profileId),
                                          builder: (context, snapshot) {
                                            if ((snapshot.connectionState ==
                                                    ConnectionState.done) &&
                                                (snapshot.hasData)) {
                                              getSparkUpStateTutor =
                                                  snapshot.data;
                                            }

                                            return SparksRequestButton(
                                              buttonName: getSparkUpStateTutor ==
                                                      "CONFIRMED"
                                                  ? "Block Tutor"
                                                  : getSparkUpStateTutor ==
                                                          "RECEIVED"
                                                      ? "Accept Tutor Request"
                                                      : getSparkUpStateTutor ==
                                                              "REQUEST SENT"
                                                          ? "Cancel Tutor Request"
                                                          : kSendTutorRequest,
                                              fontSize: 5,
                                              requestTypeSent: () async {
                                                buttonType =
                                                    SparkUpRequest.TUTOR;
                                                setState(() {
                                                  if (buttonType ==
                                                      SparkUpRequest.TUTOR) {
                                                    requestTypeButton = "Tutor";
                                                  }
                                                });
                                                await handlingSparkTutorTuteeRequest(
                                                    getSparkUpStateTutor,
                                                    requestTypeButton);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: FutureBuilder<String?>(
                                          future:
                                              _getCurrentSparkUpStateForMentor(
                                                  widget.profileId),
                                          builder: (context, snapshot) {
                                            if ((snapshot.connectionState ==
                                                    ConnectionState.done) &&
                                                (snapshot.hasData)) {
                                              getSparkUpStateMentor =
                                                  snapshot.data;
                                            }

                                            return SparksRequestButton(
                                              buttonName: getSparkUpStateMentor ==
                                                      "CONFIRMED"
                                                  ? "Block Mentor"
                                                  : getSparkUpStateMentor ==
                                                          "RECEIVED"
                                                      ? "Accept Mentor Request"
                                                      : getSparkUpStateMentor ==
                                                              "REQUEST SENT"
                                                          ? "Cancel Mentor Request"
                                                          : kSendMentorRequest,
                                              fontSize: 5,
                                              requestTypeSent: () async {
                                                buttonType =
                                                    SparkUpRequest.MENTOR;
                                                setState(() {
                                                  if (buttonType ==
                                                      SparkUpRequest.MENTOR) {
                                                    requestTypeButton =
                                                        "Mentor";
                                                  }
                                                });
                                                await handlingSparkMentorMenteeRequest(
                                                    getSparkUpStateMentor,
                                                    requestTypeButton);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String? userCurrentStatus = "";

    //TODO: Fetch the current status of the user profile being viewed
    if (GlobalVariables.viewingProfileInfo.id ==
        GlobalVariables.loggedInUserObject.id) {
      userCurrentStatus = GlobalVariables.basicProfileInfo.sts;
    } else {
      userCurrentStatus = widget.profileStatus;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColour,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: kProfile,
          ),
          backgroundColor: kWhiteColour,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: GlobalVariables.viewingProfileInfo.id ==
                    GlobalVariables.loggedInUserObject.id
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                    "images/app_entry_and_home/new_images/search_profile.svg"),
              ),
            ],
          ),
          actions: GlobalVariables.viewingProfileInfo.id ==
                  GlobalVariables.loggedInUserObject.id
              ? <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "images/app_entry_and_home/new_images/edit_profile.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ]
              : <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //TODO: Show profile image and special information.
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //TODO: Profile image.
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.15,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.048,
                            ),
                            child: CircleAvatar(
                              backgroundColor: kWhiteColour,
                              child: ClipOval(
                                child: GlobalVariables
                                            .viewingProfileInfo.pimg ==
                                        null
                                    ? Image.asset(
                                        "images/app_entry_and_home/profile_image.png")
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "${GlobalVariables.viewingProfileInfo.pimg}",
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                      ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: kProfile,
                              ),
                              child: userCurrentStatus == "FRIEND"
                                  ? TextButton(
                                      child: Text(
                                        kAdd_as_mentor,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              color: kWhiteColour,
                                              fontSizeFactor: 0.45,
                                              fontSizeDelta: 5,
                                            ),
                                      ),
                                      onPressed: () {
                                        ///Do something when a user request to be a mentor.
                                        print("Am now a mentor");
                                      },
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        ///Do nothing because the user is already a mentor.
                                      },
                                      child: Text(
                                        "$userCurrentStatus",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              color: kWhiteColour,
                                              fontSizeFactor: 0.5,
                                              fontSizeDelta: 5,
                                            ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TODO: Other profile information
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: GlobalVariables
                                                .viewingProfileInfo.nm!["fn"]! +
                                            " ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      TextSpan(
                                        text: GlobalVariables
                                            .viewingProfileInfo.nm!["ln"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              fontFamily: "RajdhaniMedium",
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///Display user's area of specialization
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Specialized in " +
                                        "${GlobalVariables.viewingProfileInfo.spec![0]}" +
                                        "...",
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .apply(
                                          color: kHintColor,
                                          fontWeightDelta: -2,
                                        ),
                                  ),
                                ),
                              ),
                            ),

                            ///Display user's location
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.location_on,
                                        color: kSky_blue,
                                        size: 15,
                                      ),
                                      padding: EdgeInsets.all(0.0),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  Text(
                                    "${GlobalVariables.viewingProfileInfo.addr!["st"]}, ${GlobalVariables.viewingProfileInfo.addr!["cty"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .apply(
                                          color: kHintColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            ///View the full profile info of a particular user or the current user.
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                kSee_more,
                                style:
                                    Theme.of(context).textTheme.caption!.apply(
                                          color: kSky_blue,
                                          fontWeightDelta: 2,
                                        ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                            ),
                            //TODO: Display view stories button
                            ///No longer for viewing stories but for sending spark request.
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                height:
                                    MediaQuery.of(context).size.height * 0.038,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: kProfile,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      kIgnite_the_spark,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .apply(
                                            fontSizeFactor: 1.5,
                                            fontSizeDelta: 0,
                                            color: kWhiteColour,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //TODO: Post and followers counters
              Container(
                width: MediaQuery.of(context).size.width,
                height: GlobalVariables.viewingProfileInfo.id ==
                        GlobalVariables.loggedInUserObject.id
                    ? MediaQuery.of(context).size.height * 0.15
                    : MediaQuery.of(context).size.height * 0.23,
                margin: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        CustomFunctions.numberFormatter(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .apply(
                                              color: kBlackColour,
                                            ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                        "POSTS",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              color: kHintColor,
                                              fontSizeFactor: 0.5,
                                              fontSizeDelta: 7,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        CustomFunctions.numberFormatter(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .apply(
                                              color: kBlackColour,
                                            ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                        kFollowers,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              color: kHintColor,
                                              fontSizeFactor: 0.5,
                                              fontSizeDelta: 7,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        CustomFunctions.numberFormatter(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .apply(
                                              color: kBlackColour,
                                            ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                        kFollowing,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .apply(
                                              color: kHintColor,
                                              fontSizeFactor: 0.5,
                                              fontSizeDelta: 7,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GlobalVariables.viewingProfileInfo.id ==
                              GlobalVariables.loggedInUserObject.id
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.04,
                                right: MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: Divider(
                                thickness: 1.0,
                                color: kButton_disabled,
                              ),
                            ),
                      GlobalVariables.viewingProfileInfo.id ==
                              GlobalVariables.loggedInUserObject.id
                          ? Container()
                          : Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                "images/app_entry_and_home/new_images/one_on_one_chat.svg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                kChat,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .apply(
                                                      fontSizeFactor: 0.35,
                                                      fontSizeDelta: 3,
                                                      color: kHintColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                "images/app_entry_and_home/new_images/audio_chat.svg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                kAudio_Call,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .apply(
                                                      fontSizeFactor: 0.35,
                                                      fontSizeDelta: 3,
                                                      color: kHintColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                "images/app_entry_and_home/new_images/video_chat.svg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                kVideo_call,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .apply(
                                                      fontSizeFactor: 0.35,
                                                      fontSizeDelta: 3,
                                                      color: kHintColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  //TODO: Making a Spark up request
                                                  openSparksRequestBottomSheet(
                                                      context,
                                                      userCurrentStatus);
                                                },
                                                child: SvgPicture.asset(
                                                  "images/app_entry_and_home/new_images/add_friend.svg",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.035,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.035,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                kSparks_up,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .apply(
                                                      fontSizeFactor: 0.35,
                                                      fontSizeDelta: 3,
                                                      color: kHintColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                "images/app_entry_and_home/new_images/more.svg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                kMore_Always,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .apply(
                                                      fontSizeFactor: 0.35,
                                                      fontSizeDelta: 3,
                                                      color: kHintColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //TODO: Display friend, tutor and mentor pending request(s)
              GlobalVariables.viewingProfileInfo.id !=
                      GlobalVariables.loggedInUserObject.id
                  ? acceptFriend == "Accept" ||
                          acceptFriend == "Accepted" ||
                          acceptTutor == "Accept" ||
                          acceptTutor == "Accepted" ||
                          acceptMentor == "Accept" ||
                          acceptMentor == "Accepted"
                      ? FutureBuilder<List<String>>(
                          future: isRequestPending(widget.profileId,
                              GlobalVariables.basicProfileInfo.sts),
                          builder: (context, snapshot) {
                            if ((snapshot.connectionState ==
                                    ConnectionState.done) &&
                                (snapshot.hasData)) {
                              listOfReceivedData = snapshot.data;

                              receivedWidegt.clear();
                            }

                            for (String receivedData in listOfReceivedData!) {
                              if (receivedData == "friend") {
                                receivedWidegt.add(
                                  SparkUpReceiverCard(
                                    width: width,
                                    height: height,
                                    profileImg:
                                        "${GlobalVariables.viewingProfileInfo.pimg}",
                                    name:
                                        "${GlobalVariables.viewingProfileInfo.nm!["fn"]} ${GlobalVariables.viewingProfileInfo.nm!["ln"]}",
                                    message: " Accept friend request.",
                                    acceptText: acceptFriend == "Accept"
                                        ? "Accept"
                                        : "Accepted",
                                    acceptRequest: () async {
                                      setState(() {
                                        acceptFriend = "Accepted";

                                        receivedWidegt.clear();
                                      });
                                      await _acceptingRequestFromUsers(
                                          "Friend");
                                    },
                                  ),
                                );
                              } else if (receivedData == "tutee") {
                                receivedWidegt.add(
                                  SparkUpReceiverCard(
                                    width: width,
                                    height: height,
                                    profileImg:
                                        "${GlobalVariables.viewingProfileInfo.pimg}",
                                    name:
                                        "${GlobalVariables.viewingProfileInfo.nm!["fn"]} ${GlobalVariables.viewingProfileInfo.nm!["ln"]}",
                                    message: " Accept tutor request.",
                                    acceptText: acceptTutor == "Accept"
                                        ? "Accept"
                                        : "Accepted",
                                    acceptRequest: () async {
                                      setState(() {
                                        acceptTutor = "Accepted";

                                        receivedWidegt.clear();
                                      });
                                      await _acceptingRequestFromUsers("Tutor");
                                    },
                                  ),
                                );
                              } else if (receivedData == "mentee") {
                                receivedWidegt.add(
                                  SparkUpReceiverCard(
                                    width: width,
                                    height: height,
                                    profileImg:
                                        "${GlobalVariables.viewingProfileInfo.pimg}",
                                    name:
                                        "${GlobalVariables.viewingProfileInfo.nm!["fn"]} ${GlobalVariables.viewingProfileInfo.nm!["ln"]}",
                                    message: " Accept mentor request.",
                                    acceptText: acceptMentor == "Accept"
                                        ? "Accept"
                                        : "Accepted",
                                    acceptRequest: () async {
                                      setState(() {
                                        acceptMentor = "Accepted";

                                        receivedWidegt.clear();
                                      });

                                      await _acceptingRequestFromUsers(
                                          "Mentor");
                                    },
                                  ),
                                );
                              }
                            }

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: AutoScrollController(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.005,
                                        ),
                                        child: Text(
                                          receivedWidegt.length != 0
                                              ? "You have ${receivedWidegt.length} pending request(s)."
                                              : "You have no pending request(s).",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .apply(
                                                fontSizeFactor: 0.8,
                                                fontWeightDelta: 2,
                                                color: kBlackcolor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: receivedWidegt,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container()
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //TODO: Display user's hobbies
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _seeMyHobbies(
                      context, GlobalVariables.viewingProfileInfo.hobb!),
                ),
              ),
              //TODO: Display all the pictures the user has uploaded since joining Sparks
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.all(12.0),
                child: Text(
                  kMy_pictures,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              PhotoManager(
                photoAlbum: [
                  AssetImage("images/app_entry_and_home/photo_album/space.jpg"),
                  AssetImage(
                      "images/app_entry_and_home/photo_album/france.jpg"),
                  AssetImage(
                      "images/app_entry_and_home/photo_album/nature12.jpg"),
                  AssetImage(
                      "images/app_entry_and_home/photo_album/spacex1.jpg"),
                  AssetImage(
                      "images/app_entry_and_home/photo_album/spacex4.jpg"),
                  AssetImage(
                      "images/app_entry_and_home/photo_album/nature.jpg"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
