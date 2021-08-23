import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/edit/formFour.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/edit/formOne.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/edit/formThree.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/edit/formTwo.dart';

class EditAppointmentEntry extends StatefulWidget {
  @override
  _EditAppointmentEntryState createState() => _EditAppointmentEntryState();
}

class _EditAppointmentEntryState extends State<EditAppointmentEntry>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.7,
        automaticallyImplyLeading: true,
        backgroundColor: kLight_orange,
        centerTitle: true,
        title: Text(
          'Edit APPOINTMENT LETTER',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AbsorbPointer(
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicatorColor: kActiveNavColor,
              labelColor: kActiveNavColor,
              unselectedLabelColor: kNavColor,
              indicatorWeight: 4.0,
              indicatorPadding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.016,
                right: MediaQuery.of(context).size.height * 0.016,
              ),
              labelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(18.0),
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
                  text: 'FormOne',
                ),
                Tab(
                  text: 'FormTwo',
                ),
                Tab(
                  text: 'FormThree',
                ),
                Tab(
                  text: 'FormFour',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          EditFormOne(tabController: _tabController),
          EditFormTwo(tabController: _tabController),
          EditFormThree(tabController: _tabController),
          EditFormFour(tabController: _tabController),
        ],
      ),
    );
  }
}
