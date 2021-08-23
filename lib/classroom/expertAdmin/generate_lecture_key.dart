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
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:uuid/uuid.dart';

class GenerateLecturerKey extends StatefulWidget {
  @override
  _GenerateLecturerKeyState createState() => _GenerateLecturerKeyState();
}

class _GenerateLecturerKeyState extends State<GenerateLecturerKey> {
  final TextEditingController _key = TextEditingController();

  String? key;
  bool progress = false;
  bool checkVerify = false;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  var uuid = Uuid();
  var v1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    v1 = uuid.v1();
  }

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
              checkVerify
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Text(
                        'Expert pin generated successfully for ${ExpertAdminConstants.lecturesKey['nm']['fn']}'
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                          fontSize: 20.sp,
                          color: kSky_blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Text(
                        'Generate Expert pin for ${ExpertAdminConstants.lecturesKey['nm']['fn']}'
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                          fontSize: 20.sp,
                          color: kMaincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
    if (_key.text == null) {
      Fluttertoast.showToast(
          msg: 'Sorry error occured',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        checkVerify = true;
      });
    }
  }

  void activatePin() {
    try {
      setState(() {
        progress = true;
      });
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("expertKey").doc();

      documentReference.set({
        'uid': ExpertAdminConstants.lecturesKey['id'],
        'fn': ExpertAdminConstants.lecturesKey['nm']['fn'],
        'pimg': ExpertAdminConstants.lecturesKey['pimg'],
        'ky': v1,
        'email': ExpertAdminConstants.lecturesKey['em'],
        'ts': DateTime.now(),
        'id': documentReference.id,
      }).whenComplete(() {
        setState(() {
          progress = false;
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'Key activated successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);
      }).catchError((error) {
        setState(() {
          progress = false;
        });

        Fluttertoast.showToast(
            msg: 'Sorry error occured',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      });
    } catch (e) {
      setState(() {
        progress = false;
      });

      print(e);
    }
  }
}
