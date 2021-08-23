import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/smaller_fab.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/drawerComponent.dart';
import 'package:sparks/jobs/components/generalBottomAppBar.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/screens/companies.dart';
import 'package:sparks/jobs/screens/employment.dart';
import 'package:sparks/jobs/screens/jobsNotificationScreen.dart';
import 'package:sparks/jobs/screens/search.dart';
import 'package:sparks/jobs/screens/mainJobs.dart';
import 'package:sparks/jobs/screens/professional.dart';
import 'package:sparks/jobs/subScreens/company/CreateCompanyAccount/entry.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenOne.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/subScreens/resume/resume.dart';
import 'package:sparks/market/components/badge_counter.dart';
import 'package:sparks/market/components/custom_small_fab.dart';

enum FabState {
  OPEN,
  CLOSE,
}

class Jobs extends StatefulWidget {
  static String id = "jobs";
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  //TODO: setting up the controller for controlling the search inputs.
  TextEditingController controller = TextEditingController();

  //TODO: Bottom navigation variables
  FabState fabState = FabState.CLOSE;

  bool _fabVisibilityState = false;

  /// Function that controls the visibility of the Sparks floating button
  void fabController() {
    if (fabState == FabState.CLOSE) {
      setState(() {
        fabState = FabState.OPEN;
        _fabVisibilityState = true;
      });
    } else {
      setState(() {
        fabState = FabState.CLOSE;
        _fabVisibilityState = false;
      });
    }
  }

  void resetFab() {
    print("Disposing of Job Home");
    setState(() {
      fabState = FabState.CLOSE;
      _fabVisibilityState = false;
    });
  }

  void showSmallerFab() {
    /// TODO: implement smaller FAB buttons
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              print("Gesture tapped!");
              resetFab();
              Navigator.of(context, rootNavigator: true).pop(context);
            },
            onVerticalDragStart: (dragStart) {
              resetFab();
              Navigator.of(context, rootNavigator: true).pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: CustomSmallFAB(
                children: [
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/sparks_brand_svg.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.

                      print('one pressed');
                      fabController();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/fab_briefcase.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.
                      print("Second button form the top");
                      fabController();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/fab_money.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.
                      print("Third button form the top");
                      fabController();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool hideFilter = false;
  bool filterColor = false;

  String searchHint = "Search Jobs";
  bool enable = true;

  /// Datetime variable needed for double-tap to exit the Market activity
  DateTime? currentBackPressTime;

  int returnCorrectLandingPage() {
    if (UserStorage.fromResume == true) {
      return 3;
    } else if (UserStorage.isFromCompanyPage == true) {
      setState(() {
        hideFilter = true;
      });
      return 3;
    } else {
      return 0;
    }
  }

  void switchToSearchScreen() {
    if (_tabController!.index == 0) {
      showSearch(context: context, delegate: JobSearch());
    }
    if (_tabController!.index == 1) {
      showSearch(context: context, delegate: ProfessionalSearch());
    }
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ReusableFunctions.showToastMessage("Press back again to exit app");

      return Future.value(false);
    }

    /// TODO: Check if this code to exit app works on iOS
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', true);

    // SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, initialIndex: returnCorrectLandingPage(), length: 4)
      ..addListener(() {
        setState(() {
          switch (_tabController!.index) {
            case 0:
              // some code here
              setState(() {
                searchHint = "Search Jobs";
                enable = true;
                hideFilter = false;
                //searchFunction = searchJobFunction;
              });
              break;
            case 1:
              // some code here
              setState(() {
                searchHint = "Search Professionals";
                enable = true;
                hideFilter = false;
              });
              break;
            case 2:
              setState(() {
                searchHint = "No search here";
                enable = false;
                hideFilter = true;
              });
              break;
            case 3:
              setState(() {
                searchHint = "No search here";
                enable = false;
                hideFilter = true;
              });
          }
        });
      });
    UserStorage.getCurrentUser();
    print(GlobalVariables.accountType);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    UserStorage.fromResume = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: JobHomeDrawer(),
        endDrawer: _tabController!.index == 0
            ? JobFilterDrawer()
            : ProfessionalDrawerFilter(),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  expandedHeight: hideFilter == false
                      ? ScreenUtil().setHeight(160.0)
                      : ScreenUtil().setHeight(100.0),
                  title: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: SizedBox(
                              child: Image(
                                  width: 80.0,
                                  height: 40.0,
                                  image: AssetImage("images/jobs/sparks.png")),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ProfessionalStorage.id =
                                  UserStorage.loggedInUser.uid;
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: UserStorage.profState == true
                                          ? Resume()
                                          : CreateProfessionalScreenOne()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: Icon(
                                Icons.account_box,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  titleSpacing: 0.0,
                  backgroundColor: kLight_orange,
                  floating: true,
                  pinned: true,
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
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: JobsNotification()));
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            BadgeCounter(
                              badgeText: '12',
                              iconData: Icons.notifications_none,
                              showBadge: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //GlobalVariables.loggedInUserObject.nm["fn"]
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 32,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: GlobalVariables.loggedInUserObject.pimg!,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 8.0),
                    child: Row(
                      children: <Widget>[
                        if (hideFilter == false)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                            child: GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "images/market_images/menu_icon.svg",
                                  width: ScreenUtil().setWidth(25),
                                  color: filterColor == true
                                      ? kActiveNavColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if (hideFilter == false)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  switchToSearchScreen();
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    enabled: enable,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: searchHint,
                                      contentPadding:
                                          EdgeInsets.only(left: 24.0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (hideFilter == false)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                            child: GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "images/jobs/filter.svg",
                                  width: ScreenUtil().setWidth(38),
                                  color: filterColor == true
                                      ? kActiveNavColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
                  bottom: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: kActiveNavColor,
                    labelColor: kActiveNavColor,
                    unselectedLabelColor: kNavColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4.0,
                    indicatorPadding: EdgeInsets.only(
                      left: ScreenUtil().setSp(5.0),
                      right: ScreenUtil().setSp(5.0),
                    ),
                    labelStyle: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ), //For Selected tab
                    unselectedLabelStyle: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tabs: <Widget>[
                      Tab(
                        text: 'Jobs',
                      ),
                      Tab(
                        text: 'Professionals',
                      ),
                      Tab(
                        text: 'Employments',
                      ),
                      Tab(
                        text: 'Company',
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                MainJobs(),
                Professional(),
                Employment(),
                UserStorage.isCompanyAccount == true
                    ? Companies()
                    : CompanyAccountEntry(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomCompanyBottomAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: fabState == FabState.CLOSE
            ? FloatingActionButton(
                backgroundColor: kJobPrimaryColor,
                heroTag: "mainFAB",
                shape: CircleBorder(
                  side: BorderSide(
                    color: kWhiteColour,
                  ),
                ),
                onPressed: () {
                  print("I was pressed");
                  showSmallerFab();
                  fabController();
                },
                child: SvgPicture.asset(
                  "images/app_entry_and_home/sparks_brand_svg.svg",
                  width: MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.height * 0.038,
                ),
              )
            : FloatingActionButton(
                backgroundColor: kJobPrimaryColor,
                onPressed: () {
                  print("FAB close");
                  fabController();
                },
                child: Icon(
                  Icons.close,
                  size: ScreenUtil().setWidth(36),
                ),
              ),
      ),
    );
  }
}
