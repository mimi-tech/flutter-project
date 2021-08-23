import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class PersonalTextInfo extends StatelessWidget {
  final Animation<Offset>? offset;
  final Animation<double>? fadeAnimation;
  final String info;

  PersonalTextInfo({
    required this.offset,
    required this.fadeAnimation,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(
//      context,
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      allowFontScaling: true,
//    );

    return SlideTransition(
      position: offset!,
      child: FadeTransition(
        opacity: fadeAnimation!,
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Center(
            child: Text(
              info,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RajdhaniMedium',
                color: kRadio_color,
                fontSize: kSize_17.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
