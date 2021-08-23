import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_result.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/class_socials.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_assessment.dart';

import 'package:sparks/schoolClassroom/sechoolTeacher/upload_lessons.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_result.dart';

class UploadTab extends StatefulWidget {


  @override
  _UploadTabState createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Studies"),
              Tab( text: "Social"),
              Tab( text: "Results"),
              Tab( text: "Assessments"),


            ],
            indicatorColor: kWhitecolor,
            indicatorWeight: 4.0,

            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kStabcolor1,
                fontSize: kFontSize12.sp,
              ),),
            unselectedLabelColor: kTextColor,
          ),
          title: RichText(
            text: TextSpan(
                text:'${SchClassConstant.schDoc['name'].toString().toUpperCase()} \n',
                style: GoogleFonts.rajdhani(
fontSize:16.sp,fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),

                children: <TextSpan>[
                  TextSpan(text: '${SchClassConstant.schDoc['tc']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,
                      fontWeight: FontWeight.normal,
                      color: kStabcolor1,
                    ),

                  ),
                  TextSpan(text: ': ${SchClassConstant.schDoc['lv']} ${SchClassConstant.schDoc['cl']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,
                      fontWeight: FontWeight.normal,
                      color: kMaincolor,
                    ),

                  ),

                ]
            ),
          ),

        ),
        body: TabBarView(
          children: [
            TeachersUpload(),
            SocialClasses(),
            TeachersUploadResult(),
            TeachersAssessment(),
          ],
        ),
      ),
    );
  }
}
