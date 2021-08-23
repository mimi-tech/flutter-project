import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/create_dept.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_teachers.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/show_admins.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/students_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class SchoolAdminScreen extends StatefulWidget {
  /*SchoolAdminScreen({required this.doc});
  final DocumentSnapshot doc;*/

  @override
  _SchoolAdminScreenState createState() => _SchoolAdminScreenState();
}

class _SchoolAdminScreenState extends State<SchoolAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            tabs: [
              Tab( text: "Sections",),
              Tab( text: "Student"),
              Tab( text: "Admin"),
              Tab( text: "Tutors"),

            ],
            indicatorColor: kWhitecolor,
            indicatorWeight: 4.0,

            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kStabcolor1,
                fontSize: kFontSize14.sp,
              ),),
            unselectedLabelColor: kTextColor,
          ),

          title: RichText(
            text: TextSpan(
                text:'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']} \n'.toUpperCase(),
                style: GoogleFonts.rajdhani(
fontSize:16.sp,fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),

                children: <TextSpan>[
                  TextSpan(text: '${SchClassConstant.schDoc['name'].toString().toUpperCase()}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,
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
            CreateDepartment(),
            StudentsScreen(),
            SchoolAddShowAdmin(),
            TeachersScreen(),
          ],
        ),
      ),
    );
  }
}
