import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class NoStaffWorking extends StatelessWidget {
  NoStaffWorking({required this.noStaff});
  final String noStaff;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          noStaff,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            fontSize: 22.sp,
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
