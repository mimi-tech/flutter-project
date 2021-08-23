import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/course_description2.dart';
import 'package:sparks/classroom/courses/course_include.dart';
import 'package:sparks/classroom/courses/course_requirement.dart';
import 'package:sparks/classroom/courses/next_button.dart';

import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseDescription extends StatefulWidget {
  @override
  _CourseDescriptionState createState() => _CourseDescriptionState();
}

class _CourseDescriptionState extends State<CourseDescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _title = TextEditingController();
  TextEditingController _topic = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _target = TextEditingController();
  TextEditingController _objective = TextEditingController();
  TextEditingController _requirement = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _subTopic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CourseAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Displaying the form
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(children: <Widget>[
                    FadeHeading(
                      title: kSJobProfileDesc,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: kHorizontal),
                      child: TextFormField(
                        controller: _title,
                        maxLength: 500,
                        maxLines: null,
                        autocorrect: true,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kJobDecoration,
                        onSaved: (String? value) {
                          Constants.courseJobProfile = value;
                        },
                        validator: Validator.validateTitle,
                      ),
                    ),

                    //Topic of the course
                    FadeHeading(
                      title: kSCourseTopic,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: kHorizontal),
                      child: TextFormField(
                        controller: _topic,
                        maxLength: 100,
                        maxLines: null,
                        autocorrect: true,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kTopicDecoration,
                        onSaved: (String? value) {
                          Constants.courseTopic = value;
                        },
                        validator: Validator.validateCourseTopic,
                      ),
                    ),

                    ///sub Topic of the course
                    FadeHeading(
                      title: kSCourseSubTopic,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: kHorizontal),
                      child: TextFormField(
                        controller: _subTopic,
                        autocorrect: true,
                        maxLength: 200,
                        maxLines: null,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kTopicDecoration,
                        onSaved: (String? value) {
                          Constants.kCourseSubTopic = value;
                        },
                        validator: Validator.validateCourseSubTopic,
                      ),
                    ),

                    ///Description of the course
                    FadeHeading(
                      title: kSCourseDescription,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: kHorizontal),
                      child: TextFormField(
                        controller: _desc,
                        maxLength: 200,
                        maxLines: null,
                        autocorrect: true,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kTopicDecoration,
                        onSaved: (String? value) {
                          Constants.courseDesc = value;
                        },
                        validator: Validator.validateDesc,
                      ),
                    ),

                    ///Name of the course
                    FadeHeading(
                      title: kSCourseName,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: kHorizontal),
                      child: TextFormField(
                        controller: _name,
                        autocorrect: true,
                        maxLength: 200,
                        maxLines: null,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kTopicDecoration,
                        onSaved: (String? value) {
                          Constants.kCourseName = value;
                        },
                        validator: Validator.validateCourseName,
                      ),
                    ),
                  ]),
                ),
                //who is this course for?
                FadeHeading(
                  title: kCourseTarget2,
                ),
                //ListView for each of the text for targeted students
                TargetItemsList(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: TextFormField(
                    controller: _target,
                    maxLength: 100,
                    maxLines: null,
                    autocorrect: true,
                    cursorColor: (kMaincolor),
                    style: UploadVariables.uploadfontsize,
                    decoration: Constants.kCourseTargetDecoration,
                    onSaved: (String? value) {
                      Constants.courseTarget = value;
                    },
                    onChanged: (String value) {
                      Constants.courseTarget = value;
                    },
                  ),
                ),
                //Add icon and done button
                AddIcon(
                  iconFunction: () {
                    _addTarget();
                  },
                ),
//what students will learn after this course

                //who is this course for?
                SizedBox(height: ScreenUtil().setHeight(kSCourseHeight)),

                FadeHeading(
                  title: kSCourseobj,
                ),
                //ListView for each of the text for targeted students

                ObjectiveList(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: TextFormField(
                    controller: _objective,
                    maxLength: 100,
                    maxLines: null,
                    autocorrect: true,
                    cursorColor: (kMaincolor),
                    style: UploadVariables.uploadfontsize,
                    decoration: Constants.kCourseObjDecoration,
                    onSaved: (String? value) {
                      Constants.kSCourseObj = value;
                    },
                    onChanged: (String value) {
                      Constants.kSCourseObj = value;
                    },
                  ),
                ),

                ///Add icon and done button
                AddIcon(
                  iconFunction: () {
                    _addObjective();
                  },
                ),

                ///Course Requirements
                SizedBox(height: ScreenUtil().setHeight(kSCourseHeight)),

                FadeHeading(
                  title: kSCourseRequirement,
                ),

                ///ListView for each of the text for targeted students

                RequirementList(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: TextFormField(
                    controller: _requirement,
                    maxLength: 100,
                    maxLines: null,
                    autocorrect: true,
                    cursorColor: (kMaincolor),
                    style: UploadVariables.uploadfontsize,
                    decoration: Constants.kCourseReqDecoration,
                    onSaved: (String? value) {
                      Constants.kSCourseReq = value;
                    },
                    onChanged: (String value) {
                      Constants.kSCourseReq = value;
                    },
                  ),
                ),

                ///Add icon and done button
                AddIcon(
                  iconFunction: () {
                    _addRequirement();
                  },
                ),

                ///This course includes
                SizedBox(height: ScreenUtil().setHeight(kSCourseHeight)),

                FadeHeading(
                  title: kSCourseInclude,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: RaisedButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        _showRequirement();
                      },
                      color: kPreviewcolor,
                      child: Text(kSCourseInclude2,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ))),
                ),

                //displaying the next button
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                CourseNextButton(
                  next: () {
                    _nextBtn();
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
              ],
            ),
          )),
    );
  }

  void _addTarget() {
    if (Constants.courseTarget!.isNotEmpty) {
      setState(() {
        TargetedStudents.items.add(Constants.courseTarget);
        _target.clear();
      });
    }
  }

  void _addObjective() {
    if (Constants.kSCourseObj!.isNotEmpty) {
      setState(() {
        Objective.items.add(Constants.kSCourseObj);
        _objective.clear();
      });
    }
  }

//showing students requirements
  void _showRequirement() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  CourseInclude(),
                ]));
  }

  ///course requirements
  void _addRequirement() {
    if (Constants.kSCourseReq!.isNotEmpty) {
      setState(() {
        Requirements.items.add(Constants.kSCourseReq);
        _requirement.clear();
      });
    }
  }

  ///next button
  void _nextBtn() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (TargetedStudents.items.isNotEmpty && Constants.courseTarget == null) {
        Fluttertoast.showToast(
            msg: kSCourseError3,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else if (Objective.items.isNotEmpty && Constants.kSCourseObj == null) {
        Fluttertoast.showToast(
            msg: kSCourseError4,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else if (Included.items.isEmpty) {
        Fluttertoast.showToast(
            msg: kSCourseError6,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else if (Requirements.items.isNotEmpty &&
          Constants.kSCourseReq == null) {
        Fluttertoast.showToast(
            msg: kSCourseError5,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CourseDescriptionSecond()));
      }

      form.save();
    } else {
      print('there is an error');
    }
  }
}
