import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_dialog_tv/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/classroom_contact.dart';
import 'package:sparks/classroom/golive/classroom_custom_listview.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/date_time_picker_widget2.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/classroom/uploadvideo/previewscreen.dart';
import 'package:sparks/classroom/uploadvideo/uploadingscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/agedialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';

import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploaduserselection.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
//import 'package:sparks/screens/create_profile.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadDisplayDetails extends StatefulWidget {
  @override
  _UploadDisplayDetailsState createState() => _UploadDisplayDetailsState();
}

class _UploadDisplayDetailsState extends State<UploadDisplayDetails> {
  static List<String> items = [
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  Animation<double>? animation;
  AnimationController? controller;
  bool catVisible = false;
  int? selectedRadio;
  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
    //Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhitecolor,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            ///upload progress class
            Container(
              child: UploadScreen(),
            ),
            Divider(
              color: kAshthumbnailcolor,
              thickness: kThickness,
            ),
            Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: new Column(
                  children: <Widget>[
                    ///title
                    FadeHeading(
                      title: kliveformtitle,
                    ),

                    Container(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: kHorizontal),
                          child: TextFormField(
                            autocorrect: true,
                            maxLength: kSmaxlenthtitle,
                            cursorColor: (kMaincolor),
                            initialValue: UploadVariables.title,
                            style: UploadVariables.uploadfontsize,
                            decoration: UploadVariables.kTextFieldDecoration,
                            onSaved: (String? value) {
                              UploadVariables.title = value;
                            },
                            validator: Validator.validateTitle,
                          ),
                        ),
                      ],
                    )),

                    ///description
                    FadeHeading(
                      title: kliveformdesc,
                    ),
                    Container(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: kHorizontal),
                          child: TextFormField(
                            autocorrect: true,
                            maxLength: kSmaxlenghtdesc,
                            cursorColor: (kMaincolor),
                            initialValue: UploadVariables.description,
                            style: UploadVariables.uploadfontsize,
                            decoration: UploadVariables.kDescFieldDecoration,
                            onSaved: (String? value) {
                              UploadVariables.description = value;
                            },
                            validator: Validator.validateDesc,
                          ),
                        ),
                      ],
                    )),

                    ///category
                    FadeHeading(
                      title: kCategoryText,
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: kHorizontal,
                      ),
                      child: GestureDetector(
                          onTap: () {
                            showCateList();
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: UploadVariables.category == null ||
                                  UploadVariables.category == ""
                              ? Text(
                                  kuploadcatehint,
                                  style: TextStyle(
                                    fontSize: kFontsize.sp,
                                    color: kTextcolorhintcolor,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  UploadVariables.category!,
                                  style: UploadVariables.uploadfontsize,
                                )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: kHorizontal,
                      ),
                      child: Divider(
                        color: catVisible == false
                            ? kAshthumbnailcolor
                            : kDivideerrorcolor,
                        thickness: kThickness,
                      ),
                    ),

                    Visibility(
                      visible: catVisible,
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: kHorizontal,
                        ),
                        child: Text(
                          kCatErrortext,
                          style: TextStyle(
                            fontSize: kErrorfont.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rajdhani',
                            color: kBlackcolor,
                          ),
                        ),
                      ),
                    )
                  ],
                )),

            ///date and time
            Container(
              child: DateTimePickerWidget2(title: kPublish),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: kHorizontal,
              ),
              child: Divider(
                color: kAshthumbnailcolor,
                thickness: kThickness,
              ),
            ),

            ///Visibility

            FadeHeading(
              title: kVisibility,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    /*CircularCheckBox(inactiveColor: kBlackcolor,
                          activeColor: kbtnsecond,
                          value: UploadVariables.isChecked, onChanged: (bool value) {
                            setState(() {
                              UploadVariables.isChecked = value;
                              UploadVariables.isPrivate = false;
                              UploadVariables.publicPrivate = "public";

                            });
                          }),*/

                    Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      activeColor: kbtnsecond,
                      onChanged: (dynamic val) {
                        UploadVariables.isChecked = true;
                        setSelectedRadio(val);
                        UploadVariables.isPrivate = false;
                        UploadVariables.publicPrivate = "public";
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            'images/classroom/world.svg',
                            width: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                            height: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          kPublic,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: kBlackcolor,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: kHorizontal,
                      ),
                      child: Text(
                        kPublichint,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: kTextcolorhintcolor,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    /*CircularCheckBox(inactiveColor: kBlackcolor,
        activeColor: kbtnsecond,
        value: UploadVariables.isPrivate, onChanged: (bool value) {
          setState(() {
            UploadVariables.isPrivate = value;
            UploadVariables.publicPrivate = "private";
            UploadVariables.isChecked = false;

          });
        }),*/
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      activeColor: kbtnsecond,
                      onChanged: (dynamic val) {
                        UploadVariables.isPrivate = true;
                        setSelectedRadio(val);
                        UploadVariables.publicPrivate = "private";
                        UploadVariables.isChecked = false;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            'images/classroom/lock.svg',
                            width: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                            height: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),

                        ///private
                        Text(
                          kPrivate,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: kBlackcolor,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Text(
                      kPrivatehint,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: kTextcolorhintcolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),

            Wrap(
              spacing: 10.0,
              children: <Widget>[
                ///Age limit
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(
                          color: UploadVariables.highlightAgeLimit == true
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2.0)),
                  onPressed: () {
                    ageLimit();
                  },
                  child: Text(
                    kAge,
                    style: UploadVariables.uploadbtnfontsize,
                  ),
                  color: kbtnsecond,
                ),

                ///contacts
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onPressed: () {
                    _selectContacts();
                  },
                  child: Wrap(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      Text(
                        kContacts,
                        style: UploadVariables.uploadbtnfontsize,
                      )
                    ],
                  ),
                  color: UploadVariables.isChecked == true
                      ? kMaincolor
                      : kSelectbtncolor,
                ),

                ///view selected
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(4.0),
                  ),
                  onPressed: () {
                    userSelection();
                  },
                  child: Text(
                    kViews,
                    style: UploadVariables.uploadbtnfontsize,
                  ),
                  color: UploadVariables.isChecked == true
                      ? kMaincolor
                      : kSelectbtncolor,
                )
              ],
            ),
            Divider(
              color: kAshthumbnailcolor,
              thickness: kThickness,
            ),

            SizedBox(
              height: 10.0,
            ),

            ///horizontal listView showing selected contacts
            Visibility(
              visible: ufriends.litems.isEmpty ? false : true,
              child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: UserFriendsSelected()),
            ),
            SizedBox(
              height: 10.0,
            ),

            /// continue raised button
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              width: double.infinity,
              height: ScreenUtil().setHeight(60),
              child: RaisedButton(
                onPressed: () {
                  _validateInputs();
                },
                child: Text(
                  kContbtn,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: kBlackcolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: kSsuploadcontbtn,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
          ],
        )),
      ),
    );
  }

  ///validating form
  Future<void> _validateInputs() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      if (UploadVariables.childrenAdult == null ||
          UploadVariables.childrenAdult == "") {
        YYAlertDialogWithDuration();
        setState(() {
          UploadVariables.highlightAgeLimit = true;
        });
      } else {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: PreviewScreen()));
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// category list
  void showCateList() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 42,
                        color: kBlackcolor,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index],
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                              color: kBlackcolor,
                            )),
                        onTap: () => _selectedICountry(context, items[index]),
                      );
                    })
              ],
            ));
  }

  _selectedICountry(BuildContext context, String item) {
    Navigator.pop(context);
    setState(() {
      UploadVariables.category = item;
      catVisible = false;
    });
  }

  ///Age limit method
  void ageLimit() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  AgeDialog(
                    checkAge: () {
                      if ((UploadVariables.ageRestriction == null) ||
                          (UploadVariables.childrenAdult == null)) {
                        Fluttertoast.showToast(
                            msg: kageLimitError,
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: kBlackcolor,
                            textColor: kFbColor);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                ]));
  }

  YYDialog YYAlertDialogWithDuration() {
    return YYDialog().build()
      ..width = 220
      ..borderRadius = 4.0
      ..gravityAnimationEnable = true
      ..gravity = Gravity.left
      ..duration = Duration(milliseconds: 600)
      ..text(
        padding: EdgeInsets.all(18.0),
        text: kAgeLimit,
        fontSize: kFontsize.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Rajdhani',
        color: kSelectbtncolor,
      )
      ..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: kAgeLimitText,
        fontSize: kFontsize.sp,
        fontWeight: FontWeight.normal,
        fontFamily: 'Rajdhani',
        color: kBlackcolor.withOpacity(0.6),
      )
      ..doubleButton(
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: "OK",
        color1: Colors.deepPurpleAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
      )
      ..show();
  }

  ///user selection contact
  void _selectContacts() {
    if (UploadVariables.isPrivate == true) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: ClassroomContact()));
    }
  }

  void userSelection() {
    if ((UploadVariables.isPrivate == true) && (ufriends.litems.isNotEmpty)) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: UploadUserSelections()));
    }
  }
}
