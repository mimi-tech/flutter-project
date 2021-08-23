import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/media.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/schoolFeeds.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class CampusNewsTab extends StatefulWidget {


  @override
  _CampusNewsTabState createState() => _CampusNewsTabState();
}

class _CampusNewsTabState extends State<CampusNewsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Announcement",),
              Tab( text: "Feedback"),
              Tab( text: "Media"),


            ],

            indicatorColor: kWhitecolor,
            indicatorWeight: 2.0,

            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kStabcolor1,
                fontSize: 16.sp,
              ),),
            unselectedLabelColor: kTextColor,

          ),
          title: RichText(
            text: TextSpan(
                text:'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']} \n'.toUpperCase(),
                style: GoogleFonts.rajdhani(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),

                children: <TextSpan>[
                  TextSpan(text: '${SchClassConstant.schDoc['name']}'.toUpperCase(),
                    style: GoogleFonts.rajdhani(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: kStabcolor1,
                    ),

                  ),


                ]
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SchoolAnnouncement(),
            AllSchoolFeed(),
            CreateHighSchoolPost(),
          ],
        ),
      ),
    );
  }
}
