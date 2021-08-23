import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/courses/next_button.dart';
class CcSliverAppBar extends StatefulWidget implements PreferredSizeWidget{
  CcSliverAppBar({required this.details,required this.download});
  final Function details;
  final Function download;


  @override
  _CcSliverAppBarState createState() => _CcSliverAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _CcSliverAppBarState extends State<CcSliverAppBar> {



  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
       automaticallyImplyLeading: false,
        pinned: false,
        backgroundColor: kStatusbar,
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BtnSecond(next: widget.details, title: 'Course details', bgColor: kFbColor),

            BtnSecond(next: widget.download, title: 'Download', bgColor: kLightGreen)
          ],
        )
    );
  }
}
