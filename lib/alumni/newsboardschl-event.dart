import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/Alumni/jobs_input_page.dart';
import 'package:sparks/Alumni/newsboard_Internship.dart';
import 'package:sparks/Alumni/newsboard_alumniproject.dart';
import 'package:sparks/Alumni/newsboard_career.dart';
import 'package:sparks/Alumni/newsboard_scholarship.dart';
import 'package:sparks/Alumni/newsboardevents.dart';
import 'package:sparks/alumni/strings.dart';

import 'Promotion_chapter.dart';

class NewsBoardSchlEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsBoardSchlEvent();
  }
}

class _NewsBoardSchlEvent extends State<NewsBoardSchlEvent>
    with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refTabController = TabController(vsync: this, initialIndex: 0, length: 7);
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
                  isScrollable: true,
                  labelStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  //For Selected tab
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: kABlack),

                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        kAppBarSchoolEvents,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarJobs,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarPromotions,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarScholarship,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarInternship,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarCareerService,
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        kAppBarAlumniProject,
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
              NewsBoardEvents(),
              Jobs(),
              Promotions(),
              NewsBoardScholarship(),
              NewsBoardInternship(),
              CareerService(),
              AlumniProjects(),
            ],
          ),
        ),
      ),
    );
  }
}
