import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class WidgetHeadings extends StatelessWidget {
  WidgetHeadings({this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 20.0,
        ),
        child: Text(
          title!,
          style: TextStyle(
            fontSize: kFontsize.sp,
            color: kMaincolor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rajdhani',
          ),
        ),
      ),
    );
  }
}
