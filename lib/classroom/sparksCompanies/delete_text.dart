import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class DeleteText extends StatelessWidget {
  DeleteText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
          color: kBlackcolor,
          fontWeight: FontWeight.w500,
          fontSize: kFontsize.sp,
        )),
      ),
    );
  }
}
