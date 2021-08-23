import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/see_report.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_announcement.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_result.dart';


class TeachersNewsTab extends StatefulWidget {


  @override
  _TeachersNewsTabState createState() => _TeachersNewsTabState();
}

class _TeachersNewsTabState extends State<TeachersNewsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Announcement"),
              Tab( text: "Result"),
              Tab( text: "Report"),


            ],
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
            TeachersAnnouncement(),
            TeachersUploadResult(),
            SeeTeachersReport(),

          ],
        ),
      ),
    );
  }
}
