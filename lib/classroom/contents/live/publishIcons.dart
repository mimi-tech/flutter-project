import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PublishedShowIcons extends StatefulWidget {
  PublishedShowIcons(
      {required this.delete, required this.copyLink, required this.edit});

  final Function delete;

  final Function copyLink;
  final Function edit;
  @override
  _PublishedShowIconsState createState() => _PublishedShowIconsState();
}

class _PublishedShowIconsState extends State<PublishedShowIcons> {
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
                  //ToDo:Edit details
                  PopupMenuItem(
                    child: GestureDetector(
                      child: Text(
                        kSedit,
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
                      onTap: widget.copyLink as void Function()?,
                      child: Text(
                        kSgetlink,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor,
                          fontFamily: 'RajdhaniSemiBold',
                        ),
                      ),
                    ),
                  ),

                  //ToDo:promote
                  PopupMenuItem(
                    child: GestureDetector(
                      child: Text(
                        kSpromote,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor,
                          fontFamily: 'RajdhaniSemiBold',
                        ),
                      ),
                    ),
                  ),

                  //ToDo:delete video
                  PopupMenuItem(
                    child: GestureDetector(
                        child: Text(
                          kSDelete,
                          style: TextStyle(
                            fontSize: kFontsize.sp,
                            color: kBlackcolor,
                            fontFamily: 'RajdhaniSemiBold',
                          ),
                        ),
                        onTap: widget.delete as void Function()?),
                  ),
                ]),
        SizedBox(
          height: 10.0,
        ),
        //ToDo: Displaying the edit icon
        GestureDetector(
            onTap: widget.edit as void Function()?,
            child: Icon(
              Icons.edit,
              color: klistnmber,
              size: 20.0,
            )),
        SizedBox(
          height: 10.0,
        ),
        //ToDo: Analysis button

        GestureDetector(
            child: SvgPicture.asset('images/classroom/analysis.svg')),
      ],
    );
  }
}
