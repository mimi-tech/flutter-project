import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/Alumni/schoolAdminEntry/chapteraccepted_request.dart';
import 'package:sparks/Alumni/schoolAdminEntry/chapterdeclined_request.dart';
import 'package:sparks/Alumni/schoolAdminEntry/chapternew_request.dart';

class ChapterRequestTab extends StatefulWidget {
  @override
  _ChapterRequestTabState createState() => _ChapterRequestTabState();
}

class _ChapterRequestTabState extends State<ChapterRequestTab> {
  TabController? _tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kADarkRed,
          title: Container(
            margin: EdgeInsets.only(left: 60.0),
            child: Card(
              elevation: 20.0,
              color: kADarkRed,
              child: Text(
                "Chapter Request",
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
                  "New",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Accepted",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Declined",
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
            ChapterNewRequest(),
            ChapterAcceptedRequest(),
            ChapterDeclinedRequest(),
          ],
        ),
      ),
    );
  }
}
