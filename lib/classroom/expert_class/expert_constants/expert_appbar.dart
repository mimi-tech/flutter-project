import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpertAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackcolor, size: 10.0),
      elevation: 4.0,
      backgroundColor: kWhitecolor,
      title: Row(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: SvgPicture.asset(
              'images/classroom/expertclass.svg',
              width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
              height: ScreenUtil().setHeight(klivebtn.roundToDouble()),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(10.0)),
          Container(
            child: Text(
              kExpertClass,
              style: TextStyle(
                fontSize: kFontsize.sp,
                color: kBlackcolor,
                fontFamily: 'Rajdhani',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}
