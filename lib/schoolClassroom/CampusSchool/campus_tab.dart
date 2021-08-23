import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/allStudentsReport.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_admins.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_tutors.dart';
import 'package:sparks/schoolClassroom/CampusSchool/faculty_screen.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_students_tab.dart';


class CampusAdminTab extends StatefulWidget {
  CampusAdminTab({required this.doc});
  final DocumentSnapshot doc;

  @override
  _CampusAdminTabState createState() => _CampusAdminTabState();
}

class _CampusAdminTabState extends State<CampusAdminTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.school), text: "Faculty",),
              Tab(icon: Icon(Icons.school), text: "Student"),
              Tab(icon: Icon(Icons.school), text: "Admin"),
              Tab(icon: Icon(Icons.school), text: "Lectures"),
              Tab(icon: Icon(Icons.school), text: "Reports"),

            ],
          ),
          title: Text(widget.doc['name'].toString().toUpperCase(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FacultyScreen(),
            CampusStudentsScreen(),
            CampusAddShowAdmin(),
            CampusTutorsScreen(),
            AllSchoolStudentReport()
          ],
        ),
      ),
    );
  }
}
