import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AgeDialog extends StatefulWidget {
  AgeDialog({this.checkAge});
  final Function? checkAge;
  @override
  _AgeDialogState createState() => _AgeDialogState();
}

class _AgeDialogState extends State<AgeDialog> {
  int? selectedRadio;
  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
  }

  bool isChildren = false;
  bool isAdult = false;
  bool? above18 = false;
  bool? below18 = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Column(
          children: <Widget>[
            Text(
              kAgeLimit,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'RajdhaniMedium',
                color: kSelectbtncolor,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Text(
                kAgeLimitText,
                style: TextStyle(
                  fontSize: kFontsize.sp,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'RajdhaniMedium',
                  color: kBlackcolor,
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: kbtnsecond,
                    onChanged: (dynamic val) {
                      UploadVariables.isChecked = true;
                      setSelectedRadio(val);
                      UploadVariables.childrenAdult = "children";
                    },
                  ),

                  /* CircularCheckBox(inactiveColor: kBlackcolor,
                      activeColor: kSelectbtncolor,
                      value: isChildren, onChanged: (bool value) {
                        setState(() {
                          isChildren = value;
                          UploadVariables.childrenAdult = "children";
                          isAdult = false;
                          UploadVariables.highlightAgeLimit = false;
                        });
                      }),*/
                  AutoSizeText(
                    kYes,
                    softWrap: true,
                    maxLines: 2,
                    minFontSize: 12.sp,
                    style: TextStyle(
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'RajdhaniMedium',
                      color: kBlackcolor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: kbtnsecond,
                    onChanged: (dynamic val) {
                      setSelectedRadio(val);
                      UploadVariables.childrenAdult = "Adult";
                    },
                  ),

                  /*CircularCheckBox(inactiveColor: kBlackcolor,
                      activeColor: kSelectbtncolor,
                      value: isAdult, onChanged: (bool value) {
                        setState(() {
                          isAdult = value;
                          UploadVariables.childrenAdult = "Adult";
                          isChildren = false;
                          UploadVariables.highlightAgeLimit = false;
                        });
                      }),*/

                  AutoSizeText(
                    kNo,
                    softWrap: true,
                    maxLines: 2,
                    minFontSize: 12.sp,
                    style: TextStyle(
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'RajdhaniMedium',
                      color: kBlackcolor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 43,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    kLimit,
                    style: TextStyle(
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'RajdhaniMedium',
                      color: kBlackcolor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            //ToDo: displaying the age limit restrictions

            Row(
              children: <Widget>[
                Checkbox(
                    activeColor: kFbColor,
                    value: above18,
                    onChanged: (bool? value) {
                      setState(() {
                        above18 = value;
                        if (above18 == true) {
                          below18 = false;
                          UploadVariables.ageRestriction = '18 above';
                        }
                      });
                    }),
                AutoSizeText(kSrestricted,
                    softWrap: true,
                    maxLines: 2,
                    minFontSize: 12.sp,
                    style: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                        fontSize: kFontsize.sp,
                        color: kBlackcolor,
                      ),
                    ))
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(
                    activeColor: kFbColor,
                    value: below18,
                    onChanged: (bool? value) {
                      setState(() {
                        below18 = value;
                        if (below18 == true) {
                          above18 = false;
                          UploadVariables.ageRestriction = '18 below';
                        }
                      });
                    }),
                AutoSizeText(kSrestricted2,
                    softWrap: true,
                    maxLines: 2,
                    minFontSize: 12.sp,
                    style: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                        fontSize: kFontsize.sp,
                        color: kBlackcolor,
                      ),
                    ))
              ],
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  elevation: 10,
                  onPressed: widget.checkAge as void Function()?,
                  child: Text(
                    kSapply,
                    style: UploadVariables.uploadbtnfontsize,
                  ),
                  color: kbtnsecond,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
