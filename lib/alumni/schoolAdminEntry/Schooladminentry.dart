import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/schoolAdminEntry/School_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/alumniproject_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/careerservice_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/internship_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/jobs_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/promotion_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/schl_event_admin.dart';
import 'package:sparks/alumni/schoolAdminEntry/scholarship_admin.dart';
import 'package:sparks/alumni/strings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/schoolAdmin_profile/view_profile.dart';

class AdminEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminEntry();
  }
}

class _AdminEntry extends State<AdminEntry>
    with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refTabController = TabController(vsync: this, initialIndex: 0, length: 8);
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshList,
          backgroundColor: kAWhite,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  expandedHeight: 100,
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.15,
                            ),
                            child: Card(
                              elevation: 20.0,
                              color: kADarkRed,
                              child: Text(
                                kAppBarHarvardUniversity,
                                style: TextStyle(
                                  color: kAWhite,
                                  fontFamily: "Rajdhani",
                                  fontSize: 23.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
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
                                right: MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/alumni/profile1.png'),
                                backgroundColor: kAWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    controller: _refTabController,
                    indicatorColor: kAYellow,
                    labelColor: kAYellow,
                    unselectedLabelColor: kAWhite,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4.0,
                    isScrollable: true,
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
                        child: Text(
                          "Schl-Admin",
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
              ];
            },
            body: TabBarView(
              controller: _refTabController,
              children: <Widget>[
                SchoolAdmin(),
                NewsBoardEventsAdmin(),
                JobsAdmin(),
                PromotionsAdmin(),
                NewsBoardScholarshipAdmin(),
                NewsBoardInternshipAdmin(),
                CareerServiceAdmin(),
                AlumniProjectsAdmin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
