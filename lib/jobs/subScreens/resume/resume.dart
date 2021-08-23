import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/smaller_fab.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalBottomAppBar.dart';
import 'package:sparks/jobs/subScreens/resume/about.dart';
import 'package:sparks/jobs/subScreens/resume/experience1.dart';
import 'package:sparks/jobs/subScreens/resume/portfolio.dart';
import 'package:sparks/jobs/subScreens/resume/reference.dart';
import 'package:sparks/jobs/subScreens/resume/services.dart';
import 'package:sparks/market/components/custom_small_fab.dart';

enum FabState {
  OPEN,
  CLOSE,
}

class Resume extends StatefulWidget {
  @override
  _ResumeState createState() => _ResumeState();
}

class _ResumeState extends State<Resume> with SingleTickerProviderStateMixin {
  TabController? _tabController;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0.7,
          automaticallyImplyLeading: false,
          backgroundColor: kLight_orange,
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: kActiveNavColor,
            labelColor: kActiveNavColor,
            unselectedLabelColor: kNavColor,
            indicatorWeight: 4.0,
            indicatorPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.016,
              right: MediaQuery.of(context).size.height * 0.016,
            ),
            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontSize: ScreenUtil().setSp(20.0),
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
                text: 'About',
              ),
              Tab(
                text: 'Experience',
              ),
              Tab(
                text: 'Services',
              ),
              Tab(
                text: 'Portfolio',
              ),
              Tab(
                text: 'Reference',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          About(),
          Expert(tabController: _tabController),
          Services(tabController: _tabController),
          Portfolio(),
          Reference(),
        ],
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
    );
  }
}
