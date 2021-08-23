import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/class/edit_class_details.dart';
import 'package:sparks/classroom/contents/class/edit_expert_sections.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/contents/course_widget/lectures.dart';

import 'package:sparks/classroom/contents/live/edit_course.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class EditExpertAppBar extends StatelessWidget implements PreferredSizeWidget {
  EditExpertAppBar({
    required this.detailsColor,
    required this.videoColor,
  });
  final Color detailsColor;
  final Color videoColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackcolor, size: 10.0),
      elevation: 4.0,
      backgroundColor: kWhitecolor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ///save button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditClassDetails()));
            },
            child: Text(
              'Class Details',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: detailsColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditSections()));
            },
            child: Text(
              'Class sections',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: videoColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class UpdateCourse extends StatefulWidget {
  @override
  _UpdateCourseState createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {
  @override
  Widget build(BuildContext context) {
    return ExpertEditConstants.classVerified == 'Not verified'
        ? Text('')
        : Container(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.update, color: kWhitecolor, size: 30),
                  Text('update',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kWhitecolor,
                          fontSize: kFontsize.sp,
                        ),
                      ))
                ],
              ),
              backgroundColor: kFbColor,
            ),
          );
  }
}
