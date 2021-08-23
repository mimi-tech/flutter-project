import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalBottomAppBar.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobs/listedJobs.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobs/viewApplicants.dart';

class AdminJobsEntry extends StatefulWidget {
  @override
  _AdminJobsEntryState createState() => _AdminJobsEntryState();
}

class _AdminJobsEntryState extends State<AdminJobsEntry>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        title: Text(
          CompanyStorage.companyName!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        backgroundColor: kLight_orange,
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white,
            ),
            child: TabBar(
              indicatorWeight: 4.0,
              indicatorPadding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.016,
                right: MediaQuery.of(context).size.height * 0.016,
              ),
              labelColor: kLight_orange,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              indicatorColor: Colors.black,
              labelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(16.0),
                  fontWeight: FontWeight.bold,
                ),
              ), //For Selected tab
              unselectedLabelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(14.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              tabs: <Widget>[
                Tab(
                  text: 'LISTED JOBS',
                ),
                Tab(
                  text: 'VIEW APPLICANTS',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListedJobs(),
          ViewApplicants(),
        ],
      ),
    );
  }
}
