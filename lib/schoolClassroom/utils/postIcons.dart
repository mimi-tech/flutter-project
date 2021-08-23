import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SchoolPostIcons extends StatefulWidget {
  SchoolPostIcons({
    required this.views,
    required this.comments,
    required this.like,
    required this.share,
    required this.viewsNumber,
    required this.commentsNumber,
    required this.likeNumber,
    required this.shareNumber,
    required this.saveVideo,
  });
  final Function views;
  final Function comments;
  final Function like;
  final Function share;
  final Function saveVideo;

  final dynamic viewsNumber;
  final dynamic commentsNumber;
  final dynamic likeNumber;
  final dynamic shareNumber;

  @override
  _SchoolPostIconsState createState() => _SchoolPostIconsState();
}

class _SchoolPostIconsState extends State<SchoolPostIcons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: widget.views as void Function()?,
          child: Row(
            children: [
              SvgPicture.asset('images/classroom/views.svg'),
              //IconButton(icon:SvgPicture.asset('images/classroom/views.svg'), onPressed:widget.views,),
              Text(
                widget.viewsNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.comments as void Function()?,
          child: Row(
            children: [
              SvgPicture.asset('images/classroom/comment.svg'),
              // IconButton(icon:SvgPicture.asset('images/classroom/comment.svg'), onPressed: widget.comments,),
              Text(
                widget.commentsNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.like as void Function()?,
          child: Row(
            children: [
              Icon(Icons.thumb_up, color: kMaincolor),
              //IconButton(icon:(Icon(Icons.thumb_up,color: kMaincolor)), onPressed: widget.like,),
              Text(
                widget.likeNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.share as void Function()?,
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: kMaincolor,
              ),
              // IconButton(icon:Icon(Icons.share,color: kMaincolor,), onPressed: widget.share,),
              Text(
                widget.shareNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.save_alt,
            color: kMaincolor,
          ),
          onPressed: widget.saveVideo as void Function()?,
        ),
      ],
    );
  }
}
