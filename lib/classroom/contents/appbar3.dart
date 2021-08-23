import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SilverAppBarThird extends StatefulWidget implements PreferredSizeWidget {
  SilverAppBarThird({
    required this.listPlaylist,
    required this.listDownload,
    required this.listDelete,
  });
  final Function listPlaylist;
  final Function listDownload;
  final Function listDelete;

  @override
  _SilverAppBarThirdState createState() => _SilverAppBarThirdState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _SilverAppBarThirdState extends State<SilverAppBarThird> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      )),
      backgroundColor: kclassroombtncolor,
      pinned: true,
      automaticallyImplyLeading: false,
      elevation: 40.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //TODO:New matches tab
          GestureDetector(
            onTap: widget.listPlaylist as void Function()?,
            child: Text(
              kPlaylist,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),

          //TODO:New matches tab

          GestureDetector(
            child: Text(
              kSpromote,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),
          //TODO:New matches tab

          GestureDetector(
            onTap: widget.listDownload as void Function()?,
            child: Text(
              kSDownload,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),
          GestureDetector(
            onTap: widget.listDelete as void Function()?,
            child: Text(
              kSDelete,
              style: TextStyle(
                  fontSize: kSappbar2.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani'),
            ),
          ),
        ],
      ),
    );
  }
}
