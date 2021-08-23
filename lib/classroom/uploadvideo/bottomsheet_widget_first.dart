import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/validator.dart';

import 'package:sparks/classroom/uploadvideo/upload_display_details.dart';
import 'package:sparks/classroom/uploadvideo/uploadingscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/headings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadVideoFirst extends StatefulWidget {
  @override
  _UploadVideoFirstState createState() => _UploadVideoFirstState();
}

class _UploadVideoFirstState extends State<UploadVideoFirst> {
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
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  bool _autoValidate = false;
  Animation<double>? animation;
  AnimationController? controller;
  bool catVisible = false;
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

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
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: new Column(
                    children: <Widget>[
                      WidgetHeadings(
                        title: kliveformtitle,
                      ),
                      Container(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: kHorizontal),
                            child: TextFormField(
                              controller: _title,
                              maxLength: kSmaxlenthtitle,
                              autocorrect: true,
                              cursorColor: (kMaincolor),
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
                      WidgetHeadings(
                        title: kliveformdesc,
                      ),
                      Container(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: kHorizontal),
                            child: TextFormField(
                              controller: _desc,
                              maxLength: kSmaxlenghtdesc,
                              autocorrect: true,
                              cursorColor: (kMaincolor),
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
                      WidgetHeadings(
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

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: kHorizontal,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: 34.0,
                        width: 90.0,
                        child: RaisedButton(
                          elevation: 5.0,
                          color: kMaincolor,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: kBlackcolor)),
                          child: Text(
                            kNextbtn,
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                              color: kBlackcolor,
                            ),
                          ),
                          onPressed: _validateInputs,
                        ),
                      )),
                ),
              ),
            ],
          )),
    ));
  }

  void _validateInputs() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      if (UploadVariables.category == null || UploadVariables.category == "") {
        setState(() {
          catVisible = true;
        });
      } else {
        _timer.cancel();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: UploadDisplayDetails()));
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

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
                  padding: const EdgeInsets.all(15.0),
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
                Container(
                  width: double.maxFinite,
                  child: ListView.builder(
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
                      }),
                )
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
}
