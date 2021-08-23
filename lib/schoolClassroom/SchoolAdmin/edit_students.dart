import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class EditStudents extends StatefulWidget {
  EditStudents({required this.doc});
  final DocumentSnapshot doc;
  @override
  _EditStudentsState createState() => _EditStudentsState();
}

class _EditStudentsState extends State<EditStudents> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level = TextEditingController();
  TextEditingController _classes = TextEditingController();
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  List<dynamic> schoolLevels = <dynamic>[];
  List<dynamic> schoolClasses = <dynamic>[];
  List<dynamic> workingDocuments = <dynamic>[];

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

    getSchoolDetails();
    setField();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kSappbarbacground,
            title: Text(
              'Edit ${widget.doc['fn']} profile',
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
              child: Container(
                  child: workingDocuments.length == 0 && progress == false
                      ? Center(child: PlatformCircularProgressIndicator())
                      : workingDocuments.length == 0 && progress == true
                      ? Center(
                      child: NoContentCreated(
                        title:
                        'You have not registered your school departments',
                      ))
                      : SingleChildScrollView(
                    child: Column(children: <Widget>[
                      space(),
                      FadeHeading(
                        title: kSchoolStudent1,
                      ),
                      Form(
                          key: _formKey,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
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

                            ///lName
                            space(),
                            FadeHeading(
                              title: kSchoolStudent2,
                            ),
                            TextFormField(
                              controller: _lName,
                              maxLines: null,
                              autocorrect: true,
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                              onSaved: (String? value) {
                                lName = value;
                              },
                              validator: Validator.validateStudent2,
                            ),

                            space(),

                            ///level
                            FadeHeading(
                              title: kSchoolStudent3,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                getLevels();
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _level,
                                  maxLines: null,
                                  autocorrect: true,
                                  cursorColor: (kMaincolor),
                                  style:
                                  UploadVariables.uploadfontsize,
                                  decoration:
                                  Constants.kTopicDecoration,
                                  onSaved: (String? value) {
                                    level = value;
                                  },
                                  validator:
                                  Validator.validateStudent3,
                                ),
                              ),
                            ),

                            space(),

                            ///class
                            FadeHeading(
                              title: kSchoolStudent4,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                getClasses();
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _classes,
                                  maxLines: null,
                                  autocorrect: true,
                                  cursorColor: (kMaincolor),
                                  style:
                                  UploadVariables.uploadfontsize,
                                  decoration:
                                  Constants.kTopicDecoration,
                                  onSaved: (String? value) {
                                    classes = value;
                                  },
                                  validator:
                                  Validator.validateStudent4,
                                ),
                              ),
                            ),

                            space(),

                            FadeHeading(
                              title: kSchoolStudent5,
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
                                        'Yes',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
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
                                      'No',
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

                            progress
                                ? Center(
                                child:
                                PlatformCircularProgressIndicator())
                                : RaisedButton(
                              onPressed: () {
                                _saveStudent();
                              },
                              color: kFbColor,
                              child: Text(
                                'Save',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ),
                              ),
                            ),
                          ]))
                    ]),
                  )))),
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
      var userName = faker.internet.userName();
      var pin = random.nextInt(1000000);
      var capitalizedValue = _fName.text.substring(0, 1).toUpperCase();

      try {
        FirebaseFirestore.instance
            .collection('classroomStudents')
            .doc(SchClassConstant.schDoc['schId'])
            .collection('students')
            .doc(widget.doc['did'])
            .set({
          'fn': _fName.text.trim(),
          'ln': _lName.text.trim(),
          'lv': _level.text.trim(),
          'cl': _classes.text.trim(),
          'sk': capitalizedValue,
          'ass': selectedRadio == 1 ? true : false,
          'un': userName,
          'pin': pin,
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

  void getLevels() {
//display a dialog to show list of all levels in this school

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            title: Text(
              'Registered levels',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kFbColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
            children: <Widget>[
              Column(children: <Widget>[
                ListView.builder(
                    itemCount: schoolLevels.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _level.text = schoolLevels[index];
                          });
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.circle,
                          color: kFbColor,
                        ),
                        title: Text(
                          schoolLevels[index],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      );
                    })
              ])
            ]));
  }

  void getClasses() {
//display a dialog to show list of all levels in this school

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            title: Text(
              'Registered classes',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kFbColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
            children: <Widget>[
              Column(children: <Widget>[
                ListView.builder(
                    itemCount: schoolClasses.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _classes.text = schoolClasses[index];
                          });
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.circle,
                          color: kFbColor,
                        ),
                        title: Text(
                          schoolClasses[index],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      );
                    })
              ])
            ]));
  }

  Future<void> getSchoolDetails() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('levelClasses')
        .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
        .orderBy('ts', descending: true)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        setState(() {
          workingDocuments.add(data);
          schoolLevels.add(data!['lv']);
          schoolClasses.add(data['class']);
        });
      }
    }
  }

  void setField() {
    setState(() {
      _fName.text = widget.doc['fn'];
      _lName.text = widget.doc['ln'];
      _level.text = widget.doc['lv'];
      _classes.text = widget.doc['cl'];
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
