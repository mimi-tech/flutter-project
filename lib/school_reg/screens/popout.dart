import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_country_state/flutter_country_state.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';

import 'package:sparks/company/screens/third_screen.dart';

class PopOut extends StatefulWidget {
  PopOut({required this.pop});
  final Function pop;
  @override
  _PopOutState createState() => _PopOutState();
}

class _PopOutState extends State<PopOut> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 18.0, left: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            color: kFbColor,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 20.sp,
                color: kBlackcolor,
                fontFamily: 'Rajdhani',
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Done',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: kBlackcolor,
                  fontFamily: 'Rajdhani',
                )),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4.0),
              side: BorderSide(color: klistnmber),
            ),
            onPressed: widget.pop as void Function()?,
          )
        ],
      ),
    );
  }
}
