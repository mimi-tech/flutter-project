import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class CustomCheckbox extends StatelessWidget {
  final Function check;
  final Color borderColor;
  final Color backgroundColor;
  final Widget checkedWidget;
  final String checkboxLabel;

  CustomCheckbox({
    required this.check,
    required this.borderColor,
    required this.backgroundColor,
    required this.checkedWidget,
    required this.checkboxLabel,
  });

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(
//      context,
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      allowFontScaling: true,
//    );

    return GestureDetector(
      onTap: check as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.04,
            height: MediaQuery.of(context).size.height * 0.02,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                left: BorderSide(
                  color: borderColor,
                ),
                top: BorderSide(
                  color: borderColor,
                ),
                right: BorderSide(
                  color: borderColor,
                ),
                bottom: BorderSide(
                  color: borderColor,
                ),
              ),
            ),
            child: checkedWidget,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),
          Text(
            checkboxLabel,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontSize: kVerifying_size.sp,
                fontWeight: FontWeight.w700,
                color: kReg_title_colour,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
