import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class PlayListBtn extends StatelessWidget {
  PlayListBtn({
    this.name,
    this.create,
    this.save,
    this.saved,
  });
  final String? name;
  final String? save;
  final Function? create;
  final Function? saved;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ///create playlist btn
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(150),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                color: kWhitecolor,
                elevation: 10.0,
                onPressed: create as void Function()?,
                child: Text(
                  name!,
                  style: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kbtnsecond,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),

          ///save button
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(150),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(3.0),
                ),
                color: kbtnsecond,
                elevation: 10.0,
                onPressed: saved as void Function()?,
                child: Text(
                  save!,
                  style: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kWhitecolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
