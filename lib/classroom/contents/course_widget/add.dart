import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class AddingLectureSections extends StatelessWidget {
  AddingLectureSections({required this.add, required this.title});

  final Function add;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: klistnmber,
        ),
        // borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add,
            size: ScreenUtil().setSp(30.0),
            color: kStabcolor,
          ),
          GestureDetector(
            onTap: add as void Function()?,
            child: Text(
              title,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kBlackcolor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
