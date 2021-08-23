import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LiveTextSecond extends StatelessWidget {
  const LiveTextSecond({
    required this.aLimit,
    required this.visibility,
  });
  final String? aLimit;
  final String? visibility;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //ToDo:displaying the visibility
        Column(
          children: <Widget>[
            Text(
              kVisibilityplist,
              style: TextStyle(
                fontSize: kSlivevcrfonts.sp,
                color: kSlivevcr,
                fontFamily: 'Rajdhani',
              ),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    child: SvgPicture.asset('images/classroom/views.svg')),
                SizedBox(width: 5.0),
                Text(
                  visibility!,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: kBlackcolor,
                    fontFamily: 'RajdhaniMedium',
                  ),
                ),
              ],
            )
          ],
        ),
        //ToDo:display age limit

        Column(
          children: <Widget>[
            Text(
              kAge,
              style: TextStyle(
                fontSize: kSlivevcrfonts.sp,
                color: kSlivevcr,
                fontFamily: 'Rajdhani',
              ),
            ),
            Text(
              aLimit!,
              style: TextStyle(
                fontSize: kSlivevcrfonts.sp,
                color: kBlackcolor,
                fontFamily: 'RajdhaniMedium',
              ),
            ),
          ],
        ),

        //ToDo:Monitaziation
        Column(
          children: <Widget>[
            Text(
              kSMonitazation,
              style: TextStyle(
                fontSize: kSlivevcrfonts.sp,
                color: kSlivevcr,
                fontFamily: 'Rajdhani',
              ),
            ),
            Text(
              '0ff',
              style: TextStyle(
                fontSize: kSlivevcrfonts.sp,
                color: kBlackcolor,
                fontFamily: 'RajdhaniMedium',
              ),
            ),
          ],
        ),

        //ToDo:Date
      ],
    );
  }
}
