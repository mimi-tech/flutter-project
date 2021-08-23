import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:uuid/uuid.dart';

class ExpertCompany extends StatefulWidget {
  @override
  _ExpertCompanyState createState() => _ExpertCompanyState();
}

class _ExpertCompanyState extends State<ExpertCompany> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool progress = false;
  final TextEditingController _name = TextEditingController();
  DateTime now = new DateTime.now();
  String? name;
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
                child: Column(children: <Widget>[
                  spacer(),
                  spacer(),
                  FadeHeading(
                    title: kExpertCompany.toUpperCase(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextField(
                      controller: _name,
                      maxLines: null,
                      autocorrect: true,
                      cursorColor: (kMaincolor),
                      style: UploadVariables.uploadfontsize,
                      decoration: Constants.kTopicDecoration,
                      onChanged: (String value) {
                        name = value;
                      },
                    ),
                  ),
                  spacer(),
                  progress == true
                      ? ProgressIndicatorState()
                      : RaisedButton(
                          color: kFbColor,
                          onPressed: () {
                            showPin();
                          },
                          child: Text(
                            'Create',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  spacer(),
                  spacer(),
                ]))));
  }

  Future<void> showPin() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if ((name == null) || (name == '')) {
      Fluttertoast.showToast(
          msg: kNameError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      User currentUser = FirebaseAuth.instance.currentUser!;
      var v1 = uuid.v1();

      String token;

      currentUser.getIdToken().then((result) {
        //token = result.token;
        token = result;

        setState(() {
          progress = true;
        });
        try {
          DocumentReference documentReference =
              FirebaseFirestore.instance.collection("expertCompany").doc();

          documentReference.set({
            'uid': ExpertAdminConstants.foundUserData['id'],
            'fn': ExpertAdminConstants.foundUserData['nm']['fn'],
            'ln': ExpertAdminConstants.foundUserData['nm']['ln'],
            'pix': ExpertAdminConstants.foundUserData['pimg'],
            'email': ExpertAdminConstants.foundUserData['em'],
            'suid': GlobalVariables.loggedInUserObject.id,
            'sfn': GlobalVariables.loggedInUserObject.nm!['fn'],
            'ky': v1,
            'sln': GlobalVariables.loggedInUserObject.nm!['ln'],
            'spix': GlobalVariables.loggedInUserObject.pimg,
            'did': documentReference.id,
            'name': name!.trim(),
            'date': now,
          }).whenComplete(() {
            setState(() {
              progress = false;
            });
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: kCreatedSuccessfully,
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackcolor,
                textColor: kSsprogresscompleted);
          }).catchError((onError) {
            print('this not an error $onError');
            setState(() {
              progress = false;
            });
            Fluttertoast.showToast(
                msg: kNtS,
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackcolor,
                textColor: kFbColor);
          });
        } catch (e) {
          setState(() {
            progress = false;
          });
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      });
    }
  }
}
