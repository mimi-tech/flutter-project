import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/courses/uploading_screen.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseMessage extends StatefulWidget {
  @override
  _CourseMessageState createState() => _CourseMessageState();
}

class _CourseMessageState extends State<CourseMessage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _congratulationMessage = TextEditingController();
  TextEditingController _message = TextEditingController();

  List<String> _amount = [
    'Free',
    '10.99',
    '19.99',
    '49.99',
    '50.99'
  ]; // Option 2
  String? _selectedAmount; // Option 2

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CourseAppBar(),
        body: SingleChildScrollView(
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
                      hint: Text(kSCourseAmount,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          )), // Not necessary for Option 1
                      value: _selectedAmount,
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _selectedAmount = newValue;
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
                        controller: _congratulationMessage,
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
                        controller: _message,
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
              CourseNextButton(
                next: () {
                  _nextBtn();
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
            ],
          ),
        ),
      ),
    );
  }

  void _nextBtn() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_selectedAmount == null) {
        Fluttertoast.showToast(
            msg: kSCoursePriceError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      } else {
        setState(() {
          Constants.courseAmount = _selectedAmount;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateCourses()));
      }
    }
  }
}
