import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditButton extends StatefulWidget {
  EditButton(
      {required this.ageLimit, required this.playlist, required this.contacts});
  final Function ageLimit;
  final Function playlist;
  final Function contacts;
  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: ScreenUtil().setWidth(120),
              minHeight: ScreenUtil().setHeight(55),
            ),
            child: RaisedButton(
              onPressed: widget.ageLimit as void Function()?,
              color: kSeditbtncolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                kAge,
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.w700,
                  textStyle: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.contacts as void Function()?,
            child: Container(
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    'images/classroom/viewsorange.svg',
                    color: kFbColor,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(2.0),
                  ),
                  Text(
                    UploadVariables.playlistVisibility,
                    style: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.w700,
                      textStyle: TextStyle(
                        fontSize: kFontsize.sp,
                        color: kFbColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: kFbColor,
                  )
                ],
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: ScreenUtil().setWidth(120),
              minHeight: ScreenUtil().setHeight(55),
            ),
            child: RaisedButton(
              onPressed: widget.playlist as void Function()?,
              color: kSeditbtncolor,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              child: Text(
                kPlisttext,
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EditText extends StatelessWidget {
  EditText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          title + " :",
          style: GoogleFonts.rajdhani(
            fontWeight: FontWeight.w700,
            textStyle: TextStyle(
              fontSize: 22.sp,
              color: kFbColor,
            ),
          ),
        ),
      ),
    );
  }
}
