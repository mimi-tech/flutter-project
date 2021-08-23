import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/uploadvideo/widgets/agedialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseAge extends StatefulWidget {
  @override
  _CourseAgeState createState() => _CourseAgeState();
}

class _CourseAgeState extends State<CourseAge> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FadeHeading(
          title: kAgeLimit,
        ),
        Container(
          width: double.maxFinite,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: RaisedButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                ///Age limit method

                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            children: <Widget>[
                              AgeDialog(
                                checkAge: () {
                                  if ((UploadVariables.ageRestriction ==
                                          null) ||
                                      (UploadVariables.childrenAdult == null)) {
                                    Fluttertoast.showToast(
                                        msg: kageLimitError,
                                        toastLength: Toast.LENGTH_LONG,
                                        backgroundColor: kBlackcolor,
                                        textColor: kFbColor);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                              )
                            ]));
              },
              color: kPreviewcolor,
              child: Text(kAge,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kWhitecolor,
                      fontSize: kFontsize.sp,
                    ),
                  ))),
        ),
      ],
    );
  }
}
