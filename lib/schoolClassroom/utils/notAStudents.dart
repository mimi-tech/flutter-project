import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class NotAStudent extends StatefulWidget {
  @override
  _NotAStudentState createState() => _NotAStudentState();
}

class _NotAStudentState extends State<NotAStudent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Container(
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Sorry this student is not accessible. Thanks',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
              ),
            ),
          ),
        ),
      )),
    );
  }
}
