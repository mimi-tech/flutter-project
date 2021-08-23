import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/jobs/subScreens/company/manageCompanies.dart';
import 'package:sparks/jobs/subScreens/company/myCompanies.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies>
    with SingleTickerProviderStateMixin {
  TabController? _refTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refTabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
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
                    fontSize: ScreenUtil().setSp(22.0),
                    fontWeight: FontWeight.bold,
                    color: kNavColor),
              ), //For Selected tab
              unselectedLabelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: kActiveNavColor),
              ),
              tabs: <Widget>[
                Tab(
                  text: 'Personal',
                ),
                Tab(
                  text: 'Manage Others',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _refTabController,
          children: <Widget>[
            MyCompanies(),
            ManageCompanies(),
          ],
        ),
      ),
    );
  }
}
