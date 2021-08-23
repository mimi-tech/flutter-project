import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/classroom/golive/bottomSheet_widget_fourth.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/date_time_picker_widget2.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class BottomSheetWidgetThird extends StatefulWidget {
  const BottomSheetWidgetThird({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetThirdState createState() => _BottomSheetWidgetThirdState();
}

class _BottomSheetWidgetThirdState extends State<BottomSheetWidgetThird> {
  bool _isVisible = true;
  bool fontScale = true;
  void showToastFourth() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Future getImageFromGallery() async {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, right: 4.0),
        child: Container(
          decoration: BoxDecoration(
              color: kWhitecolor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(kmodalborderRadius),
                topLeft: Radius.circular(kmodalborderRadius),
              )),
          child: Column(
            children: <Widget>[
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
                        width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
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
                margin: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 0.0,
                ),
                height: 1.0,
                color: kLiveunberlinecolor,
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
                      color: kLightmaincolor,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: kHorizontal,
                ),
                height: 1.5,
                color: kAshthumbnailcolor,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 8.0,
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: kHorizontal,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          Variables.title!,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rajdhani',
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: kHorizontal,
                ),
                height: 1.5,
                color: kAshthumbnailcolor,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 8.0,
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: kHorizontal,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          Variables.desc!,
                          style: TextStyle(
                            fontSize: kFontsize.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rajdhani',
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: kHorizontal,
                ),
                height: 1.5,
                color: kAshthumbnailcolor,
              ),
              Container(
                child: DateTimePickerWidget2(
                  title: kChoosedatetext,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 0.0,
                ),
                height: 1.0,
                color: kLiveunberlinecolor,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: ScreenUtil().setHeight(70),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: kHorizontal,
                  ),
                  child: new RaisedButton(
                    elevation: 5.0,
                    color: kMaincolor,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      kNextbtn,
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
          ),
        ),
      ),
    );
  }

  _fourthModal() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BottomSheetWidgetFourth()));
  }
}
