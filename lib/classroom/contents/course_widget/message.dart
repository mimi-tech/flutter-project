import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/live/courses.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';

import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditCourseMessage extends StatefulWidget {
  @override
  _EditCourseMessageState createState() => _EditCourseMessageState();
}

class _EditCourseMessageState extends State<EditCourseMessage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _publishModal = false;
  List<String> _amount = [
    'Free',
    '10.99',
    '19.99',
    '49.99',
    '50.99'
  ]; // Option 2

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
        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FadeHeading(
                  title: kSCoursePricing,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      onPressed: () {},
                      child: Text('USD',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(30),
                    ),
                    Container(
                      child: DropdownButton(
                        hint: Text(Constants.courseEditAmt ?? kSCourseAmount,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            )), // Not necessary for Option 1
                        value: Constants.courseEditAmt,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            Constants.courseEditAmt = newValue;
                          });
                        },
                        items: _amount.map((amount) {
                          return DropdownMenuItem(
                            child: Text(amount,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBlackcolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                )),
                            value: amount,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      FadeHeading(
                        title: kSCourseMessage,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: kHorizontal),
                        child: TextFormField(
                          initialValue: Constants.courseEditCongrat,
                          maxLength: 200,
                          maxLines: null,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            Constants.courseCongMessage = value;
                          },
                          validator: Validator.validateCong,
                        ),
                      ),
                      FadeHeading(
                        title: kSCourseWelcomeMessage,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: kHorizontal),
                        child: TextFormField(
                          initialValue: Constants.courseEditWelcome,
                          maxLength: 200,
                          maxLines: null,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            Constants.courseWelcomeMessage = value;
                          },
                          validator: Validator.validateWelcome,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                Container(
                  height: ScreenUtil().setHeight(50),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: RaisedButton(
                      onPressed: () {
                        _nextBtn();
                      },
                      color: kFbColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        kSave,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhitecolor,
                            fontSize: 22.sp,
                          ),
                        ),
                      )),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _nextBtn() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      User currentUser = FirebaseAuth.instance.currentUser!;
      //updating the database
      setState(() {
        _publishModal = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('sessionContent')
            .doc(currentUser.uid)
            .collection('courses')
            .doc(Constants.docId)
            .update({
          'pdesc': Constants.courseJobProfile,
          'topic': Constants.courseTopic,
          'sub': Constants.kCourseSubTopic,
          'desc': Constants.courseDesc,
          'name': Constants.kCourseName,
          'targ': FieldValue.arrayUnion(TargetedStudents.items),
          'obj': FieldValue.arrayUnion(Objective.items),
          'req': FieldValue.arrayUnion(Requirements.items),
          'inc': FieldValue.arrayUnion(Included.items),
          'lang': FieldValue.arrayUnion(SelectedLanguage.data),
          'level': FieldValue.arrayUnion(SelectedLevel.data),
          'cate': FieldValue.arrayUnion(SelectedCate.data),
          'pur': Constants.coursePurpose,
          'tmb': Constants.courseEditThumbnail,
          'prom': Constants.courseEditVideo,
          'amt': Constants.courseEditAmt,
          'cong': Constants.courseCongMessage,
          'wel': Constants.courseWelcomeMessage,
          'age': UploadVariables.ageRestriction,
          'age2': UploadVariables.childrenAdult,
        }).whenComplete(() {
          setState(() {
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

            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: kSUpdateSuccess,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Courses()));
        });
      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kSUpdateError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }
}
