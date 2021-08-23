import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/Alumni/schoolAdminEntry/Jobslisted_request.dart';
import 'package:sparks/Alumni/schoolAdminEntry/personsapplied_request.dart';

class JobsTab extends StatefulWidget {
  @override
  _JobsTabState createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> {
  TabController? _tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kADarkRed,
          title: Container(
            margin: EdgeInsets.only(left: 105.0),
            child: Card(
              elevation: 20.0,
              color: kADarkRed,
              child: Text(
                "JOBS",
                style: TextStyle(
                    color: kAWhite,
                    fontFamily: "Rajdhani",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
            unselectedLabelStyle: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Jobs Listed",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Persons Applied",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            JobsListing(),
            PersonsApplied(),
          ],
        ),
      ),
    );
  }
}
