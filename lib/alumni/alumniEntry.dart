import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/alumni/Storage.dart';
import 'package:sparks/alumni/activities_members.dart';
import 'package:sparks/alumni/alumni_schoolrequest.dart';
import 'package:sparks/alumni/alumnischoollisting.dart';
import 'package:sparks/alumni/components/alumni_bottom_appbar_School.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/newsboardschl-event.dart';
import 'package:sparks/alumni/schoolAdminEntry/Schooladminentry.dart';
import 'package:sparks/alumni/schoolAdmin_profile/view_profile.dart';
import 'package:sparks/alumni/views/alma_mater.dart';
import 'package:sparks/app_entry_and_home/reusables/smaller_fab.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/market/components/custom_small_fab.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'color/colors.dart';
import 'components/badge_counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'strings.dart';

class School extends StatefulWidget {
  static String id = "School";
  @override
  SchoolState createState() => SchoolState();
}

class SchoolState extends State<School> with SingleTickerProviderStateMixin {
  FabState fabState = FabState.CLOSE;

  TabController? _tabController;
  final _auth = FirebaseAuth.instance;
  bool canRequest = true;
  bool isFirstLoad = true;
  bool displayLogo = true;
  User? loggedInUser;

  bool _fabVisibilityState = false;

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

  void resetFab() {
    print("Disposing of Market Home");
    setState(() {
      fabState = FabState.CLOSE;
      _fabVisibilityState = false;
    });
  }

  /// TODO: Remove this code snippet
  void displaySchoolLogo() {
    if (Storage.isCampusUniversity == true) {
      setState(() {
        displayLogo = true;
      });
    } else if (Storage.isInPostGraduateCollege == true) {
      setState(() {
        displayLogo = true;
      });
    } else if (Storage.isPostGraduate == true) {
      setState(() {
        displayLogo = false;
      });
    } else if (Storage.isUniversityGraduate == true) {
      setState(() {
        displayLogo = false;
      });
    } else {
      setState(() {
        displayLogo = true;
      });
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  int initialIndex = 0;

  void initialView() {
    print(SchoolStorage.isItFromChapterActivities);
    print(SchoolStorage.isItFromSchoolRequest);
    if (SchoolStorage.isItFromChapterActivities == true) {
      initialIndex = 2;
    } else if (SchoolStorage.isItFromSchoolRequest == true) {
      initialIndex = 1;
    } else {
      initialIndex = 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaySchoolLogo();
    initialView();
    checkIfCanRequest();

    _tabController =
        TabController(vsync: this, initialIndex: initialIndex, length: 3);
  }

  void checkIfCanRequest() {
    // Firestore code needed to set canRequest boolean
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SchoolStorage.isItFromChapterActivities = false;
    SchoolStorage.isItFromSchoolRequest = false;
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    //print(sparksUser.uid);

    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    /// Rebuild the section called manage account
    Widget managingUsersAccount() {
      Widget mA;

      mA = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.allMyAccountTypes, accountGateWay.id),
      );

      return mA;
    }

    /// Displays all the accounts and show the one that is active
    Widget settingActiveAcct() {
      Widget activeAcct = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.updatedAcct, accountGateWay.id),
      );

      return activeAcct;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("andre lyon"),
                accountEmail: Text("andrelyon78@gmail.com"),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ViewProfile(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage('images/alumni/friends.jpg'),
                    backgroundColor: Colors.grey,
                  ),
                ),
                decoration: BoxDecoration(color: kADarkRed),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Text(
                        "Manage Account",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: kADarkRed,
                        ),
                      ),
                    ),
                    Container(
                        child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, PersonalReg.id);
                      },
                      icon: Icon(
                        Icons.add,
                        color: kADarkRed,
                      ),
                    )),
                  ],
                ),
              ),
              GlobalVariables.updatedAcct.isEmpty
                  ? managingUsersAccount()
                  : settingActiveAcct(),
              Divider(
                color: kADarkGrey,
                thickness: 0.2,
              ),
              GlobalVariables.accountType.contains("School")
                  ? ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: AdminEntry(),
                          ),
                        );
                      },
                      title: Text(
                        'School Admin',
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kABlack,
                        ),
                      ),
                      leading: SvgPicture.asset(
                        "images/alumni/about_admin.svg",
                        height: 25.0,
                        width: 25.0,
                        color: kADarkRed,
                      ),
                    )
                  : SizedBox.shrink(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ViewProfile(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    'my profile',
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kABlack,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    "images/alumni/profile_icon.svg",
                    height: 25.0,
                    width: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kABlack,
                    ),
                  ),
                  leading: Icon(
                    (Icons.notes_outlined),
                    color: kAOrangeGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          backgroundColor: kAWhite,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  expandedHeight: 100,
                  title: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    //user();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 1.0, right: 18.0, top: 5.0),
                                    width: 30.03,
                                    height: 28.09,
                                    child: Image.asset(
                                        "images/alumni/messages.png"),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  BadgeCounter(
                                    iconData: Icons.notifications,
                                    batchText: '9',
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ViewProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 18.0, bottom: 2.0, top: 10.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/alumni/friends.jpg'),
                                  backgroundColor: Colors.grey,
                                  radius: 18.0,
                                ),
                              ),
                            ),
                          ])),
                  titleSpacing: 0.0,
                  backgroundColor: kADarkRed,
                  floating: true,
                  pinned: true,
                  automaticallyImplyLeading: true,
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
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: kAYellow,
                    labelColor: kAYellow,
                    unselectedLabelColor: kAWhite,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4.0,
                    indicatorPadding: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    //For Selected tab
                    unselectedLabelStyle: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),

                    tabs: <Widget>[
                      Tab(
                        child: AbsorbPointer(
                          child: Container(
                              child: displayLogo == true
                                  ? SvgPicture.asset(
                                      "images/alumni/student.svg")
                                  : SvgPicture.asset(
                                      "images/alumni/Alumni_main.svg")),
                        ),
                      ),
                      Tab(
                        child: Text(
                          kAppBarActivities,
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          kAppBarNewsBoard,
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // AlumniSchoolRequest(),
                AlmaMater(),
                Members(),
                NewsBoardSchlEvent(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SchoolBottomAppbarWithEndDock(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: fabState == FabState.CLOSE
            ? FloatingActionButton(
                heroTag: "mainFAB",
                backgroundColor: kMarketPrimaryColor,
                shape: CircleBorder(
                  side: BorderSide(
                    color: kAWhite,
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
                backgroundColor: kMarketPrimaryColor,
                onPressed: () {
                  print("FAB close");
                  fabController();
                },
                child: Icon(
                  Icons.close,
                  size: ScreenUtil().setWidth(36),
                ),
              ),
      )),
    );
  }
}
