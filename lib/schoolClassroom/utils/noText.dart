import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class NoTextComment extends StatelessWidget {
  NoTextComment({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
      textAlign:TextAlign.center,
      style: GoogleFonts.rajdhani(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: kBlackcolor,
          fontSize: kFontsize.sp,
        ),
      ),
    );
  }
}
