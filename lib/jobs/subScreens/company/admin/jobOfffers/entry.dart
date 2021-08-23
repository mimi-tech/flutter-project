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
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/accepted.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/created.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/declined.dart';

class AdminJobOfferEntry extends StatefulWidget {
  @override
  _AdminJobOfferEntryState createState() => _AdminJobOfferEntryState();
}

class _AdminJobOfferEntryState extends State<AdminJobOfferEntry>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 65.0, top: 12.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  child: Text(
                    '${CompanyStorage.companyName} - Admin Jobs',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
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
              isScrollable: true,
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
                  text: 'Created',
                ),
                Tab(
                  text: 'ACCEPTED',
                ),
                Tab(
                  text: 'Declined',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          JobOfferRequestCreated(),
          AdminJobOfferAccepted(),
          AdminJobOfferDeclined(),
        ],
      ),
      bottomNavigationBar: CustomCompanyBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: "MainFAB",
        shape: CircleBorder(
          side: BorderSide(
            color: kWhiteColour,
          ),
        ),
        child: fabCurrentState == FabActivity.CLOSE
            ? Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.012,
                  top: MediaQuery.of(context).size.height * 0.014,
                  bottom: MediaQuery.of(context).size.height * 0.012,
                ),
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "images/sparks_brand_svg.svg",
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.height * 0.055,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                    )),
              )
            : Icon(
                Icons.clear,
                size: kSize_40.sp,
              ),
        backgroundColor: kProfile,
        onPressed: () {
          setState(() {
            isPressed == true ? isPressed = false : isPressed = true;
            isPressed == false
                ? fabCurrentState = FabActivity.CLOSE
                : fabCurrentState = FabActivity.OPEN;
          });
        },
      ),
    );
  }
}

class ReNavBarComponent extends StatelessWidget {
  ReNavBarComponent({required this.colour, this.text});

  final Color colour;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 9.0, 0.0),
      child: Text(
        text!,
        style: TextStyle(
            fontFamily: "Rajdhani",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colour),
      ),
    );
  }
}
