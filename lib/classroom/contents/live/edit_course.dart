import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/contents/course_widget/forms.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/courses/course_include.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_requirement.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/progress_indicator.dart';

class EditCourses extends StatefulWidget {
  @override
  _EditCoursesState createState() => _EditCoursesState();
}

class _EditCoursesState extends State<EditCourses> {
  var itemsData = [];
  var _documents = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    //  implement initState
    super.initState();

    getData();
  }

  getData() {
    try {
      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('courses')
          .where('id', isEqualTo: Constants.docId)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          setState(() {
            _documents.add(result);
            itemsData.add(result.data());
            List<String> names = List.from(result.data()['targ']);
            TargetedStudents.items.addAll(names);

            List<String> obj = List.from(result.data()['obj']);
            Objective.items.addAll(obj);

            List<String> req = List.from(result.data()['req']);
            Requirements.items.addAll(req);

            List<String> inc = List.from(result.data()['inc']);
            Included.items.addAll(inc);

            ///Next Screen

            List<String> lang = List.from(result.data()['lang']);
            SelectedLanguage.data.addAll(lang);

            List<String> level = List.from(result.data()['level']);
            SelectedLevel.data.addAll(level);

            List<String> cate = List.from(result.data()['cate']);
            SelectedCate.data.addAll(cate);

            Constants.coursePurpose = (result.data()['pur']);

            Constants.courseEditThumbnail = (result.data()['tmb']);
            Constants.courseEditVideo = (result.data()['prom']);

            Constants.courseEditCongrat = (result.data()['cong']);
            Constants.courseEditWelcome = (result.data()['wel']);
            Constants.courseEditAmt = (result.data()['amt']);
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
    TargetedStudents.items.clear();
    Objective.items.clear();
    Requirements.items.clear();
    Included.items.clear();
    SelectedLanguage.data.clear();
    SelectedLevel.data.clear();
    SelectedCate.data.clear();
    Constants.courseJobProfile = null;
    Constants.courseTopic = null;
    Constants.kCourseSubTopic = null;
    Constants.courseDesc = null;
    Constants.coursePurpose = null;
    Constants.courseCongMessage = null;
    Constants.courseWelcomeMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: UpdateCourse(),
            appBar: EditAppBar(
              detailsColor: kStabcolor,
              videoColor: kBlackcolor,
              updateColor: kBlackcolor,
              addColor: kBlackcolor,
              publishColor: kBlackcolor,
            ),
            body: _documents.length == 0
                ? ProgressIndicatorState()
                : SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: itemsData.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Column(
                            children: <Widget>[
                              //Displaying the form
                              Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(children: <Widget>[
                                  FadeHeading(
                                    title: kSJobProfileDesc,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: kHorizontal),
                                    child: TextFormField(
                                      initialValue: itemsData[index]['pdesc'],
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
                                      initialValue: itemsData[index]['topic'],
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

                                  //sub Topic of the course
                                  FadeHeading(
                                    title: kSCourseSubTopic,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: kHorizontal),
                                    child: TextFormField(
                                      initialValue: itemsData[index]['sub'],
                                      autocorrect: true,
                                      maxLength: 200,
                                      maxLines: null,
                                      cursorColor: (kMaincolor),
                                      style: UploadVariables.uploadfontsize,
                                      decoration: Constants.kTopicDecoration,
                                      onSaved: (String? value) {
                                        Constants.kCourseSubTopic = value;
                                      },
                                      validator:
                                          Validator.validateCourseSubTopic,
                                    ),
                                  ),

                                  //Description of the course
                                  FadeHeading(
                                    title: kSCourseDescription,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: kHorizontal),
                                    child: TextFormField(
                                      initialValue: itemsData[index]['desc'],
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

                                  //Name of the course
                                  FadeHeading(
                                    title: kSCourseName,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: kHorizontal),
                                    child: TextFormField(
                                      initialValue: itemsData[index]['name'],
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontal),
                                child: TextFormField(
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
                              AddIcon(
                                iconFunction: () {
                                  _addTarget();
                                },
                              ),
                              SizedBox(
                                  height:
                                      ScreenUtil().setHeight(kSCourseHeight)),

                              FadeHeading(
                                title: kSCourseobj,
                              ),

                              ObjectiveList(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontal),
                                child: TextFormField(
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
                              //Add icon and done button
                              AddIcon(
                                iconFunction: () {
                                  _addObjective();
                                },
                              ),

                              //Course Requirements
                              SizedBox(
                                  height:
                                      ScreenUtil().setHeight(kSCourseHeight)),

                              FadeHeading(
                                title: kSCourseRequirement,
                              ),
                              //ListView for each of the text for targeted students

                              RequirementList(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontal),
                                child: TextFormField(
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

                              //Add icon and done button
                              AddIcon(
                                iconFunction: () {
                                  _addRequirement();
                                },
                              ),

//This course includes
                              SizedBox(
                                  height:
                                      ScreenUtil().setHeight(kSCourseHeight)),

                              FadeHeading(
                                title: kSCourseInclude,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.symmetric(
                                    horizontal: kHorizontal),
                                child: RaisedButton(
                                    onPressed: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
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
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                              ),
                              CourseNextButton(
                                next: () {
                                  _nextBtn();
                                },
                              ),
                              SizedBox(height: ScreenUtil().setHeight(10)),
                            ],
                          );
                        }),
                  )));
  }

  void _addTarget() {
    if (Constants.courseTarget!.isNotEmpty) {
      setState(() {
        TargetedStudents.items.add(Constants.courseTarget);
        Constants.courseTarget = null;
      });
    }
  }

  void _addObjective() {
    if (Constants.kSCourseObj!.isNotEmpty) {
      setState(() {
        Objective.items.add(Constants.kSCourseObj);
        Constants.kSCourseObj = null;
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

//course requirements
  void _addRequirement() {
    if (Constants.kSCourseReq!.isNotEmpty) {
      setState(() {
        Requirements.items.add(Constants.kSCourseReq);
        Constants.kSCourseReq = null;
      });
    }
  }

//next button
  void _nextBtn() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (TargetedStudents.items.isNotEmpty && Constants.courseTarget == '') {
        Fluttertoast.showToast(
            msg: kSCourseError3,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else if (Objective.items.isNotEmpty && Constants.kSCourseObj == '') {
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
      } else if (Requirements.items.isNotEmpty && Constants.kSCourseReq == '') {
        Fluttertoast.showToast(
            msg: kSCourseError5,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CourseForms()));
      }

      form.save();
    } else {
      print('there is an error');
    }
  }
}
