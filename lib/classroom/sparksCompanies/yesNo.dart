import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class YesNoBtn extends StatelessWidget {
  YesNoBtn({required this.no, required this.yes});
  final Function no;
  final Function yes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: no as void Function()?,
          color: klistnmber,
          child: Text(
            'No',
            style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
              color: kWhitecolor,
              fontWeight: FontWeight.bold,
              fontSize: kFontsize.sp,
            )),
          ),
        ),
        RaisedButton(
          onPressed: yes as void Function()?,
          color: kFbColor,
          child: Text(
            'Yes',
            style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
              color: kWhitecolor,
              fontWeight: FontWeight.bold,
              fontSize: kFontsize.sp,
            )),
          ),
        )
      ],
    );
  }
}
