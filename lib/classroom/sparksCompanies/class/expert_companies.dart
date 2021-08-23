import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/sparksCompanies/class/e_companies.dart';
import 'package:sparks/classroom/sparksCompanies/courses/c_companies.dart';

class SparksExpertCompanies extends StatefulWidget {
  @override
  _SparksExpertCompaniesState createState() => _SparksExpertCompaniesState();
}

class _SparksExpertCompaniesState extends State<SparksExpertCompanies>
    with TickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(icon: Icon(Icons.card_travel)),
    Tab(icon: Icon(Icons.add_shopping_cart)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            onTap: (index) {
              // Should not used it as it only called when tab options are clicked,
              // not when user swapped
            },
            controller: _controller,
            tabs: list,
          ),
          title: Text(
            kSparksCName,
            style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
              color: kWhitecolor,
              fontWeight: FontWeight.bold,
              fontSize: kFontsize.sp,
            )),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            ECompanies(),
            CrCompanies(),
          ],
        ),
      ),
    );
  }
}
