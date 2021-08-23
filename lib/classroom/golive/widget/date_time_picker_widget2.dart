import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

import '../variable_live_modal.dart';

import 'notifiaction_dialog.dart';

class DateTimePickerWidget2 extends StatefulWidget {
  DateTimePickerWidget2({this.title});
  final String? title;
  @override
  _DateTimePickerWidget2State createState() => _DateTimePickerWidget2State();
}

class _DateTimePickerWidget2State extends State<DateTimePickerWidget2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 3.0,),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                text: widget.title,
                style: TextStyle(
                  color: kAshmainthumbnailcolor,
                  fontSize: kFontsize.sp,
                  fontFamily: 'Rajdhani',
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: " " + kPickDate,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: kFontsize.sp,
                        color: kSelectbtncolor,
                        fontFamily: 'Rajdhani',
                      )),
                ],
              ),
            ),
            onPressed: () async {
              showDateTimeDialog(context, initialDate: Variables.selectedDate,
                  onSelectedDate: (selectedDate) {
                setState(() {
                  Variables.selectedDate = selectedDate!;
                });
              });
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 14.0,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  Variables.dateFormat.format(Variables.selectedDate),
                  style: TextStyle(
                    fontSize: kFontsize.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
