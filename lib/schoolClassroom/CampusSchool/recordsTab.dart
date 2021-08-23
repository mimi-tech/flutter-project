import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/All_studies.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/all_socialClasses.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/schoolFeeds.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_result.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class CampusRecordTab extends StatefulWidget {

  @override
  _CampusRecordTabState createState() => _CampusRecordTabState();
}

class _CampusRecordTabState extends State<CampusRecordTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Studies",),
              Tab( text: "Social class"),
              Tab( text: "Result"),


            ],
          ),
          title: RichText(
            text: TextSpan(
                text:'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']} \n'.toUpperCase(),
                style: GoogleFonts.rajdhani(
                 fontSize:16.sp,
                  fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),

                children: <TextSpan>[
                  TextSpan(text: '${SchClassConstant.schDoc['name']}',
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
            AdminStudies(),
            AllSocialClasses(),
            SchoolResult(),

          ],
        ),
      ),
    );
  }
}
