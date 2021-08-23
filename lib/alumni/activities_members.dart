import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/activities_admin.dart';
import 'package:sparks/alumni/activities_myset.dart';
import 'package:sparks/alumni/alumnischoollisting.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/members.dart';
import 'package:sparks/alumni/strings.dart';

import 'Storage.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refTabController = TabController(
        vsync: this,
        initialIndex: Storage.activitiesTab == 2 ? 2 : 0,
        length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kAWhite,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: AppBar(
                elevation: 0.7,
                automaticallyImplyLeading: false,
                backgroundColor: kAWhite,
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
                  controller: _refTabController,
                  indicatorColor: kABlack,
                  indicatorWeight: 4.0,
                  indicatorPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.016,
                    right: MediaQuery.of(context).size.height * 0.016,
                  ),
                  labelColor: kABlack,
                  unselectedLabelColor: kABlack,
                  labelStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: kABlue),
                  //For Selected tab
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: kABlack),

                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        KAppBarMembers,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        KAppBarMySet,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        KAppBarChapter,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        KAppBarAdmin,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _refTabController,
            children: <Widget>[
              Member(),
              MySet(),
              SchoolListing(),
              ActivitiesAdmin(),
            ],
          ),
        ),
      ),
    );
  }
}
