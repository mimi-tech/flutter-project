import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewUsedSwitcher extends StatelessWidget {
  final String buttonText;
  final Function onTap;
  final Color boxColor;
  final TextStyle textStyle;

  NewUsedSwitcher(
      {required this.buttonText,
      required this.onTap,
      required this.boxColor,
      required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(56),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          color: boxColor,
          border: Border.all(
            color: Color(0xff464646),
          ),
        ),
        child: Text(
          buttonText,
          style: textStyle,
        ),
      ),
    );
  }
}
