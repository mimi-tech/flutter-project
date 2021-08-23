import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/course_widget/age_edit.dart';
import 'package:sparks/classroom/contents/course_widget/course_thumbnail.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';

import 'package:sparks/classroom/courses/constants.dart';

import 'package:sparks/classroom/courses/course_category.dart';

import 'package:sparks/classroom/courses/course_level_list.dart';
import 'package:sparks/classroom/courses/dialog_btn.dart';
import 'package:sparks/classroom/courses/langList.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseForms extends StatefulWidget {
  @override
  _CourseFormsState createState() => _CourseFormsState();
}

class _CourseFormsState extends State<CourseForms> {
  String? filter;
  List<String> items = [
    kSports,
    kEt,
    kSci,
    kFilm,
    kNews,
    kHs,
    kComedy,
    kMusic,
    kAe,
    kGaming,
    kTE,
    kEdu,
    kNa,
    kPb,
    kPA
  ];
  TextEditingController _purpose = TextEditingController();

  Widget space() {
    return SizedBox(height: ScreenUtil().setHeight(10));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: EditAppBar(
              detailsColor: kStabcolor,
              videoColor: kBlackcolor,
              updateColor: kBlackcolor,
              addColor: kBlackcolor,
              publishColor: kBlackcolor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  space(),
                  //ToDo:Language used in this course
                  FadeHeading(
                    title: kSCourseLang,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Container(
                      width: double.infinity,
                      //height: ScreenUtil().setHeight(100),
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          _showLang();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(kSCourseLang2,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kTextcolorhintcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    )),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                SvgPicture.asset(
                                  'images/classroom/edit_add.svg',
                                  color: kMaincolor,
                                ),
                              ],
                            ),
                            SelectedLanguage.data.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: SelectedLanguage.data.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title:
                                            Text(SelectedLanguage.data[index]),
                                        trailing: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                SelectedLanguage.data
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Icon(Icons.cancel)),
                                      );
                                    })
                                : Text(''),
                          ],
                        ),
                      ),
                    ),
                  ),
                  space(),
//ToDo:This course is made for who
                  FadeHeading(
                    title: kSCourseLevel,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Container(
                      width: double.infinity,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          _showLevel();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(kSCourseLevelText,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kTextcolorhintcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    )),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                SvgPicture.asset(
                                  'images/classroom/edit_add.svg',
                                  color: kMaincolor,
                                ),
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: SelectedLevel.data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(SelectedLevel.data[index]),
                                    trailing: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            SelectedLevel.data.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.cancel)),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ),

                  space(),
                  //ToDo:Course category list
                  FadeHeading(
                    title: kSCourseCategory,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Container(
                      width: double.infinity,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          _showCategory();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(kSCourseCategory2,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kTextcolorhintcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    )),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                SvgPicture.asset(
                                  'images/classroom/edit_add.svg',
                                  color: kMaincolor,
                                ),
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: SelectedCate.data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(SelectedCate.data[index]),
                                    trailing: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            SelectedCate.data.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.cancel)),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ),

                  EditCourseAge(),
                  space(),
                  //ToDo:Course main purpose
                  FadeHeading(
                    title: kSCoursePurpose,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextFormField(
                      initialValue: Constants.coursePurpose,
                      maxLength: 200,
                      maxLines: null,
                      autocorrect: true,
                      cursorColor: (kMaincolor),
                      style: UploadVariables.uploadfontsize,
                      decoration: Constants.kTopicDecoration,
                      onChanged: (String value) {
                        Constants.coursePurpose = value;
                      },
                    ),
                  ),

//ToDo:Next Button
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.15,
                  ),
                  CourseNextButton(
                    next: () {
                      _nextBtn();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.15,
                  ),
                ],
              ),
            )));
  }

  void _showLang() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              content: Column(
                children: <Widget>[
                  DialogBtn(
                    context: context,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                    child: TextFormField(
                        onChanged: (String value) {
                          Constants.searchText = value;
                        },
                        cursorColor: kMaincolor,
                        controller: Constants.searchController,
                        decoration: Constants.searchDecoration),
                  ),
                  Expanded(child: LanguageList()),
                ],
              ),
            ));
  }

  /// course level
  void _showLevel() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              content: CourseLevel(context: context),
              actions: <Widget>[
                DialogBtn(
                  context: context,
                ),
              ],
            ));
  }

  void _showCategory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              content: CourseCategory(),
              actions: <Widget>[
                DialogBtn(
                  context: context,
                ),
              ],
            ));
  }

  void _nextBtn() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    ///validating the user

    if (SelectedLanguage.data.isEmpty) {
      Fluttertoast.showToast(
          msg: kSCourseError7,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (SelectedCate.data.isEmpty) {
      Fluttertoast.showToast(
          msg: kSCourseError8,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (SelectedLevel.data.isEmpty) {
      Fluttertoast.showToast(
          msg: kSCourseError9,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (Constants.coursePurpose == null) {
      Fluttertoast.showToast(
          msg: kSCourseError10,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CourseThumbnail()));
    }
  }
}
