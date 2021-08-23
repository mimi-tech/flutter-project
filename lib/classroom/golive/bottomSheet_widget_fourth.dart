import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog_tv/flutter_custom_dialog.dart';
import 'package:flutter_custom_dialog_tv/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sparks/classroom/golive/classroom_custom_listview.dart';
import 'package:sparks/classroom/golive/live_congratulation.dart';
import 'package:sparks/classroom/golive/publish_live.dart';
import 'package:sparks/classroom/golive/widget/visibility.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';

import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class BottomSheetWidgetFourth extends StatefulWidget {
  const BottomSheetWidgetFourth({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetFourthState createState() =>
      _BottomSheetWidgetFourthState();
}

class _BottomSheetWidgetFourthState extends State<BottomSheetWidgetFourth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  Future getImageFromGallery() async {
    /* var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      Variables.imageURI = image;
    });*/
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

  bool highlightAgeLimit = false;

  bool isVisible = true;
  bool showSelectBtn = true;

  bool _autoValidate = false;
  bool fontScale = true;
  final now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  color: kWhitecolor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(kmodalborderRadius),
                    topLeft: Radius.circular(kmodalborderRadius),
                  )),
              child: Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: kHorizontal,
                    horizontal: kHorizontal,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          'images/classroom/video.svg',
                          width:
                              ScreenUtil().setHeight(klivebtn.roundToDouble()),
                          height:
                              ScreenUtil().setHeight(klivebtn.roundToDouble()),
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
                Container(
                  height: 1.0,
                  color: kAshthumbnailcolor,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: kHorizontal,
                    ),
                    child: Text(
                      klivethumbnailtitle,
                      style: TextStyle(
                        fontSize: kFontsize.sp,
                        color: KLightermaincolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 5.0,
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
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        getImageFromGallery();
                                      },
                                      child: Image.file(
                                        Variables.imageURI!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                kThumbnailSize,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                kThumbnailSize2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Variables.imageURI = null;
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: kFbColor,
                                        )),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Variables.imageURI = null;
                                        });
                                      },
                                      child: Text(
                                        'Delete',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: kBlackcolor,
                                          fontSize: kFontsize.sp,
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: kHorizontal,
                  ),
                  height: 1.0,
                  color: kAshthumbnailcolor,
                ),
                Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: kHorizontal,
                            ),
                            child: Text(
                              kliveformtitle,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: KLightermaincolor,
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                autocorrect: true,
                                maxLength: kSmaxlenthtitle,
                                initialValue: Variables.title,
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
                              horizontal: kHorizontal,
                            ),
                            child: Text(
                              kliveformdesc,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: KLightermaincolor,
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                autocorrect: true,
                                maxLength: kSmaxlenghtdesc,
                                initialValue: Variables.desc,
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
                              horizontal: kHorizontal,
                            ),
                            child: Text(
                              kliveformdatetime,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: KLightermaincolor,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: kHorizontal),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                autocorrect: true,
                                initialValue: Variables.dateFormat
                                    .format(Variables.selectedDate),
                                //enabled:false,
                                readOnly: true,
                                cursorColor: (kMaincolor),
                                style: TextStyle(
                                  color: (kBlackcolor),
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: kFontsize.sp,
                                ),
                                decoration: Variables.liveDescDecoration,

                                validator: Validator.validateDesc,
                              ),
                            ),
                          ],
                        )),
                        space(),
                        Container(
                          child: ContactClass(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Visibility(
                          visible: ufriends.litems.isEmpty ? false : true,
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: kHorizontal,
                              ),
                              child: UserFriendsSelected()),
                        ),
                        space(),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: kHorizontal,
                            vertical: 10.0,
                          ),
                          child: SizedBox(
                            height: ScreenUtil().setHeight(60),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              color: kMaincolor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Text(
                                kContbtn,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                  color: kBlackcolor,
                                ),
                              ),
                              onPressed: _fourthModal,
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  //ToDo: check if user checked all friends clear the friends selected list

/*Validating the continue btn*/
  Future<void> _fourthModal() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      bool checkDate = Variables.selectedDate.isBefore(now);
      bool checkDateAfter = Variables.selectedDate.isAfter(now);
      if (UploadVariables.childrenAdult == null ||
          UploadVariables.childrenAdult == "") {
        YYAlertDialogWithDuration();
        setState(() {
          UploadVariables.highlightAgeLimit = true;
        });
      } else {
        if ((checkDate == true) &&
            (UploadVariables.childrenAdult != null ||
                UploadVariables.childrenAdult != "")) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Congratulation()));
        }
        if ((checkDateAfter == true) &&
            (Variables.imageURI != null) &&
            (UploadVariables.childrenAdult != null &&
                UploadVariables.childrenAdult != "")) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CongratulationPublish()));
        } else if ((Variables.imageURI == null) && (checkDateAfter == true)) {
          Fluttertoast.showToast(
              msg: kClThumbnailerror,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      }
    } else {
      setState(() => _autoValidate = true);
    }
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
}
