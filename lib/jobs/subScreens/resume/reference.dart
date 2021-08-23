import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/subScreens/resume/contact.dart';
import 'package:sparks/jobs/subScreens/resume/referee.dart';
import 'package:sparks/jobs/subScreens/resume/reputation1.dart';


class Reference extends StatefulWidget {
  @override
  _ReferenceState createState() => _ReferenceState();
}

class _ReferenceState extends State<Reference> with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refTabController = TabController(vsync: this,initialIndex: 0,length: 3);
  }

  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
        length: 3,
        initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Padding(
              padding:EdgeInsets.only(top:8.0),
              child: AppBar(
                elevation: 0.7,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      15.0,
                    ),
                    topRight: Radius.circular(
                      15.0,
                    ),
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  controller: _refTabController,
                  indicatorColor: kRep,
                  indicatorWeight: 4.0,
                  indicatorPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.016,
                    right: MediaQuery.of(context).size.height * 0.016,
                  ),
                  labelColor: kMore,
                  unselectedLabelColor: Colors.black,
                  labelStyle: GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.bold,
                        color: kNavColor),), //For Selected tab
                  unselectedLabelStyle: GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(14.0),
                        fontWeight: FontWeight.bold,
                        color: kActiveNavColor),),
                  tabs: <Widget>[
                    Tab(
                      text: 'CONTACT',
                    ),
                    Tab(
                      text: 'REPUTATION',
                    ),
                    Tab(
                      text: 'REFEREE',
                    ),

                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _refTabController,
            children: <Widget>[
              Contact(),
              Reputation1(),
              Referee(),

            ],
          ),




        ),
      ),
    );
  }
}

