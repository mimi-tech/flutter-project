import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class DeletingFile extends StatefulWidget {
  DeletingFile({required this.oneDelete, required this.title});
  final Function oneDelete;
  final String title;
  @override
  _DeletingFileState createState() => _DeletingFileState();
}

class _DeletingFileState extends State<DeletingFile> {
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        kSwarning,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.sp,
          color: kFbColor,
          fontFamily: 'Rajdhani',
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: kFontsize.sp,
            color: kBlackcolor,
            fontFamily: 'RajdhaniMedium',
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          children: <Widget>[
            Checkbox(
                autofocus: true,
                activeColor: kFbColor,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: UploadVariables.monVal,
                onChanged: (bool? value) {
                  setState(() {
                    UploadVariables.monVal = value;
                  });
                }),
            Text(
              kSdetetealert2,
              style: TextStyle(
                fontSize: kFontsize.sp,
                color: kBlackcolor,
                fontFamily: 'RajdhaniMedium',
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            child: Text(
              kCancel,
              style: TextStyle(
                fontSize: kFontsize.sp,
                color: kBlackcolor,
                fontFamily: 'Rajdhani',
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: klistnmber)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          //ToDo:continue to delete this video
          FlatButton(
              child: Text(
                kSYesdelete,
                style: TextStyle(
                  fontSize: kFontsize.sp,
                  color: kBlackcolor,
                  fontFamily: 'Rajdhani',
                ),
              ),
              onPressed: widget.oneDelete as void Function()?,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color: klistnmber,
                ),
              ))
        ],
      ),
    ]);
  }
}

class DeleteDialogSecond extends StatelessWidget {
  DeleteDialogSecond({required this.oneDelete});
  final Function oneDelete;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        kSwarning,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.sp,
          color: kFbColor,
          fontFamily: 'Rajdhani',
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Text(
          kSDeleteAlert2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: kFontsize.sp,
            color: kBlackcolor,
            fontFamily: 'RajdhaniMedium',
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            child: Text(
              kCancel,
              style: TextStyle(
                fontSize: kFontsize.sp,
                color: kBlackcolor,
                fontFamily: 'Rajdhani',
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: klistnmber)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          //ToDo:continue to delete this video
          FlatButton(
              child: Text(
                kSYesdelete,
                style: TextStyle(
                  fontSize: kFontsize.sp,
                  color: kBlackcolor,
                  fontFamily: 'Rajdhani',
                ),
              ),
              onPressed: oneDelete as void Function()?,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color: klistnmber,
                ),
              ))
        ],
      ),
    ]);
  }
}
