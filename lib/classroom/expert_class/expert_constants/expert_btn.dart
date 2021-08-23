import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertBtn extends StatelessWidget {
  ExpertBtn({required this.next, required this.bgColor});
  final Function next;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(50),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RaisedButton(
          onPressed: next as void Function()?,
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            kNextbtn,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: 22.sp,
              ),
            ),
          )),
    );
  }
}
