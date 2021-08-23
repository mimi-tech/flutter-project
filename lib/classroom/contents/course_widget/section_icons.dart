import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SectionIcons extends StatefulWidget {
  SectionIcons({
    required this.video,
    required this.attachment,
    required this.title,
    required this.videoTitle,
    required this.attachmentTitle,
    required this.titleName,
  });

  final Function video;
  final Function attachment;
  final Function title;

  final String videoTitle;
  final String attachmentTitle;
  final String titleName;
  @override
  _SectionIconsState createState() => _SectionIconsState();
}

class _SectionIconsState extends State<SectionIcons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //ToDo: Displaying the edit and analysis
        PopupMenuButton(
            child: Icon(
              Icons.more_horiz,
              color: kTextcolorhintcolor,
              size: 30.0,
            ),
            //ToDo:getting the popMenuButton items
            itemBuilder: (context) => [
                  //ToDo:Add to playlist
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: widget.video as void Function()?,
                      child: Text(
                        widget.videoTitle,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor,
                          fontFamily: 'RajdhaniSemiBold',
                        ),
                      ),
                    ),
                  ),

                  //ToDo:Get sharable link

                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: widget.attachment as void Function()?,
                      child: Text(
                        widget.attachmentTitle,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor,
                          fontFamily: 'RajdhaniSemiBold',
                        ),
                      ),
                    ),
                  ),

                  //ToDo:Download video

                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: widget.title as void Function()?,
                      child: Text(
                        widget.titleName,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor,
                          fontFamily: 'RajdhaniSemiBold',
                        ),
                      ),
                    ),
                  ),
                ]),
      ],
    );
  }
}
