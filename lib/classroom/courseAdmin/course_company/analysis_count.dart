import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CompanyAnalysisCount extends StatefulWidget {
  CompanyAnalysisCount(
      {required this.online, required this.offLine, required this.name});
  final String offLine;
  final String online;
  final String name;
  @override
  _CompanyAnalysisCountState createState() => _CompanyAnalysisCountState();
}

class _CompanyAnalysisCountState extends State<CompanyAnalysisCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: kExpertColor,
                  height: ScreenUtil().setHeight(kCount),
                  width: ScreenUtil().setWidth(kCount),
                  child: Center(
                    child: Text(
                      'A-Z'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        fontSize: kTwentyTwo.sp,
                        color: kWhitecolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text(
                    widget.online,
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kExpertColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text(
                    widget.offLine,
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kExpertColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text(
                    '#',
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kFbColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                  //color: kExpertColor,
                  height: ScreenUtil().setHeight(kCount),
                  width: ScreenUtil().setWidth(kCount),
                  child: Container(
                    child: Center(
                      child: Text(
                        widget.name.toUpperCase(),
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          color: kExpertColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Container(
            color: kBlackcolor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: ScreenUtil().setWidth(kCount),
                    height: ScreenUtil().setHeight(kCountHeight),
                    color: kBlackcolor,
                    child: SvgPicture.asset(
                      'images/classroom/oo.svg',
                    )),
                Container(
                    height: ScreenUtil().setHeight(kCountHeight),
                    width: ScreenUtil().setWidth(kCount),
                    color: kBlackcolor,
                    child: SvgPicture.asset(
                      'images/classroom/in.svg',
                    )),
                Container(
                    height: ScreenUtil().setHeight(kCountHeight),
                    width: ScreenUtil().setWidth(kCount),
                    color: kBlackcolor,
                    child: SvgPicture.asset(
                      'images/classroom/out.svg',
                    )),
                Container(
                  height: ScreenUtil().setHeight(kCountHeight),
                  width: ScreenUtil().setWidth(kCount),
                  color: kBlackcolor,
                  child: Text(
                    kVerf,
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kWhitecolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(kCountHeight),
                  width: ScreenUtil().setWidth(kCount),
                  color: kBlackcolor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
