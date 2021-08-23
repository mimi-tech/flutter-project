import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_teachers.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/show_admins.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/students_screen.dart';
import 'package:sparks/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/class_socials.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/social_studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_feed.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_lessons.dart';

class TeachersTab extends StatefulWidget {
  @override
  _TeachersTabState createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
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
              Tab( text: "Feeds"),
              Tab( text: "Chat"),

            ],
          ),
          title: RichText(
            text: TextSpan(
                text:
                    '${SchClassConstant.schDoc['name'].toString().toUpperCase()} \n',
                style: GoogleFonts.rajdhani(

                  fontSize:16.sp,
                  fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${SchClassConstant.schDoc['tc']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,

                      fontWeight: FontWeight.normal,
                      color: kStabcolor1,
                    ),
                  ),
                  TextSpan(
                    text:
                        ': ${SchClassConstant.schDoc['lv']} ${SchClassConstant.schDoc['cl']}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 16.sp,

                      fontWeight: FontWeight.normal,
                      color: kMaincolor,
                    ),
                  ),
                ]),
          ),
        ),
        body: TabBarView(
          children: [
            TeacherStudies(),
            TeacherSocialStudies(),
            TeachersFeeds(),
            ChatScreen(),
          ],
        ),
      ),
    );
  }
}
