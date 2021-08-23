import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sparks/classroom/golive/bottomSheet_widget_third.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'dart:async';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class BottomSheetWidgetSecond extends StatefulWidget {
  const BottomSheetWidgetSecond({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetSecondState createState() =>
      _BottomSheetWidgetSecondState();
}

class _BottomSheetWidgetSecondState extends State<BottomSheetWidgetSecond>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  late AnimationController controller;
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // #docregion addListener
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  Future getImageFromGallery() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File file = await FilePicker.getFile(
    //   type: FileType.image,
    // );

    File? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    String _path = file.toString();

    String fileName = _path.split('/').last;

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        Variables.imageURI = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  bool _isVisible = true;

  void showToastThird() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
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
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: kHorizontal,
                      horizontal: kHorizontal,
                    ),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            'images/classroom/video.svg',
                            width: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                            height: ScreenUtil()
                                .setHeight(klivebtn.roundToDouble()),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          child: Text(
                            klivetitle,
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              color: kBlackcolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: kAshthumbnailcolor,
                    thickness: 1.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: kHorizontal,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          if (Variables.imageURI == null)
                            InkWell(
                              onTap: () {
                                getImageFromGallery();
                              },
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                      'images/classroom/tumbnail_picker.png'),
                                  height: 44.0,
                                  width: 45.0,
                                ),
                              ),
                            )
                          else
                            Column(
                              children: <Widget>[
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      getImageFromGallery();
                                    },
                                    child: Image.file(
                                      Variables.imageURI!,
                                      width: 45.0,
                                      height: 44.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: kHorizontal,
                      ),
                      child: Text(
                        klivethumbnailtitle,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kAshmainthumbnailcolor,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: kHorizontal,
                    ),
                    height: 1,
                    color: kAshthumbnailcolor,
                  ),
                  Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: new Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: kHorizontal,
                              ),
                              child: Text(
                                kliveformtitle,
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  color: kMaincolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: kHorizontal),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: true,
                                  controller: _title,
                                  maxLength: kSmaxlenthtitle,
                                  cursorColor: (kMaincolor),
                                  style: TextStyle(
                                    color: (kBlackcolor),
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: kFontsize.sp,
                                  ),
                                  decoration: Variables.liveTitleDecoration,
                                  onSaved: (String? value) {
                                    Variables.title = value;
                                  },
                                  validator: Validator.validateTitle,
                                ),
                              ),
                            ],
                          )),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: kHorizontal,
                              ),
                              child: Text(
                                kliveformdesc,
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  color: kMaincolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: kHorizontal),
                                child: TextFormField(
                                  autocorrect: true,
                                  controller: _desc,
                                  maxLength: kSmaxlenghtdesc,
                                  cursorColor: (kMaincolor),
                                  style: TextStyle(
                                    color: (kBlackcolor),
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: kFontsize.sp,
                                  ),
                                  decoration: Variables.liveDescDecoration,
                                  onSaved: (String? value) {
                                    Variables.desc = value;
                                  },
                                  validator: Validator.validateDesc,
                                ),
                              ),
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
                                  padding: const EdgeInsets.all(0.0),
                                  child: SizedBox(
                                    height: 34.0,
                                    width: 90.0,
                                    child: RaisedButton(
                                      elevation: 5.0,
                                      color: kMaincolor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                ])),
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => BottomSheetWidgetThird());
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
