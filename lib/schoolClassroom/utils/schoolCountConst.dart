import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SchoolCountConst extends StatelessWidget {
  SchoolCountConst({required this.title, required this.desc, });
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
          style: GoogleFonts.rajdhani(
            fontSize:kFontsize.sp,
            fontWeight: FontWeight.bold,
            color: kBlackcolor,
          ),
        ),
        Text(desc,
          style: GoogleFonts.rajdhani(
            fontSize:kFontsize.sp,
            fontWeight: FontWeight.bold,
            color: kIconColor,
          ),
        ),
      ],
    );
  }
}
