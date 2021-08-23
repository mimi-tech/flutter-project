import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PlaylistAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20.0),
        bottomLeft: Radius.circular(20.0),
      )),
      iconTheme: IconThemeData(color: kWhitecolor, size: 15.0),
      elevation: 4.0,
      backgroundColor: kplaylistappbar,
      title: Text(
        kPlisttext.toUpperCase(),
        style: TextStyle(
          fontSize: kFontsize.sp,
          color: kWhitecolor,
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
// TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
