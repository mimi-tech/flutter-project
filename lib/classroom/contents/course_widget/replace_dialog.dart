import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ReplaceDialog extends StatelessWidget {
  ReplaceDialog({required this.oneReplace, required this.title});
  final Function oneReplace;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.rajdhani(
            fontSize: 22.sp, color: kFbColor, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Text(
          kReplaceLectureText,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
              fontSize: kFontsize.sp,
              color: kBlackcolor,
              fontWeight: FontWeight.w600),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            child: Text(
              kCancel,
              style: GoogleFonts.rajdhani(
                fontSize: 22.sp,
                color: kBlackcolor,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: klistnmber)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          //ToDo:continue to delete this video
          FlatButton(
              color: kStabcolor,
              child: Text(
                kProceed,
                style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kWhitecolor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: oneReplace as void Function()?,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color: klistnmber,
                ),
              ))
        ],
      ),
    ]);
  }
}
