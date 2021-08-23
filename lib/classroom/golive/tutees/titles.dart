import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/widget/circle_offline.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ListTitlesTutees extends StatefulWidget {
  @override
  _ListTitlesTuteesState createState() => _ListTitlesTuteesState();
}

class _ListTitlesTuteesState extends State<ListTitlesTutees> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          OffLine(),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              '800k',
              style: TextStyle(
                color: klistnmber,
                fontWeight: FontWeight.bold,
                fontSize: kselectedusers.sp,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                //color: kMaincolor.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Text(
                  '',
                  style: TextStyle(
                    color: kFbColor,
                    fontWeight: FontWeight.normal,
                    fontSize: kselectedusers.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
