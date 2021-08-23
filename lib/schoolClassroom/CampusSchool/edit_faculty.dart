import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class EditFaculty extends StatefulWidget {
  EditFaculty({required this.doc});
  final List<dynamic> doc;
  @override
  _EditFacultyState createState() => _EditFacultyState();
}

class _EditFacultyState extends State<EditFaculty> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level = TextEditingController();
  TextEditingController _dept = TextEditingController();

  String? level;
  String? subjects;

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  void addData() {
    setState(() {
      _level.text = widget.doc[0]['lv'];
      Objective.items = List.from(widget.doc[0]['sub']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kSappbarbacground,
              title: Text(
                'Edit ${widget.doc[0]['lv']} faculty profile',
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
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          child: Column(children: <Widget>[
                            Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  space(),

                                  ///level
                                  FadeHeading(
                                    title: kSchoolStudent3,
                                  ),
                                  TextFormField(
                                    controller: _level,
                                    maxLines: null,
                                    autocorrect: true,
                                    cursorColor: (kMaincolor),
                                    style: UploadVariables.uploadfontsize,
                                    decoration: Constants.kTopicDecoration,
                                    onSaved: (String? value) {
                                      level = value;
                                    },
                                    validator: Validator.validateSchUn,
                                  ),

                                  ///Adding the department
                                  space(),
                                  FadeHeading(
                                    title: 'Add the departments under this faculty',
                                  ),
                                  ObjectiveList(),

                                  TextFormField(
                                    controller: _dept,
                                    maxLines: null,
                                    autocorrect: true,
                                    cursorColor: (kMaincolor),
                                    style: UploadVariables.uploadfontsize,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              _addSubject();
                                            }),
                                        contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(kPlaylistborder)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: kMaincolor))),
                                    onSaved: (String? value) {
                                      subjects = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            space(),
                            RaisedButton(
                              color: kStabcolor,
                              onPressed: () {
                                _saveLevel();
                              },
                              child: Text(
                                'Update Faculty'.toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ),
                              ),
                            ),
                            space(),
                          ])))
                ]))));
  }

  void _addSubject() {
    //Adding the subject to a list

    if (_dept.text.isNotEmpty) {
      setState(() {
        Objective.items.add(_dept.text.trim());
        _dept.clear();
      });
    } else {
      SchClassConstant.displayToastError(title: 'Add department(s)');
    }
  }

  void _saveLevel() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (_level.text.isEmpty) {
        SchClassConstant.displayToastError(title: 'Enter faculty name');
      } else if (Objective.items.isEmpty) {
        SchClassConstant.displayToastError(
            title: 'Add department under this faculty');
      } else {
        try {
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('schoolFaculty')
              .doc(SchClassConstant.schDoc['schId'])
              .collection('faculty')
              .doc(widget.doc[0]['id']);

          docRef.set({
            'lv': _level.text.trim(),
            'sub': Objective.items,
            'ts': DateTime.now().toString(),
            'crt':
            '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}'
          }, SetOptions(merge: true));

          setState(() {
            progress = false;
          });
          SchClassConstant.displayBotToastCorrect(
              title: '${_level.text.trim()} Faculty updated successfully');
        } catch (e) {
          print(e);
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: kError);
        }
      }
    }
  }
}
