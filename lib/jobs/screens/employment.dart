import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/subScreens/employment/JobOffers.dart';
import 'package:sparks/jobs/subScreens/employment/appointment.dart';
import 'package:sparks/jobs/subScreens/employment/interview.dart';

class Employment extends StatefulWidget {
  @override
  _EmploymentState createState() => _EmploymentState();
}

class _EmploymentState extends State<Employment>
    with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refTabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
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
              controller: _refTabController,
              isScrollable: true,
              indicatorColor: Colors.black,
              indicatorWeight: 4.0,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.016,
                right: MediaQuery.of(context).size.height * 0.016,
              ),
              labelColor: kLight_orange,
              unselectedLabelColor: Colors.black,
              labelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: kNavColor),
              ), //For Selected tab
              unselectedLabelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(14.0),
                    fontWeight: FontWeight.bold,
                    color: kActiveNavColor),
              ),
              tabs: <Widget>[
                Tab(
                  text: 'INTERVIEW',
                ),
                Tab(
                  text: 'JOB OFFER',
                ),
                Tab(
                  text: 'APPOINTMENT',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _refTabController,
          children: <Widget>[
            Interview(),
            JobOffer(),
            Appointment(),
          ],
        ),
      ),
    );
  }
}
