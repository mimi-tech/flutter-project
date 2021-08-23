import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class EditCampusTutors extends StatefulWidget {
  EditCampusTutors({required this.doc});
  final DocumentSnapshot doc;
  @override
  _EditCampusTutorsState createState() => _EditCampusTutorsState();
}

class _EditCampusTutorsState extends State<EditCampusTutors> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level = TextEditingController();
  TextEditingController _classes = TextEditingController();
  TextEditingController _fName = TextEditingController();

  String? level;
  String? classes;
  String? fName;
  String? lName;
  int? selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = klistnmber;

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setField();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kSappbarbacground,
            title: Text(
              'Edit ${widget.doc['tc']} profile',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kWhitecolor,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        space(),
                        FadeHeading(
                          title: kCampusTutors,
                        ),
                        Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(children: [
                              ///fName

                              TextFormField(
                                controller: _fName,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  fName = value;
                                },
                                validator: Validator.validateStudent1,
                              ),

                              space(),

                              ///level
                              FadeHeading(
                                title: kCampusTutors1,
                              ),
                              AbsorbPointer(
                                child: TextFormField(
                                  controller: _level,
                                  maxLines: null,
                                  autocorrect: true,
                                  cursorColor: (kMaincolor),
                                  style: UploadVariables.uploadfontsize,
                                  decoration: Constants.kTopicDecoration,
                                  onSaved: (String? value) {
                                    level = value;
                                  },
                                  validator: Validator.validateStudent3,
                                ),
                              ),

                              space(),

                              ///class
                              FadeHeading(
                                title: kCampusTutors2,
                              ),
                              TextFormField(
                                controller: _classes,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  classes = value;
                                },
                                validator: Validator.validateStudent4,
                              ),

                              space(),

                              FadeHeading(
                                title: kCampusTutors3,
                              ),
                              ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedRadio,
                                          activeColor: kBlackcolor,
                                          onChanged: (dynamic val) {
                                            setSelectedRadio(val);

                                            setState(() {
                                              radioColor1 = kBlackcolor;
                                              radioColor2 = klistnmber;
                                            });
                                          },
                                        ),
                                        Text(
                                          kCampusAccess,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: radioColor1,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                      Radio(
                                        value: 2,
                                        groupValue: selectedRadio,
                                        activeColor: kBlackcolor,
                                        onChanged: (dynamic val) {
                                          setSelectedRadio(val);

                                          setState(() {
                                            radioColor2 = kBlackcolor;
                                            radioColor1 = klistnmber;
                                          });
                                        },
                                      ),
                                      Text(
                                        kCampusAccess2,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: radioColor2,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),
                                    ])
                                  ]),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  kCampusTutors4,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: klistnmber,
                                      fontSize: kFontSize14.sp,
                                    ),
                                  ),
                                ),
                              ),
                              progress
                                  ? Center(child: PlatformCircularProgressIndicator())
                                  : RaisedButton(
                                onPressed: () {
                                  _saveStudent();
                                },
                                color: kFbColor,
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kWhitecolor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                      ]),
                    )),
              ))),
    );
  }

  void _saveStudent() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        progress = true;
      });
      final random = Random();
      var pin = random.nextInt(1000000);
      var capitalizedValue = _fName.text.substring(0, 1).toUpperCase();

      try {
        FirebaseFirestore.instance
            .collection('schoolTutors')
            .doc(SchClassConstant.schDoc['schId'])
            .collection('tutors')
            .doc(widget.doc['id'])
            .set({
          'tc': _fName.text.trim(),
          'lv': _level.text.trim(),
          'curs': _classes.text.trim(),
          'cl': _classes.text.trim(),
          'ass': selectedRadio == 1 ? true : false,
          'pin': pin,
          'sk': capitalizedValue,
          'by':
          '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}',
        }, SetOptions(merge: true));
        setState(() {
          progress = false;
        });
        Navigator.pop(context);

        SchClassConstant.displayBotToastCorrect(title: 'Updated successfully');
      } catch (e) {
        setState(() {
          progress = false;
        });
        SchClassConstant.displayBotToastError(title: kError);
      }
    }
  }

  void setField() {
    setState(() {
      _fName.text = widget.doc['tc'];
      _level.text = widget.doc['lv'];
      _classes.text = widget.doc['curs'];
    });

    if (widget.doc['ass'] == true) {
      setState(() {
        selectedRadio = 1;
      });
    } else {
      setState(() {
        selectedRadio = 2;
      });
    }
  }
}
