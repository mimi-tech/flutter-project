import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class TextConstants extends StatelessWidget {
  TextConstants({required this.text1});
  final String text1;
  @override
  Widget build(BuildContext context) {
    return  Text(text1,
      style: GoogleFonts.rajdhani(
        decoration: TextDecoration.underline,
        fontSize:16.sp,
        color: kExpertColor,
        fontWeight: FontWeight.bold,

      ),);
  }
}


class CountText extends StatelessWidget {
  CountText({required this.text1,required this.text2});
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text1,
          style: GoogleFonts.rajdhani(
            fontSize: 14.sp,
            color: kFbColor,
            fontWeight: FontWeight.bold,

          ),),

        Text(text2,
          style: GoogleFonts.rajdhani(
            fontSize:kFontsize.sp,
            color: kBlackcolor,
            fontWeight: FontWeight.w500,

          ),),


      ],
    );
  }
}
