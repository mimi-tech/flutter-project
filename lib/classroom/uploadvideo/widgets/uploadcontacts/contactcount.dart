import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/widget/circle_offline.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class UploadContactCount extends StatefulWidget {
  @override
  _UploadContactCountState createState() => _UploadContactCountState();
  static var contactListNumber = [];
}

class _UploadContactCountState extends State<UploadContactCount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
  }

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
          if (Uploadcontacts.lcontacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kMaincolor.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(5.0) //
                      ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Text(
                    'selected' +
                        " " +
                        Uploadcontacts.lcontacts.length.toString(),
                    style: TextStyle(
                      color: kFbColor,
                      fontWeight: FontWeight.normal,
                      fontSize: kselectedusers.sp,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(child: Text('')),
        ],
      ),
    );
  }
}
