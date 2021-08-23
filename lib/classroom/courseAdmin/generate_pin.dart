import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:uuid/uuid.dart';

class GeneratePin extends StatefulWidget {
  GeneratePin({required this.name, required this.id});
  final String? name;
  final String? id;
  @override
  _GeneratePinState createState() => _GeneratePinState();
}

class _GeneratePinState extends State<GeneratePin> {
  final TextEditingController _key = TextEditingController();

  String? key;
  bool progress = false;
  bool checkVerify = false;
  var v1;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: kWhitecolor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(kmodalborderRadius),
              topLeft: Radius.circular(kmodalborderRadius),
            )),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: Column(
            children: <Widget>[
              spacer(),
              spacer(),
              checkVerify
                  ? Text(
                      'Admin pin generated successfully'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontSize: 20.sp,
                        color: kSky_blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      'Generate Admin pin'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontSize: 20.sp,
                        color: kMaincolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              checkVerify
                  ? Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: v1));
                          Fluttertoast.showToast(
                              msg: 'Copied',
                              gravity: ToastGravity.CENTER,
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: klistnmber,
                              textColor: kWhitecolor);
                        },
                        icon: Icon(Icons.copy),
                      ),
                    )
                  : Text(''),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: TextField(
                  readOnly: true,
                  controller: _key,
                  autocorrect: true,
                  cursorColor: (kMaincolor),
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kWhitecolor,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: Constants.kTopicDecoration,
                  onChanged: (String value) {
                    key = value;
                  },
                ),
              ),
              spacer(),
              progress == true
                  ? ProgressIndicatorState()
                  : checkVerify
                      ? RaisedButton(
                          color: kDarkBlue,
                          onPressed: () {
                            //print(ExpertAdminConstants.userData[0]['nm']['fn']);
                            activatePin();
                          },
                          child: Text(
                            'Activate',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : RaisedButton(
                          color: kFbColor,
                          onPressed: () {
                            //print(ExpertAdminConstants.userData[0]['nm']['fn']);
                            showPin();
                          },
                          child: Text(
                            'Generate',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              spacer(),
              spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void showPin() {
    var now = DateTime.now();
    if (_key.text == null) {
      Fluttertoast.showToast(
          msg: 'Sorry error occured',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      v1 = uuid.v1();
      setState(() {
        checkVerify = true;
      });
    }
  }

  void activatePin() {
    try {
      setState(() {
        progress = true;
        checkVerify = true;
      });
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("courseAdmin").doc();

      documentReference.set({
        'uid': CourseAdminConstants.userData['id'],
        'fn': CourseAdminConstants.userData['nm']['fn'],
        'ln': CourseAdminConstants.userData['nm']['ln'],
        'pimg': CourseAdminConstants.userData['pimg'],
        'ky': v1,
        'email': CourseAdminConstants.userData['em'],
        'ts': DateTime.now(),
        'lt': "",
        'st': "",
        'id': documentReference.id,
        'name': widget.name,
        'cid': widget.id,
        'lg': false
      }).whenComplete(() {
        setState(() {
          progress = false;
          checkVerify = false;
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'Key generated successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);
      }).catchError((error) {
        setState(() {
          progress = false;
          checkVerify = false;
        });

        Fluttertoast.showToast(
            msg: 'Sorry error occured',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      });
    } catch (e) {
      setState(() {
        checkVerify = false;

        progress = false;
      });

      print(e);
    }
  }
}
