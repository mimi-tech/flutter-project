import 'dart:async';
import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/models/home_notification.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/reusables/add_story_card.dart';
import 'package:sparks/app_entry_and_home/reusables/display_user_story_card.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_tv_content.dart';
import 'package:sparks/app_entry_and_home/screens/home_notification.dart';
import 'package:sparks/app_entry_and_home/screens/post.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/jobs/screens/jobs.dart';

class HomeAppBarWithCustomScrollView extends StatefulWidget {
  final ImageProvider? profileImageUrl;
  String? accName;

  HomeAppBarWithCustomScrollView({
    this.profileImageUrl,
    this.accName,
  });

  @override
  _HomeAppBarWithCustomScrollViewState createState() =>
      _HomeAppBarWithCustomScrollViewState();
}

class _HomeAppBarWithCustomScrollViewState
    extends State<HomeAppBarWithCustomScrollView> {
  List<DocumentSnapshot> myIncomingFeeds = [];
  ScrollController _feedScrollController = AutoScrollController();
  DocumentSnapshot? _lastDocument;
  late Future<DocumentSnapshot<Map<String, dynamic>>> loggedInUserInfo;
  Future<dynamic>? loadFeeds;
  bool _gettingMoreFeeds = false;
  bool _moreAvailableFeeds = true;
  StreamController<List<DocumentSnapshot>> _postFeedStreamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _postFeedDocumentList = [];
  late Widget postFeedStreamBuilder;

  int check = 0;
  bool shouldCheck = false;
  bool shouldRunCheck = true;

  bool shouldRunFirstTen = true;

  late List<Widget> feed = [];
  DocumentSnapshot? lDoc;

  int? notificationCounter;
  String? notCounter;
  String? _dropdownMenuSelected = "MATCHES";

  //TODO: Fetch the first five post from myPost collections
  Future fetchFirstFivePost() async {
    FirebaseFirestore.instance
        .collectionGroup("myPost")
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    _postFeedDocumentList = (await FirebaseFirestore.instance
            .collectionGroup("myPost")
            .where("friID",
                arrayContains: GlobalVariables.loggedInUserObject.id)
            .orderBy("ptc", descending: true)
            .limit(5)
            .get())
        .docs;

    _postFeedDocumentList.sort((b, a) => a['postId'].compareTo(b['postId']));

    _postFeedDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_postFeedDocumentList).toList();

    if (mounted) {
      setState(() {
        _postFeedStreamController.add(_postFeedDocumentList);
      });
    }
  }

  //TODO: Fetch the next five post
  fetchNextFivePosts() async {
    if (shouldCheck) {
      shouldRunCheck = false;
      shouldCheck = false;

      check++;

      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collectionGroup("myPost")
              .where("friID",
                  arrayContains: GlobalVariables.loggedInUserObject.id)
              .orderBy("ptc", descending: true)
              .startAfterDocument(
                  _postFeedDocumentList[_postFeedDocumentList.length - 1])
              .limit(5)
              .get())
          .docs;

      _postFeedDocumentList.addAll(newDocumentList);

      sortAndRemoveDuplicates();

      setState(() {
        _postFeedStreamController.add(_postFeedDocumentList);
      });
    }
  }

  //TODO: Takes a list of comments, sorts through it and remove duplicates
  void sortAndRemoveDuplicates() {
    _postFeedDocumentList.sort((b, a) => a['postId'].compareTo(b['postId']));

    _postFeedDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_postFeedDocumentList).toList();

    for (int i = 0; i < _postFeedDocumentList.length; i++) {
      if (i == 0 && _postFeedDocumentList.length > 1) {
        if (_postFeedDocumentList[i]['postId'] ==
            _postFeedDocumentList[i + 1]['postId']) {
          _postFeedDocumentList.removeAt(i);
        }
      }
      if (i == _postFeedDocumentList.length - 1 &&
          _postFeedDocumentList.length > 1) {
        if (_postFeedDocumentList[i]['postId'] ==
            _postFeedDocumentList[i - 1]['postId']) {
          _postFeedDocumentList.removeAt(i);
        }
      }
      if (i != 0 && i != _postFeedDocumentList.length - 1) {
        if (_postFeedDocumentList[i]['postId'] ==
            _postFeedDocumentList[i + 1]['postId']) {
          _postFeedDocumentList.removeAt(i);
        }
      }
    }
  }

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;

    documentChanges.forEach((change) {
      if (change.type == DocumentChangeType.removed) {
        _postFeedDocumentList.removeWhere((post) {
          return change.doc.id == post.id;
        });

        isChange = true;
      } else if (change.type == DocumentChangeType.modified) {
        int indexWhere = _postFeedDocumentList.indexWhere((post) {
          return change.doc.id == post.id;
        });

        if (indexWhere >= 0) {
          _postFeedDocumentList[indexWhere] = change.doc;
        }

        isChange = true;
      } else if (change.type == DocumentChangeType.added) {
        int indexWhere = _postFeedDocumentList.indexWhere((post) {
          return change.doc.id == post.id;
        });

        if (indexWhere >= 0) {
          //_commentDocumentList.removeAt(indexWhere);
        }

        _postFeedDocumentList.add(change.doc);

        isChange = true;
      }
    });

    if (isChange) {
      sortAndRemoveDuplicates();

      if (mounted) {
        setState(() {
          _postFeedStreamController.add(_postFeedDocumentList);
        });
      }
    }
  }

  //TODO: Initializes the postFeed streambuilder inside the initstate
  init() {
    postFeedStreamBuilder = StreamBuilder(
      stream: _postFeedStreamController.stream,
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.waiting) &&
            (!snapshot.hasData)) {
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }

        feed.clear();
        _postFeedDocumentList.forEach((content) {
          feed.add(CustomFunctions.feedWidget(
              context, content as Map<String, dynamic>));
        });

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: feed,
        );
      },
    );
  }

  //TODO: Calling notification tracker. It tells us when the notification screen is visible or not
/*  _notificationTracker() async {
    User sparksUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot dtst = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .currentNotificationCounter();

    if (dtst.data()["notCts"] == null) {
      await DatabaseService(loggedInUserID: sparksUser.uid).notificationMonitor(
        HomeNotifications(notCts: 0, actSrn: false),
      );
    } else {
      int nCounter = dtst.data()["notCts"];
      await DatabaseService(loggedInUserID: sparksUser.uid).notificationMonitor(
        HomeNotifications(notCts: nCounter, actSrn: false),
      );
    }
  }*/

  //TODO: Get the details of the logged in user
  Future<DocumentSnapshot<Map<String, dynamic>>> _getLoggedInUserInfo() async {
    User sparksUser = FirebaseAuth.instance.currentUser!;
    return await DatabaseService(loggedInUserID: sparksUser.uid)
        .loggedInUserProfileWithDefaultAccount(widget.accName!);
  }

  @override
  void initState() {
    //TODO: Add a listener to the _feedScrollController
    _feedScrollController.addListener(() {
      double maxScroll = _feedScrollController.position.maxScrollExtent;
      double currentScroll = _feedScrollController.position.pixels;
      double percentageScrollReached = MediaQuery.of(context).size.height;

      if (maxScroll - currentScroll <= percentageScrollReached) {
        shouldCheck = true;

        if (shouldRunCheck) {
          fetchNextFivePosts();
        }
      } else {
        shouldRunCheck = true;
      }
    });

    loggedInUserInfo = _getLoggedInUserInfo();

    init();

    Timer(Duration(seconds: 2), () {
      fetchFirstFivePost(); // Call this function to get the first set of post.
    });

    //TODO: Initializing notification tracker
    //_notificationTracker();

    super.initState();
  }

  @override
  void dispose() {
    _feedScrollController.dispose();
    _postFeedStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: loggedInUserInfo,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.active) &&
              (snapshot.hasData == false)) {
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: kFormLabelColour,
                ),
              ),
            );
          } else if ((snapshot.connectionState == ConnectionState.done) &&
              (snapshot.hasData == true)) {
            //TODO: Create a SparksUser object from the snapshot.
            DocumentSnapshot<Map<String, dynamic>> personalData =
                snapshot.data!;
            SparksUser user = SparksUser.fromJson(personalData.data()!);

            return NestedScrollView(
              controller: _feedScrollController,
              physics: BouncingScrollPhysics(
                parent: ScrollPhysics(),
              ),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  //TODO: Display an appBar for home menu.
                  SliverAppBar(
                    title: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Image.asset("images/app_entry_and_home/brand.png"),
                    ),
                    titleSpacing: 0.0,
                    backgroundColor: kLight_orange,
                    floating: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    automaticallyImplyLeading: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          15.0,
                        ),
                        bottomRight: Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          DocumentSnapshot<Map<String, dynamic>> dst =
                              await CustomFunctions.viewingThisUserProfile(
                                  accountGateWay.id, "Personal");
                          SparksUser sUser = SparksUser.fromJson(dst.data()!);
                          GlobalVariables.viewingProfileInfo = sUser;

                          ///Take the user to the profile screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewProfile();
                              },
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: kWhiteColour,
                          backgroundImage: widget.profileImageUrl,
                          maxRadius: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "images/app_entry_and_home/new_images/sparks_chat.svg",
                          width: MediaQuery.of(context).size.width * 0.025,
                          height: MediaQuery.of(context).size.height * 0.030,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "images/app_entry_and_home/search.svg",
                          width: MediaQuery.of(context).size.width * 0.025,
                          height: MediaQuery.of(context).size.height * 0.030,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                    ],

                    //TODO: Second App Bar
                    bottom: AppBar(
                      title: DropdownButton<String>(
                        value: _dropdownMenuSelected,
                        underline: Container(),
                        iconEnabledColor: kWhiteColour,
                        dropdownColor: kLight_orange,
                        items: <String>["MATCHES", "SPARKING"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style:
                                  Theme.of(context).textTheme.headline6!.apply(
                                        color: kWhiteColour,
                                        fontWeightDelta: 2,
                                      ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _dropdownMenuSelected = value;
                          });
                        },
                      ),
                      backgroundColor: kLight_orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            15.0,
                          ),
                          bottomRight: Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        //TODO: Displaying sparking icon and the counter
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeNotificationsScreen(
                                  actSrn: true,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              //TODO: Displaying sparking icon
                              IconButton(
                                icon: SvgPicture.asset(
                                  "images/app_entry_and_home/new_images/sparking.svg",
                                  width: 28.0,
                                  height: 28.0,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerRight,
                                ),
                                iconSize: 30.0,
                                onPressed: () {},
                              ),
                              //TODO: Displaying the notification counter inside a badge
                              /*Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.01),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: DatabaseService(
                                          loggedInUserID: GlobalVariables
                                              .loggedInUserObject.id)
                                      .getNotificationCounter(),
                                  builder: (context, snapshot) {
                                    if ((snapshot.connectionState ==
                                            ConnectionState.active) &&
                                        (snapshot.hasData)) {
                                      DocumentSnapshot
                                          notificationDocumentSnapshot =
                                          snapshot.data;
                                      notificationCounter =
                                          notificationDocumentSnapshot
                                              .data()["notCts"];
                                      notCounter = CustomFunctions
                                          .notificationCounterFormatter(
                                              notificationCounter);
                                    }

                                    return notificationCounter == 0
                                        ? Text("")
                                        : Badge(
                                            badgeColor: notificationBadgeColour,
                                            toAnimate: false,
                                            badgeContent: Text(
                                              notCounter == "" ||
                                                      notCounter == null
                                                  ? ""
                                                  : notCounter,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .apply(
                                                    fontSizeFactor: 0.75,
                                                    fontWeightDelta: 2,
                                                    color: kWhitecolor,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            elevation: 10,
                                            padding: EdgeInsets.all(6.4),
                                          );
                                  },
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        //TODO: Displaying the notification bell and the counter
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeNotificationsScreen(
                                  actSrn: true,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              //TODO: Displaying the notification bell
                              IconButton(
                                iconSize: 30.0,
                                icon: Icon(
                                  Icons.notifications,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeNotificationsScreen(
                                        actSrn: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              //TODO: Displaying the notification counter inside a badge
                              /*Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.01),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: DatabaseService(
                                          loggedInUserID: GlobalVariables
                                              .loggedInUserObject.id)
                                      .getNotificationCounter(),
                                  builder: (context, snapshot) {
                                    if ((snapshot.connectionState ==
                                            ConnectionState.active) &&
                                        (snapshot.hasData)) {
                                      DocumentSnapshot
                                          notificationDocumentSnapshot =
                                          snapshot.data;
                                      notificationCounter =
                                          notificationDocumentSnapshot
                                              .data()["notCts"];
                                      notCounter = CustomFunctions
                                          .notificationCounterFormatter(
                                              notificationCounter);
                                    }

                                    return notificationCounter == 0
                                        ? Text("")
                                        : Badge(
                                            badgeColor: notificationBadgeColour,
                                            toAnimate: false,
                                            badgeContent: Text(
                                              notCounter == "" ||
                                                      notCounter == null
                                                  ? ""
                                                  : notCounter,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .apply(
                                                    fontSizeFactor: 0.75,
                                                    fontWeightDelta: 2,
                                                    color: kWhitecolor,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            elevation: 10,
                                            padding: EdgeInsets.all(6.4),
                                          );
                                  },
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        //TODO: Displaying jobs icon
                        IconButton(
                          icon: SvgPicture.asset(
                            "images/app_entry_and_home/work.svg",
                            width: 28.0,
                            height: 28.0,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                          iconSize: 28.0,
                          onPressed: () {
                            ///Route the user to sparks jobs screen.
                            Navigator.pushNamed(context, Jobs.id);
                          },
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO: List of scrollable content for home menu.
                    //TODO: Displays create post and sparks tv buttons
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.012,
                        right: MediaQuery.of(context).size.width * 0.012,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: k10,
                                padding: EdgeInsets.all(
                                  0.0,
                                ),
                                primary: kWhiteColour,
                              ),
                              child: Image.asset(
                                "images/app_entry_and_home/new_images/create_content.png",
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {
                                //TODO: Show the post screen when this button is clicked.
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MakePost(
                                    pImageUrl: "${user.pimg}",
                                    userFullName: "${user.un}",
                                  );
                                }));
                              },
                            ),
                          ),
                          /*SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015),*/
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: k10,
                                padding: EdgeInsets.all(
                                  0.0,
                                ),
                                primary: kWhiteColour,
                              ),
                              child: Image.asset(
                                "images/app_entry_and_home/new_images/view_all_stories.png",
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TODO: Create and display stories.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: k5,
                          ),
                          //TODO: Add a story card
                          AddStoryCard(
                            profileImage: widget.profileImageUrl!,
                          ),
                          //TODO: Display stories
                          DisplayUserStoryCard(
                            profileImage: widget.profileImageUrl!,
                            profileUsername:
                                GlobalVariables.loggedInUserObject.un,
                          ),
                          DisplayUserStoryCard(
                            profileImage: widget.profileImageUrl!,
                            profileUsername:
                                GlobalVariables.loggedInUserObject.un,
                          ),
                          DisplayUserStoryCard(
                            profileImage: widget.profileImageUrl!,
                            profileUsername:
                                GlobalVariables.loggedInUserObject.un,
                          ),
                          DisplayUserStoryCard(
                            profileImage: widget.profileImageUrl!,
                            profileUsername:
                                GlobalVariables.loggedInUserObject.un,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.012,
                    ),
                    //TODO: Displaying contents from Sparks TV
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.045,
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "images/app_entry_and_home/new_images/sparks_tv_tab_section.png",
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Divider(
                            color: kLineColour,
                            thickness: 1.0,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //TODO: Sparks TV contents
                          SparksTVContent(
                            banner: widget.profileImageUrl!,
                            profileImage: widget.profileImageUrl!,
                            fullname: {"fn": "Prince", "ln": "John"},
                            username: GlobalVariables.loggedInUserObject.un,
                          ),
                          SparksTVContent(
                            banner: widget.profileImageUrl!,
                            profileImage: widget.profileImageUrl!,
                            fullname: {"fn": "Prince", "ln": "John"},
                            username: GlobalVariables.loggedInUserObject.un,
                          ),
                          SparksTVContent(
                            banner: widget.profileImageUrl!,
                            profileImage: widget.profileImageUrl!,
                            fullname: {"fn": "Prince", "ln": "John"},
                            username: GlobalVariables.loggedInUserObject.un,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.012,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Divider(
                        color: kLineColour,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    ),
                    //TODO: Display posts
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              kHome_posts,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontSize: kFont_size.sp,
                                  fontWeight: FontWeight.w900,
                                  color: kBlackColour,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //TODO: Display friends feeds
                        postFeedStreamBuilder,
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color: kWhiteColour,
              child: Center(
                child: SpinKitDoubleBounce(
                  color: kFormLabelColour,
                ),
              ),
            );
          }
        });
  }
}
