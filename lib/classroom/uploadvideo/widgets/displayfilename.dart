import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class DisplayFileName extends StatefulWidget {
  @override
  _DisplayFileNameState createState() => _DisplayFileNameState();
}

class _DisplayFileNameState extends State<DisplayFileName> {
  List<String> selectedVideoFileName = <String>[
    'nssssssssssssssssssssssssssssssssxjns',
    'jnxnnnnnnnnnnnnnnnnnnnnnxsASSSSSSSSSSSSSSSSSSSSS'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: selectedVideoFileName.length,
        itemBuilder: (context, index) {
          return Container(
            child: Text(
              selectedVideoFileName[index],
              style: TextStyle(
                fontSize: kFontsize.sp,
                color: klistnmber,
                fontFamily: 'Rajdhani',
              ),
            ),
          );
        });
  }
}
