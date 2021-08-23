import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/subScreens/resume/portfolioInsights.dart';
import 'package:sparks/jobs/subScreens/resume/portfolioPictures.dart';

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 0.7,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: kLight_orange,
              labelColor: Colors.black,
              unselectedLabelColor: kLight_orange,
              indicatorWeight: 2.0,
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
                  text: 'PICTURES',
                ),
//                Tab(
//                  text: 'VIDEOS',
//                ),
                Tab(
                  text: 'INSIGHTS',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PortfolioImages(),
            //  PortfolioVideos(),
            PortfolioInsight(),
          ],
        ),
      ),
    );
  }
}
