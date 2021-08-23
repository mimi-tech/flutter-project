import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:uuid/uuid.dart';

class GenerateExpertPin extends StatefulWidget {
  GenerateExpertPin({required this.name, required this.id});

  final String? name;
  final String? id;

  @override
  _GenerateExpertPinState createState() => _GenerateExpertPinState();
}

class _GenerateExpertPinState extends State<GenerateExpertPin> {
  final TextEditingController _key = TextEditingController();

  var v1;
  String? key;
  bool progress = false;
  bool checkVerify = false;

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
          msg: 'Sorry error occurred',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      v1 = uuid.v1();
/*store the user details in database*/
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
          FirebaseFirestore.instance.collection("expertAdmin").doc();

      documentReference.set({
        'uid': ExpertAdminConstants.foundUserData['id'],
        'fn': ExpertAdminConstants.foundUserData['nm']['fn'],
        'ln': ExpertAdminConstants.foundUserData['nm']['ln'],
        'pimg': ExpertAdminConstants.foundUserData['pimg'],
        'ky': v1,
        'email': ExpertAdminConstants.foundUserData['em'],
        'ts': DateTime.now(),
        'lt': "",
        'st': "",
        'id': documentReference.id,
        'name': widget.name,
        'lg': false,
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
    }
  }
}
