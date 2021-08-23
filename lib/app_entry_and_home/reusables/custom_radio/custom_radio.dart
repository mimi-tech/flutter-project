import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class CustomRadio extends StatelessWidget {
  final String radioTag;
  final Function radioSelected;
  final Widget? radioChecked;

  CustomRadio({
    required this.radioTag,
    required this.radioSelected,
    required this.radioChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.02,
      ),
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.06,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: radioSelected as void Function()?,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  maxRadius: 14.0,
                  backgroundColor: kWhiteColour,
                  child: radioChecked,
                ),
              ),
              Text(
                radioTag,
                style: TextStyle(
                  fontSize: kVerifying_size.sp,
                  color: kRadio_color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
