import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/generate_pin.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/expertAdmin/generate_expert_key.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ConfirmExpertAdmin extends StatefulWidget {
  ConfirmExpertAdmin({required this.name, required this.id, this.docs});
  final String? name;
  final String? id;
  final List<dynamic>? docs;
  @override
  _ConfirmExpertAdminState createState() => _ConfirmExpertAdminState();
}

class _ConfirmExpertAdminState extends State<ConfirmExpertAdmin> {
  final TextEditingController _email = TextEditingController();
  String? email;
  bool getUser = false;

  String? fName = '';
  String? lName = '';
  bool progress = false;
  var _documents = [];
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  List<dynamic>? name;
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: getUser == true
              ? Column(
                  children: <Widget>[
                    spacer(),
                    spacer(),
                    Text(
                      'Do you want to generate key for',
                      style: GoogleFonts.rajdhani(
                        fontSize: 22.sp,
                        color: kBlackcolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$fName $lName',
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kFacebookcolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    spacer(),
                    spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: klistnmber,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: kFbColor,
                          onPressed: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => GenerateExpertPin(
                                    name: widget.name, id: widget.id));
                          },
                          child: Text(
                            'Proceed',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer(),
                    spacer(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    spacer(),
                    spacer(),
                    FadeHeading(
                      title: kEnterEmail,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: null,
                        autocorrect: true,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kTopicDecoration,
                        onChanged: (String value) {
                          email = value;
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
                              'Confirm',
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

  Future<void> showPin() async {
    print(_email.text.trim());
    if ((email == null) || (email == '')) {
      Fluttertoast.showToast(
          msg: 'Please put the admin email',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text.trim());
      if (emailValid == true) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          progress = true;
        });
        try {
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collectionGroup('Personal')
              .where('em', isEqualTo: _email.text.trim())
              .get();

          final List<DocumentSnapshot> documents = result.docs;
          if (documents.length == 0) {
            setState(() {
              progress = false;
            });
            Fluttertoast.showToast(
                msg: 'sorry user not found',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackcolor,
                textColor: kFbColor);
          } else {
            for (DocumentSnapshot doc in documents) {
              Map<String, dynamic>? data = doc.data as Map<String, dynamic>?;
              setState(() {
                ExpertAdminConstants.foundUserData = doc;
                fName = data!['nm']['fn'];
                // fName = data['nm']['fn'];
                lName = data['nm']['ln'];
                // lName = data['nm']['ln'];
                progress = false;
                getUser = true;
              });
            }
          }
        } catch (e) {
          setState(() {
            progress = false;
          });

          print(e);
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'sorry put your email address correctly',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }
}
