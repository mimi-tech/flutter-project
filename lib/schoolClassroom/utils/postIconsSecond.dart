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

class SchoolPostIconsSecond extends StatefulWidget {
  SchoolPostIconsSecond({
    required this.comments,
    required this.like,
    required this.share,
    required this.viewsNumber,
    required this.commentsNumber,
    required this.likeNumber,
    required this.shareNumber,
    required this.saveVideo,
    required this.myColor,
    this.viewLikes,
    this.viewShare,
  });
  final Function comments;
  final Function like;
  final Function share;
  final Function saveVideo;
  final Color myColor;
  final Widget viewsNumber;
  final dynamic commentsNumber;
  final dynamic likeNumber;
  final dynamic shareNumber;
  final Function? viewLikes;
  final Function? viewShare;

  @override
  _SchoolPostIconsSecondState createState() => _SchoolPostIconsSecondState();
}

class _SchoolPostIconsSecondState extends State<SchoolPostIconsSecond> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: widget.myColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: widget.like as void Function()?,
            onLongPress: widget.viewLikes as void Function()?,
            child: Row(
              children: [
                Icon(Icons.favorite, color: kIconColor),
                //IconButton(icon:(Icon(Icons.thumb_up,color: kMaincolor)), onPressed: widget.like,),
                Text(
                  widget.likeNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
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
                SvgPicture.asset(
                  'images/classroom/comment.svg',
                  color: kIconColor,
                ),
                // IconButton(icon:SvgPicture.asset('images/classroom/comment.svg'), onPressed: widget.comments,),
                Text(
                  widget.commentsNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.share as void Function()?,
            onLongPress: widget.viewShare as void Function()?,
            child: Row(
              children: [
                Icon(
                  Icons.share,
                  color: kIconColor,
                ),
                // IconButton(icon:Icon(Icons.share,color: kMaincolor,), onPressed: widget.share,),
                Text(
                  widget.shareNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.save_alt,
              color: kIconColor,
            ),
            onPressed: widget.saveVideo as void Function()?,
          ),
          widget.viewsNumber,
        ],
      ),
    );
  }
}



///This for saved videos by students


class SchoolPostIconsSavedPost extends StatefulWidget {
  SchoolPostIconsSavedPost({
    required this.comments,
    required this.like,
    required this.share,
    required this.commentsNumber,
    required this.likeNumber,
    required this.shareNumber,
    required this.saveVideo,
    required this.myColor,
    this.viewLikes,
    this.viewShare,
  });
  final Function comments;
  final Function like;
  final Function share;
  final Function saveVideo;
  final Color myColor;
  final dynamic commentsNumber;
  final dynamic likeNumber;
  final dynamic shareNumber;
  final Function? viewLikes;
  final Function? viewShare;

  @override
  _SchoolPostIconsSavedPostState createState() => _SchoolPostIconsSavedPostState();
}

class _SchoolPostIconsSavedPostState extends State<SchoolPostIconsSavedPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: widget.myColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: widget.like as void Function()?,
            onLongPress: widget.viewLikes as void Function()?,
            child: Row(
              children: [
                Icon(Icons.favorite, color: kIconColor),
                //IconButton(icon:(Icon(Icons.thumb_up,color: kMaincolor)), onPressed: widget.like,),
                Text(
                  widget.likeNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
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
                SvgPicture.asset(
                  'images/classroom/comment.svg',
                  color: kIconColor,
                ),
                // IconButton(icon:SvgPicture.asset('images/classroom/comment.svg'), onPressed: widget.comments,),
                Text(
                  widget.commentsNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.share as void Function()?,
            onLongPress: widget.viewShare as void Function()?,
            child: Row(
              children: [
                Icon(
                  Icons.share,
                  color: kIconColor,
                ),
                // IconButton(icon:Icon(Icons.share,color: kMaincolor,), onPressed: widget.share,),
                Text(
                  widget.shareNumber,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: kIconColor,
            ),
            onPressed: widget.saveVideo as void Function()?,
          ),
        ],
      ),
    );
  }
}

