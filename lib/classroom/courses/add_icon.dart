import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AddIcon extends StatelessWidget {
  AddIcon({required this.iconFunction});
  final Function iconFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: iconFunction as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset('images/classroom/edit_add.svg'),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Text(
              kSAdd,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class RemoveIcon extends StatelessWidget {
  RemoveIcon({required this.removeIcon});
  final Function removeIcon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: removeIcon as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Row(
          children: <Widget>[
            SvgPicture.asset('images/classroom/edit_add.svg'),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Text(
              'sub',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class EditIcon extends StatelessWidget {
  EditIcon({required this.removeIcon, required this.title});
  final Function removeIcon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: removeIcon as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Row(
          children: <Widget>[
            SvgPicture.asset('images/classroom/edit_add.svg'),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
